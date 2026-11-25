// Port of f.java + g.java + c.java — Landscape Widescreen 512x250 State Machine, Touch-First Menus, and Key Masks
import CoreGraphics
import Foundation

public struct KeyBits {
    public static let up     = 1 << 0
    public static let down   = 1 << 1
    public static let left   = 1 << 2
    public static let right  = 1 << 3
    public static let fire   = 1 << 4
    public static let num1   = 1 << 5
    public static let num2   = 1 << 6
    public static let num3   = 1 << 7
    public static let num4   = 1 << 8
    public static let num5   = 1 << 9
    public static let num6   = 1 << 10
    public static let num7   = 1 << 11
    public static let num8   = 1 << 12
    public static let num9   = 1 << 13
    public static let num0   = 1 << 14
    public static let star   = 1 << 15
    public static let pound  = 1 << 16
    public static let lsk    = 1 << 17
    public static let rsk    = 1 << 18
}

public enum GameScreenState: Int {
    case splash = 0
    case menu = 1
    case loading = 3
    case playing = 4
    case paused = 5
    case outcome = 6
}

public enum MenuId: Int {
    case main = 0
    case campaign = 1
    case selectMission = 2
    case skirmish = 3
    case saveLoad = 4
    case settings = 5
    case instructions = 6
    case about = 7
    case pauseMenu = 8
    case saveSlotPicker = 9
}

public final class GameMenuNode {
    public var id: MenuId
    public weak var parent: GameMenuNode?
    public var title: String
    public var items: [String]
    public var selectedIndex: Int = 0
    public var isScrollText: Bool = false
    public var scrollOffset: Int = 0

    public init(id: MenuId, parent: GameMenuNode? = nil, title: String, items: [String], isScrollText: Bool = false) {
        self.id = id
        self.parent = parent
        self.title = title
        self.items = items
        self.isScrollText = isScrollText
    }
}

public final class MenuCoordinator {
    // Port of f.f cheat sequence: [4,8,4,4,8,8,4,4,4,8,8,8,16384]
    public static let cheatSequence: [Int] = [4, 8, 4, 4, 8, 8, 4, 4, 4, 8, 8, 8, 16384]

    public let assets: GameAssets
    public let font: BitmapFont
    public let localization: Localization
    public let tables: GameTables
    public let saveStore: SaveStore
    public let audio: MidiSynthEngine
    public let engine: GameEngine
    public let renderer: SoftwareRenderer

    public var screenState: GameScreenState = .splash
    public var splashTick: Int = 0
    public var settings: SettingsSaveData
    public var currentMenu: GameMenuNode!

    public var skirmishMapIndex: Int = 0
    public var skirmishFaction: Int = 0
    public var skirmishDifficulty: Int = 1
    public var savedAudioSlot: Int = -1
    private var cheatProgress: Int = 0

    private var splashImage: GameSprite?
    private var brandImages: [GameSprite] = []
    private var menuHeaderBanner: GameSprite?

    public var onHapticPulse: (() -> Void)?

    public init(
        assets: GameAssets = .shared,
        saveDirectory: URL? = nil,
        skipSplash: Bool = false
    ) throws {
        self.assets = assets
        self.font = BitmapFont(assets: assets)
        self.localization = Localization(assets: assets)
        self.tables = try GameTables(assets: assets)
        self.saveStore = SaveStore(directory: saveDirectory)
        self.audio = MidiSynthEngine()
        self.settings = saveStore.loadSettings()
        self.audio.isSoundEnabled = settings.soundEnabled
        self.engine = GameEngine(assets: assets, tables: tables, localization: localization)
        self.renderer = SoftwareRenderer(width: XSMaxLayout.gameLogicalWidth, height: XSMaxLayout.gameLogicalHeight, font: font)

        self.splashImage = GameSprite(filename: "splash.png", assets: assets)
        for i in 0..<3 {
            if let b = GameSprite(filename: "brand\(i).png", assets: assets) { brandImages.append(b) }
        }
        self.menuHeaderBanner = GameSprite(resId: 46, assets: assets)
        self.currentMenu = buildMainMenu()

        self.engine.onPauseRequested = { [weak self] in
            guard let self = self else { return }
            self.screenState = .paused
            self.currentMenu = self.buildPauseMenu()
        }

        if skipSplash {
            transitionToMainMenu()
        }
    }

    public static func mapKeyToBitmask(_ keyCode: Int) -> Int {
        switch keyCode {
        case -1, 50: return KeyBits.up | (keyCode == 50 ? KeyBits.num2 : 0)
        case -2, 56: return KeyBits.down | (keyCode == 56 ? KeyBits.num8 : 0)
        case -3, 52: return KeyBits.left | (keyCode == 52 ? KeyBits.num4 : 0)
        case -4, 54: return KeyBits.right | (keyCode == 54 ? KeyBits.num6 : 0)
        case -5, 53: return KeyBits.fire | (keyCode == 53 ? KeyBits.num5 : 0)
        case 49: return KeyBits.num1
        case 51: return KeyBits.num3
        case 55: return KeyBits.num7
        case 57: return KeyBits.num9
        case 48: return KeyBits.num0
        case 42: return KeyBits.star
        case 35: return KeyBits.pound
        case -6: return KeyBits.lsk
        case -7: return KeyBits.rsk
        default: return 0
        }
    }

    public func tick50ms() {
        switch screenState {
        case .splash:
            splashTick += 1
            if splashTick >= 35 {
                transitionToMainMenu()
            }
        case .playing:
            engine.updateTick()
            if engine.outcome != .playing {
                screenState = .outcome
                if engine.isCampaign && engine.outcome == .victory {
                    settings.completedCampaignMask |= (1 << engine.campaignMission)
                    settings.maxUnlockedCampaign = max(settings.maxUnlockedCampaign, min(15, engine.campaignMission + 2))
                    saveStore.saveSettings(settings)
                }
            }
        default:
            break
        }
    }

    public func transitionToMainMenu() {
        screenState = .menu
        currentMenu = buildMainMenu()
        audio.playEvent(0, savedTrackSlot: &savedAudioSlot, pausedByMenu: false, assets: assets)
    }

    public func handleKeyCode(_ keyCode: Int) {
        let mask = Self.mapKeyToBitmask(keyCode)

        if screenState == .playing && mask != 0 {
            let basicDir = mask & (KeyBits.left | KeyBits.right | KeyBits.num0)
            if basicDir == Self.cheatSequence[cheatProgress] {
                cheatProgress += 1
                if cheatProgress == Self.cheatSequence.count {
                    cheatProgress = 0
                    engine.playerResources[0][0] += 10000
                    engine.playerResources[0][1] += 10000
                    engine.playerResources[0][2] += 10000
                    engine.showPopup(localization.text(297))
                    return
                }
            } else if basicDir != 0 {
                cheatProgress = (basicDir == Self.cheatSequence[0]) ? 1 : 0
            }
        }

        switch screenState {
        case .splash:
            if mask != 0 { transitionToMainMenu() }
        case .menu, .paused:
            handleMenuKey(mask: mask)
        case .outcome:
            if (mask & (KeyBits.fire | KeyBits.lsk | KeyBits.rsk)) != 0 {
                transitionToMainMenu()
            }
        case .playing:
            if (mask & KeyBits.rsk) != 0 {
                screenState = .paused
                currentMenu = buildPauseMenu()
            } else if (mask & KeyBits.lsk) != 0 {
                engine.triggerActiveCommand()
            } else {
                engine.handleKeyPress(mask)
            }
        case .loading:
            break
        }
    }

    // Touch-first Landscape screen handler (512 x 250)
    public func handleCanvasTap(x: Int, y: Int) {
        if settings.vibrationEnabled { onHapticPulse?() }
        switch screenState {
        case .splash:
            transitionToMainMenu()
        case .playing:
            engine.handleCanvasTap(screenX: x, screenY: y)
        case .menu, .paused:
            handleMenuTouch(x: x, y: y)
        case .outcome:
            transitionToMainMenu()
        case .loading:
            break
        }
    }

    public func handleMenuScroll(deltaY: Int) {
        guard (screenState == .menu || screenState == .paused) else { return }
        if currentMenu.isScrollText {
            let maxOff = max(0, currentMenu.items.count - 9)
            if deltaY > 12 { currentMenu.scrollOffset = min(maxOff, currentMenu.scrollOffset + 1) }
            else if deltaY < -12 { currentMenu.scrollOffset = max(0, currentMenu.scrollOffset - 1) }
        }
    }

    private func handleMenuTouch(x: Int, y: Int) {
        // Bottom LSK / RSK touch boxes: left [8..112, 222..246], right [400..504, 222..246]
        if y >= 220 {
            if x <= 125 {
                if currentMenu.isScrollText {
                    currentMenu.scrollOffset = max(0, currentMenu.scrollOffset - 3)
                } else {
                    activateCurrentMenuItem()
                }
                return
            }
            if x >= 387 {
                if currentMenu.isScrollText && x <= 445 {
                    let maxOff = max(0, currentMenu.items.count - 9)
                    currentMenu.scrollOffset = min(maxOff, currentMenu.scrollOffset + 3)
                } else {
                    handleMenuKey(mask: KeyBits.rsk)
                }
                return
            }
        }

        // Scrollable text view: tap top half scrolls up, bottom half scrolls down, or back
        if currentMenu.isScrollText {
            if y < 125 {
                currentMenu.scrollOffset = max(0, currentMenu.scrollOffset - 3)
            } else {
                let maxOff = max(0, currentMenu.items.count - 9)
                if currentMenu.scrollOffset < maxOff {
                    currentMenu.scrollOffset = min(maxOff, currentMenu.scrollOffset + 3)
                } else {
                    handleMenuKey(mask: KeyBits.rsk)
                }
            }
            return
        }

        // List item hit test inside panel box [66..446, 52..218]
        let listTop = 52
        let rowH = 21
        let maxVisible = 7
        if x >= 56 && x <= 456 && y >= listTop && y < listTop + maxVisible * rowH {
            let visibleStart = menuScrollWindowStart(total: currentMenu.items.count, selected: currentMenu.selectedIndex, window: maxVisible)
            let rowIdx = visibleStart + (y - listTop) / rowH
            if rowIdx >= 0 && rowIdx < currentMenu.items.count {
                currentMenu.selectedIndex = rowIdx
                if currentMenu.id == .skirmish && rowIdx < 3 && x < 240 {
                    adjustSkirmishOption(delta: -1)
                } else {
                    activateCurrentMenuItem()
                }
            }
        }
    }

    private func menuScrollWindowStart(total: Int, selected: Int, window: Int) -> Int {
        if total <= window { return 0 }
        let half = window / 2
        return max(0, min(total - window, selected - half))
    }

    private func handleMenuKey(mask: Int) {
        if (mask & KeyBits.up) != 0 {
            if currentMenu.isScrollText {
                currentMenu.scrollOffset = max(0, currentMenu.scrollOffset - 1)
            } else if !currentMenu.items.isEmpty {
                currentMenu.selectedIndex = (currentMenu.selectedIndex - 1 + currentMenu.items.count) % currentMenu.items.count
            }
        } else if (mask & KeyBits.down) != 0 {
            if currentMenu.isScrollText {
                currentMenu.scrollOffset = min(max(0, currentMenu.items.count - 9), currentMenu.scrollOffset + 1)
            } else if !currentMenu.items.isEmpty {
                currentMenu.selectedIndex = (currentMenu.selectedIndex + 1) % currentMenu.items.count
            }
        } else if (mask & (KeyBits.left | KeyBits.right)) != 0 {
            if currentMenu.id == .skirmish {
                let delta = (mask & KeyBits.right) != 0 ? 1 : -1
                adjustSkirmishOption(delta: delta)
            }
        } else if (mask & (KeyBits.fire | KeyBits.lsk)) != 0 {
            activateCurrentMenuItem()
        } else if (mask & KeyBits.rsk) != 0 {
            if screenState == .paused {
                if let p = currentMenu.parent { currentMenu = p }
                else { screenState = .playing }
            } else if let p = currentMenu.parent {
                currentMenu = p
            }
        }
    }

    private func adjustSkirmishOption(delta: Int) {
        switch currentMenu.selectedIndex {
        case 0: skirmishMapIndex = (skirmishMapIndex + delta + 4) % 4
        case 1: skirmishFaction = (skirmishFaction + delta + 3) % 3
        case 2: skirmishDifficulty = (skirmishDifficulty + delta + 3) % 3
        default: break
        }
        currentMenu.items = buildSkirmishItems()
    }

    private func activateCurrentMenuItem() {
        switch currentMenu.id {
        case .main:
            switch currentMenu.selectedIndex {
            case 0: currentMenu = buildCampaignMenu(parent: currentMenu)
            case 1: currentMenu = buildSkirmishMenu(parent: currentMenu)
            case 2: currentMenu = buildSaveLoadMenu(parent: currentMenu, isSaving: false)
            case 3: currentMenu = buildSettingsMenu(parent: currentMenu)
            case 4: currentMenu = buildInstructionsMenu(parent: currentMenu)
            case 5: currentMenu = buildAboutMenu(parent: currentMenu)
            case 6: transitionToMainMenu()
            default: break
            }
        case .campaign:
            switch currentMenu.selectedIndex {
            case 0:
                screenState = .playing
                engine.startCampaign(mission: 0, difficulty: 1)
                audio.playEvent(1, savedTrackSlot: &savedAudioSlot, pausedByMenu: false, assets: assets)
            case 1:
                let m = max(0, min(14, settings.maxUnlockedCampaign - 1))
                screenState = .playing
                engine.startCampaign(mission: m, difficulty: 1)
                audio.playEvent(1, savedTrackSlot: &savedAudioSlot, pausedByMenu: false, assets: assets)
            case 2:
                currentMenu = buildMissionSelectMenu(parent: currentMenu)
            default: break
            }
        case .selectMission:
            screenState = .playing
            engine.startCampaign(mission: currentMenu.selectedIndex, difficulty: 1)
            audio.playEvent(1, savedTrackSlot: &savedAudioSlot, pausedByMenu: false, assets: assets)
        case .skirmish:
            if currentMenu.selectedIndex < 3 {
                adjustSkirmishOption(delta: 1)
            } else {
                screenState = .playing
                engine.startSkirmish(mapChoice: skirmishMapIndex, faction: skirmishFaction, difficulty: skirmishDifficulty)
                audio.playEvent(2, savedTrackSlot: &savedAudioSlot, pausedByMenu: false, assets: assets)
            }
        case .settings:
            switch currentMenu.selectedIndex {
            case 0:
                settings.soundEnabled.toggle()
                audio.isSoundEnabled = settings.soundEnabled
                if settings.soundEnabled { audio.playEvent(0, savedTrackSlot: &savedAudioSlot, pausedByMenu: false, assets: assets) }
            case 1:
                settings.vibrationEnabled.toggle()
            case 2:
                settings.hintsEnabled.toggle()
            default: break
            }
            saveStore.saveSettings(settings)
            currentMenu.items = buildSettingsItems()
        case .pauseMenu:
            switch currentMenu.selectedIndex {
            case 0: screenState = .playing
            case 1: currentMenu = buildSaveLoadMenu(parent: currentMenu, isSaving: true)
            case 2: currentMenu = buildSettingsMenu(parent: currentMenu)
            case 3: transitionToMainMenu()
            default: break
            }
        case .saveLoad:
            let slot = currentMenu.selectedIndex
            if let data = saveStore.loadSlotData(slot), engine.deserializeState(data: data) {
                screenState = .playing
                audio.playEvent(1, savedTrackSlot: &savedAudioSlot, pausedByMenu: false, assets: assets)
            }
        case .saveSlotPicker:
            let slot = currentMenu.selectedIndex
            let label = engine.isCampaign ? localization.format(19, ["\(engine.campaignMission + 1)"]) : localization.text(4)
            saveStore.saveSlotData(slot, data: engine.serializeState(title: label))
            screenState = .playing
            engine.showPopup(localization.text(112))
        case .instructions, .about:
            currentMenu = currentMenu.parent ?? buildMainMenu()
        }
    }

    // MARK: - Menu Builders

    private func buildMainMenu() -> GameMenuNode {
        GameMenuNode(id: .main, title: localization.text(2), items: [
            localization.text(3),
            localization.text(4),
            localization.text(5),
            localization.text(6),
            localization.text(7),
            localization.text(8),
            localization.text(9)
        ])
    }

    private func buildCampaignMenu(parent: GameMenuNode) -> GameMenuNode {
        GameMenuNode(id: .campaign, parent: parent, title: localization.text(3), items: [
            localization.text(12),
            localization.text(11),
            localization.text(13)
        ])
    }

    private func buildMissionSelectMenu(parent: GameMenuNode) -> GameMenuNode {
        let unlocked = max(1, min(15, settings.maxUnlockedCampaign))
        let items = (1...unlocked).map { localization.format(19, ["\($0)"]) }
        return GameMenuNode(id: .selectMission, parent: parent, title: localization.text(13), items: items)
    }

    private func buildSkirmishMenu(parent: GameMenuNode) -> GameMenuNode {
        GameMenuNode(id: .skirmish, parent: parent, title: localization.text(4), items: buildSkirmishItems())
    }

    private func buildSkirmishItems() -> [String] {
        let mapName = localization.text(219 + skirmishMapIndex)
        let diffLabel = [localization.text(205), localization.text(206), localization.text(207)][skirmishDifficulty % 3]
        let facLabel = localization.text(224 + skirmishFaction % 3)
        return [
            "< \(localization.text(20)): \(mapName) >",
            "< \(localization.text(21)): \(facLabel) >",
            "< \(localization.text(22)): \(diffLabel) >",
            localization.text(332)
        ]
    }

    private func buildSaveLoadMenu(parent: GameMenuNode, isSaving: Bool) -> GameMenuNode {
        let items = (0..<3).map { slot -> String in
            if let summary = saveStore.slotSummary(slot) { return "\(slot + 1). \(summary)" }
            return "\(slot + 1). \(localization.text(15))"
        }
        return GameMenuNode(id: isSaving ? .saveSlotPicker : .saveLoad, parent: parent, title: localization.text(isSaving ? 29 : 5), items: items)
    }

    private func buildSettingsMenu(parent: GameMenuNode) -> GameMenuNode {
        GameMenuNode(id: .settings, parent: parent, title: localization.text(6), items: buildSettingsItems())
    }

    private func buildSettingsItems() -> [String] {
        [
            localization.text(settings.soundEnabled ? 31 : 32),
            localization.text(settings.vibrationEnabled ? 33 : 34),
            localization.text(settings.hintsEnabled ? 37 : 38)
        ]
    }

    private func buildInstructionsMenu(parent: GameMenuNode) -> GameMenuNode {
        let raw = [41, 42, 43, 44, 45, 46, 47, 48].map { localization.text($0) }.filter { !$0.isEmpty }.joined(separator: "\n")
        let wrapped = localization.wrapText(raw, maxWidth: 380, fontId: 1, font: font)
        return GameMenuNode(id: .instructions, parent: parent, title: localization.text(7), items: wrapped, isScrollText: true)
    }

    private func buildAboutMenu(parent: GameMenuNode) -> GameMenuNode {
        let raw = localization.format(39, [localization.text(1), "1.0.0"])
        let wrapped = localization.wrapText(raw, maxWidth: 380, fontId: 1, font: font)
        return GameMenuNode(id: .about, parent: parent, title: localization.text(8), items: wrapped, isScrollText: true)
    }

    private func buildPauseMenu() -> GameMenuNode {
        GameMenuNode(id: .pauseMenu, parent: nil, title: localization.text(10), items: [
            localization.text(11),
            localization.text(5),
            localization.text(6),
            localization.text(16)
        ])
    }

    // MARK: - Master Frame Render (512 x 250 Landscape)

    public func renderFrame() -> PixelSurface {
        let w = XSMaxLayout.gameLogicalWidth
        let h = XSMaxLayout.gameLogicalHeight
        switch screenState {
        case .splash:
            renderer.setColor(0x000000)
            renderer.fillRect(0, 0, w, h)
            if splashTick < 15, let b = brandImages.first {
                renderer.drawSprite(b, x: w / 2, y: h / 2, anchor: Anchor.hcenter | Anchor.vcenter)
            } else if let s = splashImage {
                renderer.drawSprite(s, x: w / 2, y: h / 2, anchor: Anchor.hcenter | Anchor.vcenter)
            }
        case .menu, .loading:
            renderer.setColor(0x140E08)
            renderer.fillRect(0, 0, w, h)
            if let s = splashImage {
                renderer.drawSprite(s, x: w / 2, y: h / 2, anchor: Anchor.hcenter | Anchor.vcenter)
            }
            if let hdr = menuHeaderBanner {
                renderer.drawSprite(hdr, x: w / 2, y: 0, anchor: Anchor.hcenter | Anchor.top)
            }
            renderMenuOverlay(g: renderer)
        case .playing:
            engine.render(to: renderer)
        case .paused:
            engine.render(to: renderer)
            renderMenuOverlay(g: renderer)
        case .outcome:
            engine.render(to: renderer)
            renderer.setColor(0x1B140C)
            renderer.fillRect(106, 65, 300, 110)
            renderer.setColor(0xD4AF37)
            renderer.drawRect(106, 65, 300, 110)
            let msg = localization.text(engine.outcome == .victory ? 118 : 119)
            renderer.drawString(fontId: 0, msg, x: w / 2, y: 90, anchor: Anchor.hcenter | Anchor.top)
            renderer.drawString(fontId: 1, localization.text(113), x: w / 2, y: 136, anchor: Anchor.hcenter | Anchor.top)
        }
        return renderer.surface
    }

    private func renderMenuOverlay(g: SoftwareRenderer) {
        let cx = XSMaxLayout.gameLogicalWidth / 2
        g.setColor(0x1E150B)
        g.fillRect(56, 22, 400, 198)
        g.setColor(0xB8914E)
        g.drawRect(56, 22, 400, 198)

        g.drawString(fontId: 0, currentMenu.title, x: cx, y: 28, anchor: Anchor.hcenter | Anchor.top)

        if currentMenu.isScrollText {
            let maxLines = 9
            for row in 0..<maxLines {
                let idx = currentMenu.scrollOffset + row
                guard idx < currentMenu.items.count else { break }
                g.drawString(fontId: 1, currentMenu.items[idx], x: 68, y: 52 + row * 17, anchor: Anchor.left | Anchor.top)
            }
        } else {
            let maxVisible = 7
            let start = menuScrollWindowStart(total: currentMenu.items.count, selected: currentMenu.selectedIndex, window: maxVisible)
            for slot in 0..<maxVisible {
                let idx = start + slot
                guard idx < currentMenu.items.count else { break }
                let iy = 54 + slot * 21
                if idx == currentMenu.selectedIndex {
                    g.setColor(0x6E4D1B)
                    g.fillRect(68, iy - 2, 376, 19)
                    g.setColor(0xFFD766)
                    g.drawRect(68, iy - 2, 376, 19)
                }
                g.drawString(fontId: 1, currentMenu.items[idx], x: cx, y: iy, anchor: Anchor.hcenter | Anchor.top)
            }
        }

        // Touch-friendly Bottom Buttons
        g.setColor(0x2A1E0F)
        g.fillRect(8, 224, 108, 22)
        g.setColor(0xB8914E)
        g.drawRect(8, 224, 108, 22)
        g.drawString(fontId: 1, currentMenu.isScrollText ? "Len" : "Chon", x: 62, y: 228, anchor: Anchor.hcenter | Anchor.top)

        g.setColor(0x2A1E0F)
        g.fillRect(396, 224, 108, 22)
        g.setColor(0xB8914E)
        g.drawRect(396, 224, 108, 22)
        let rLabel = (screenState == .paused && currentMenu.parent == nil) ? localization.text(11) : (currentMenu.parent != nil ? "Quay lai" : localization.text(331))
        g.drawString(fontId: 1, rLabel, x: 450, y: 228, anchor: Anchor.hcenter | Anchor.top)
    }
}
