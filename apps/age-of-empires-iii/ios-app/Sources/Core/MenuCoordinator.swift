// Port of f.java + g.java + c.java — Main Loop State Machine, Menus, Key Masks, Cheat Code, and Canvas Coordinator
import CoreGraphics
import Foundation

public struct KeyBits {
    public static let up     = 1 << 0   // 1
    public static let down   = 1 << 1   // 2
    public static let left   = 1 << 2   // 4
    public static let right  = 1 << 3   // 8
    public static let fire   = 1 << 4   // 16
    public static let num1   = 1 << 5   // 32
    public static let num2   = 1 << 6   // 64
    public static let num3   = 1 << 7   // 128
    public static let num4   = 1 << 8   // 256
    public static let num5   = 1 << 9   // 512
    public static let num6   = 1 << 10  // 1024
    public static let num7   = 1 << 11  // 2048
    public static let num8   = 1 << 12  // 4096
    public static let num9   = 1 << 13  // 8192
    public static let num0   = 1 << 14  // 16384
    public static let star   = 1 << 15  // 32768
    public static let pound  = 1 << 16  // 65536
    public static let lsk    = 1 << 17  // -6
    public static let rsk    = 1 << 18  // -7
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
    // Port of c.a[14][5] touch keypad hitboxes relative to y=400 (touch.png 360x241) + LSK/RSK
    public static let touchHitboxes: [(x0: Int, y0: Int, x1: Int, y1: Int, keyCode: Int)] = [
        (0, 3, 90, 82, 49),     // '1'
        (91, 3, 180, 82, 50),   // '2'
        (181, 3, 270, 82, 51),  // '3'
        (271, 3, 360, 82, 42),  // '*'
        (0, 83, 90, 161, 52),   // '4'
        (91, 83, 180, 161, 53), // '5'
        (181, 83, 270, 161, 54),// '6'
        (271, 83, 360, 161, 48),// '0'
        (0, 162, 90, 240, 55),  // '7'
        (91, 162, 180, 240, 56),// '8'
        (181, 162, 270, 240, 57),// '9'
        (271, 162, 360, 240, 35) // '#'
    ]

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

    // Skirmish setup fields
    public var skirmishMapIndex: Int = 0    // 0..3
    public var skirmishFaction: Int = 0     // 0..2
    public var skirmishDifficulty: Int = 1  // 0..2
    public var savedAudioSlot: Int = -1
    private var cheatProgress: Int = 0

    // Splash/UI images
    private var splashImage: GameSprite?
    private var brandImages: [GameSprite] = []
    private var menuHeaderBanner: GameSprite?
    private var menuArrows: [GameSprite] = []

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
        self.renderer = SoftwareRenderer(font: font)

        self.splashImage = GameSprite(filename: "splash.png", assets: assets)
        for i in 0..<3 {
            if let b = GameSprite(filename: "brand\(i).png", assets: assets) { brandImages.append(b) }
        }
        self.menuHeaderBanner = GameSprite(resId: 46, assets: assets)
        if let s44 = GameSprite(resId: 44, assets: assets) {
            self.menuArrows = s44.splitHorizontally(count: 2)
        }

        if skipSplash {
            transitionToMainMenu()
        } else {
            self.currentMenu = buildMainMenu()
        }
    }

    // Port of c.b(int keyCode):I — converts MIDP key code to directional/action bitmask
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
            if splashTick == 1 {
                // Preload sprite tables cleanly after first paint
            }
            if splashTick >= 40 {
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

    // Port of f keyPressed handling
    public func handleKeyCode(_ keyCode: Int) {
        let mask = Self.mapKeyToBitmask(keyCode)

        // Track Konami/cheat sequence during active play
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

    public func handleKeypadTouch(xInKeypadArea x: Int, yInKeypadArea y: Int) {
        for box in Self.touchHitboxes {
            if x >= box.x0 && x <= box.x1 && y >= box.y0 && y <= box.y1 {
                if settings.vibrationEnabled { onHapticPulse?() }
                handleKeyCode(box.keyCode)
                return
            }
        }
    }

    public func handleCanvasTap(x: Int, y: Int) {
        // Original c.a[12..13] bottom softkey corners inside 360x400 canvas
        if x <= 68 && y >= 360 {
            handleKeyCode(-6)
            return
        }
        if x >= 292 && y >= 360 {
            handleKeyCode(-7)
            return
        }
        switch screenState {
        case .splash:
            transitionToMainMenu()
        case .playing:
            engine.handleCanvasTap(screenX: x, screenY: y)
        case .menu, .paused:
            if y >= 130 && y <= 345 && !currentMenu.isScrollText {
                let rowIdx = (y - 135) / 22
                if rowIdx >= 0 && rowIdx < currentMenu.items.count {
                    currentMenu.selectedIndex = rowIdx
                    activateCurrentMenuItem()
                }
            } else if currentMenu.isScrollText {
                currentMenu = currentMenu.parent ?? buildMainMenu()
            }
        case .outcome:
            transitionToMainMenu()
        case .loading:
            break
        }
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
                currentMenu.scrollOffset = min(max(0, currentMenu.items.count - 8), currentMenu.scrollOffset + 1)
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
                screenState = .playing
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
            case 6: transitionToMainMenu() // Safe UI reset
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
            let label = engine.isCampaign ? "\(localization.text(19).replacingOccurrences(of: "%U", with: "\(engine.campaignMission + 1)"))" : localization.text(4)
            saveStore.saveSlotData(slot, data: engine.serializeState(title: label))
            screenState = .playing
            engine.showPopup("Da luu o \(slot + 1)!")
        case .instructions, .about:
            currentMenu = currentMenu.parent ?? buildMainMenu()
        }
    }

    // MARK: - Menu Builders

    private func buildMainMenu() -> GameMenuNode {
        GameMenuNode(
            id: .main,
            title: localization.text(2),
            items: [
                localization.text(3),
                localization.text(4),
                localization.text(5),
                localization.text(6),
                localization.text(7),
                localization.text(8),
                localization.text(9)
            ]
        )
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
        return GameMenuNode(id: .skirmish, parent: parent, title: localization.text(4), items: buildSkirmishItems())
    }

    private func buildSkirmishItems() -> [String] {
        let mapName = localization.text(219 + skirmishMapIndex)
        let diffLabel = [localization.text(205), localization.text(206), localization.text(207)][skirmishDifficulty % 3]
        let facLabel = localization.text(224 + skirmishFaction % 3)
        return [
            "\(localization.text(20)): \(mapName)",
            "\(localization.text(21)): \(facLabel)",
            "\(localization.text(22)): \(diffLabel)",
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
        return GameMenuNode(id: .settings, parent: parent, title: localization.text(6), items: buildSettingsItems())
    }

    private func buildSettingsItems() -> [String] {
        return [
            localization.text(settings.soundEnabled ? 31 : 32),
            localization.text(settings.vibrationEnabled ? 33 : 34),
            localization.text(settings.hintsEnabled ? 37 : 38)
        ]
    }

    private func buildInstructionsMenu(parent: GameMenuNode) -> GameMenuNode {
        let raw = [41, 42, 43, 44, 45, 46, 47, 48].map { localization.text($0) }.filter { !$0.isEmpty }.joined(separator: "\n")
        let wrapped = localization.wrapText(raw, maxWidth: 320, fontId: 1, font: font)
        return GameMenuNode(id: .instructions, parent: parent, title: localization.text(7), items: wrapped, isScrollText: true)
    }

    private func buildAboutMenu(parent: GameMenuNode) -> GameMenuNode {
        let raw = localization.format(39, [localization.text(1), "1.0.0"])
        let wrapped = localization.wrapText(raw, maxWidth: 320, fontId: 1, font: font)
        return GameMenuNode(id: .about, parent: parent, title: localization.text(8), items: wrapped, isScrollText: true)
    }

    private func buildPauseMenu() -> GameMenuNode {
        return GameMenuNode(id: .pauseMenu, parent: nil, title: localization.text(10), items: [
            localization.text(11),
            localization.text(5),
            localization.text(6),
            localization.text(16)
        ])
    }

    // MARK: - Master Frame Render (360 x 400)

    public func renderFrame() -> PixelSurface {
        switch screenState {
        case .splash:
            renderer.setColor(0x000000)
            renderer.fillRect(0, 0, XSMaxLayout.gameLogicalWidth, XSMaxLayout.gameLogicalHeight)
            if splashTick < 20, let b = brandImages.first {
                renderer.drawSprite(b, x: 180, y: 200, anchor: Anchor.hcenter | Anchor.vcenter)
            } else if let s = splashImage {
                renderer.drawSprite(s, x: 0, y: 0)
            }
        case .menu, .loading:
            renderer.setColor(0x140E08)
            renderer.fillRect(0, 0, XSMaxLayout.gameLogicalWidth, XSMaxLayout.gameLogicalHeight)
            if let s = splashImage {
                renderer.drawSprite(s, x: 0, y: 0)
            }
            if let hdr = menuHeaderBanner {
                renderer.drawSprite(hdr, x: 0, y: 0)
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
            renderer.fillRect(40, 140, 280, 110)
            renderer.setColor(0xD4AF37)
            renderer.drawRect(40, 140, 280, 110)
            let msg = localization.text(engine.outcome == .victory ? 118 : 119)
            renderer.drawString(fontId: 0, msg, x: 180, y: 170, anchor: Anchor.hcenter | Anchor.top)
            renderer.drawString(fontId: 1, localization.text(113), x: 180, y: 215, anchor: Anchor.hcenter | Anchor.top)
        }
        return renderer.surface
    }

    private func renderMenuOverlay(g: SoftwareRenderer) {
        g.setColor(0x1E150B)
        g.fillRect(24, 112, 312, 246)
        g.setColor(0xB8914E)
        g.drawRect(24, 112, 312, 246)

        g.drawString(fontId: 0, currentMenu.title, x: 180, y: 118, anchor: Anchor.hcenter | Anchor.top)

        if currentMenu.isScrollText {
            let maxLines = 11
            for row in 0..<maxLines {
                let idx = currentMenu.scrollOffset + row
                guard idx < currentMenu.items.count else { break }
                g.drawString(fontId: 1, currentMenu.items[idx], x: 36, y: 146 + row * 17, anchor: Anchor.left | Anchor.top)
            }
        } else {
            for (idx, item) in currentMenu.items.enumerated() where idx < 9 {
                let iy = 148 + idx * 22
                if idx == currentMenu.selectedIndex {
                    g.setColor(0x6E4D1B)
                    g.fillRect(34, iy - 2, 292, 20)
                    g.setColor(0xFFD766)
                    g.drawRect(34, iy - 2, 292, 20)
                }
                g.drawString(fontId: 1, item, x: 180, y: iy, anchor: Anchor.hcenter | Anchor.top)
            }
        }

        // Bottom LSK / RSK
        g.drawString(fontId: 1, localization.text(333), x: 8, y: 396, anchor: Anchor.bottom | Anchor.left)
        g.drawString(fontId: 1, localization.text(331), x: 352, y: 396, anchor: Anchor.bottom | Anchor.right)
    }
}
