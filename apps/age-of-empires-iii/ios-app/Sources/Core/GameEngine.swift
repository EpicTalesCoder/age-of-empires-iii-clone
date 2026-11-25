// Port of e.java — Core RTS Game Engine (Landscape Widescreen 512x250, Direct Touch Selection/Commands, J2ME Isometric Rendering)
import Foundation

public enum GameOutcome: Int {
    case playing = 0
    case victory = 1
    case defeat = 2
}

public final class GameEngine {
    public let assets: GameAssets
    public let tables: GameTables
    public let map: GameMap
    public let localization: Localization

    // Graphics resources loaded in e.o() and e.p()
    public var terrainTiles: [GameSprite] = []      // 54.res (30 x 32x15)
    public var propTiles: [GameSprite] = []         // 55.res (15 x 32x52)
    public var fogTiles: [GameSprite] = []          // 40.res (16 x 19x9)
    public var commandIcons: [GameSprite] = []      // 39.res (29 x 18x18)
    public var resourcePips: [GameSprite?] = []     // 53.res (5 x 6x6)
    public var hpBarPieces: [GameSprite] = []       // black, red, yellow (12x2)
    public var homeCityBanner: GameSprite?          // 49.res
    public var cursorBracketLeft: GameSprite?       // 47.res
    public var cursorArrows: [GameSprite] = []      // 48.res (2)
    public var hudTopCorner: GameSprite?            // 50.res
    public var hudEdgeLine: [GameSprite] = []       // 51.res
    public var spritePacks: [SpritePackData?] = Array(repeating: nil, count: 24)
    private var graphicsLoaded = false

    // Match state
    public var isCampaign: Bool = false
    public var campaignMission: Int = 0
    public var difficulty: Int = 1
    public var faction: Int = 0
    public var commandUnlockMask: Int = 0x7FFF_FFFF
    public var outcome: GameOutcome = .playing

    public var entities: [Entity] = []
    public var nextEntityId: Int = 1
    public var cursorEntity: Entity = Entity(kind: .cursor, id: 0)
    public var selectedEntity: Entity?
    public var selectedUnits: [Entity] = []         // Supports direct tap / multi-unit selection
    public var rallyFlag: Entity?

    // Map resource remaining amounts per tile (r * cols + c -> remaining)
    public var resourceAmounts: [Int: Int] = [:]

    // Player stats (0=Player, 1=AI1, 2=AI2)
    public var playerResources: [[Int]] = Array(repeating: [400, 400, 200], count: 4)
    public var playerPopUsed: [Int] = [0, 0, 0, 0]
    public var playerPopCap: [Int] = [10, 10, 10, 10]
    public var playerAges: [Int] = [0, 0, 0, 0]
    public var playerTechTiers: [[Int]] = Array(repeating: [0, 0, 0], count: 4)
    public var playerSlotsMap: [Int]? = nil
    public var aiControllers: [AIController] = []

    // HUD, Camera & Touch UX (512 x 250 Landscape viewport)
    public var cameraIsoX: Int = 0
    public var cameraIsoY: Int = 0
    public var selectedCmdIndex: Int = 0
    public var activeCommandList: [Int] = []
    public var buildPlacementCmd: Int? = nil
    public var rallyModeActive: Bool = false
    public var demolishArmedBuildingId: Int? = nil
    public var homeCityXP: Int = 0
    public var homeCityShipmentReady: Bool = true
    public var minimapVisible: Bool = true
    public var onPauseRequested: (() -> Void)?

    // Visual tap ripple marker (screen feedback when tapping map)
    private var tapMarker: (row: Int, col: Int, color: Int, ticks: Int)? = nil
    private var inspectedResource: (row: Int, col: Int)? = nil
    private var idleCycleIdx: Int = 0

    // Scripted campaign & in-game dialog popup
    public var tickCount: Int = 0
    public var firedTriggers: Set<Int> = []
    public var activeMessage: String? = nil
    public var activeMessageTimer: Int = 0
    public var objectiveText: String = ""
    public var killsCount: Int = 0
    public var rngState: UInt32 = 0x4A2E_91B7

    public init(assets: GameAssets = .shared, tables: GameTables, localization: Localization) {
        self.assets = assets
        self.tables = tables
        self.map = GameMap()
        self.localization = localization
    }

    // Port of e.o() & e.p()
    public func ensureGraphicsLoaded() {
        guard !graphicsLoaded else { return }
        graphicsLoaded = true

        var terrCount = 1
        var propCount = 1
        var idx = 0
        while idx < tables.PB.count {
            let v = tables.PB[idx]
            if v < 100 { terrCount = max(terrCount, v + 1) }
            else { propCount = max(propCount, v - 100 + 1) }
            idx += 2
        }

        if let s54 = GameSprite(resId: 54, assets: assets) { terrainTiles = s54.splitHorizontally(count: terrCount) }
        if let s55 = GameSprite(resId: 55, assets: assets) { propTiles = s55.splitHorizontally(count: propCount) }
        if let s40 = GameSprite(resId: 40, assets: assets) { fogTiles = s40.splitHorizontally(count: 16) }
        let maxIcon = (tables.FB.max() ?? 28) + 1
        if let s39 = GameSprite(resId: 39, assets: assets) { commandIcons = s39.splitHorizontally(count: maxIcon) }
        if let s53 = GameSprite(resId: 53, assets: assets) {
            let sliced = s53.splitHorizontally(count: 5)
            resourcePips = [nil] + sliced.dropFirst().map { Optional($0) }
        }
        homeCityBanner = GameSprite(resId: 49, assets: assets)
        cursorBracketLeft = GameSprite(resId: 47, assets: assets)
        if let s48 = GameSprite(resId: 48, assets: assets) { cursorArrows = s48.splitHorizontally(count: 2) }
        hudTopCorner = GameSprite(resId: 50, assets: assets)
        if let s51 = GameSprite(resId: 51, assets: assets) { hudEdgeLine = s51.splitHorizontally(count: 1) }
        hpBarPieces = [
            GameSprite.solidColor(width: 12, height: 2, rgb: 0x000000),
            GameSprite.solidColor(width: 12, height: 2, rgb: 0xFF0000),
            GameSprite.solidColor(width: 12, height: 2, rgb: 0xFFFF00)
        ]

        let pal2: [Int] = [36, -1]
        let pal5: [Int] = [36, -1, 34, 35, -1]
        for slot in 0..<min(24, tables.bII.count) {
            let resId = tables.bII[slot].first(where: { $0 != -1 }) ?? -1
            let pals: [Int]?
            if slot == 4 || slot == 5 { pals = pal2 }
            else if slot == 12 { pals = pal5 }
            else if slot < 14 { pals = pal2 }
            else { pals = nil }
            spritePacks[slot] = SpritePackLoader.load(resId: resId, paletteResIds: pals, durationLookup: tables.lS, assets: assets)
        }
    }

    // MARK: - Match Initialization

    public func startCampaign(mission: Int, difficulty: Int = 1) {
        ensureGraphicsLoaded()
        self.isCampaign = true
        self.campaignMission = max(0, min(mission, tables.NB.count - 1))
        self.difficulty = difficulty
        self.commandUnlockMask = campaignMission < tables.hI.count ? tables.hI[campaignMission] : 0x7FFF_FFFF
        self.playerSlotsMap = nil
        let mapIndex = tables.NB[self.campaignMission]
        setupMatchCommon(mapIndex: mapIndex)

        if !tables.cSS.isEmpty {
            let header = localization.format(19, ["\(campaignMission + 1)"])
            showPopup(header)
            objectiveText = header
        }
    }

    public func startSkirmish(mapChoice: Int, faction: Int, difficulty: Int) {
        ensureGraphicsLoaded()
        self.isCampaign = false
        self.campaignMission = 0
        self.faction = faction
        self.difficulty = difficulty
        self.commandUnlockMask = 0x7FFF_FFFF
        let clampedChoice = max(0, min(3, mapChoice))
        let mapIndex = min(tables.iI.count - 1, 10 + clampedChoice)
        self.playerSlotsMap = [0, 1]
        setupMatchCommon(mapIndex: mapIndex)
        objectiveText = localization.text(4)
    }

    private func setupMatchCommon(mapIndex: Int) {
        entities.removeAll()
        resourceAmounts.removeAll()
        nextEntityId = 1
        outcome = .playing
        tickCount = 0
        killsCount = 0
        firedTriggers.removeAll()
        selectedEntity = nil
        selectedUnits.removeAll()
        buildPlacementCmd = nil
        rallyModeActive = false
        tapMarker = nil
        inspectedResource = nil
        homeCityXP = 0
        homeCityShipmentReady = true

        playerResources = [
            [400, 400, 200],
            difficulty == 2 ? [600, 600, 350] : [350, 350, 150],
            [350, 350, 150],
            [350, 350, 150]
        ]
        playerAges = [0, 0, 0, 0]
        playerTechTiers = Array(repeating: [0, 0, 0], count: 4)

        _ = map.load(mapIndex: mapIndex, tables: tables, assets: assets, rng: &rngState)

        for r in 0..<map.rows {
            for c in 0..<map.cols {
                let idx = r * map.cols + c
                let code = map.terrain[idx]
                if GameMap.isResourceTerrain(code, tables: tables) {
                    map.fogGrid[idx] |= 8
                    let rType = GameTables.pairLookup(tables.vB, key: code)
                    if rType >= 0 {
                        resourceAmounts[idx] = Self.resourceNodeCapacity(forType: rType, tables: tables)
                    }
                }
            }
        }

        spawnGroup(0)
        if isCampaign && map.spawnGroups.count > 1 && campaignMission == 0 {
            spawnGroup(1)
        }

        let playerTC = entities.first(where: { $0.owner == 0 && $0.kind == .building })
            ?? entities.first(where: { $0.owner == 0 })
        if let anchor = playerTC {
            cursorEntity = Entity(kind: .cursor, id: 0)
            setCursor(row: anchor.tileRow, col: anchor.tileCol)
            selectSingleEntity(anchor)
            centerCamera(onWorldRow: anchor.xFixed >> 8, worldCol: anchor.yFixed >> 8)
            revealFog(centerRow: anchor.tileRow, centerCol: anchor.tileCol, radius: 9)
        } else {
            centerCamera(onWorldRow: (map.rows / 2) * GameMap.tileLogicSize, worldCol: (map.cols / 2) * GameMap.tileLogicSize)
        }

        let aiOwners = Set(entities.filter { $0.owner > 0 }.map { $0.owner })
        aiControllers = (aiOwners.isEmpty ? [1] : Array(aiOwners).sorted()).map { AIController(ownerId: $0) }

        recomputePopulations()
        rebuildCommandList()
    }

    public func spawnGroup(_ groupIndex: Int) {
        guard groupIndex >= 0, groupIndex < map.spawnGroups.count else { return }
        for (rawCode, row, col) in map.spawnGroups[groupIndex] {
            var ownerRaw = rawCode / 16
            if let vMap = playerSlotsMap {
                if let mapped = vMap.firstIndex(of: ownerRaw) { ownerRaw = mapped }
                else { continue }
            }
            if ownerRaw == 2 { ownerRaw = 0 }
            let cmd = rawCode % 16
            guard cmd >= 0, cmd < tables.rB.count else { continue }
            if tables.rB[cmd] == 1 {
                let bld = Entity.makeBuilding(id: nextEntityId, owner: ownerRaw, buildingType: cmd + 1, row: row, col: col, constructed: true, engine: self)
                nextEntityId += 1
                stampBuildingFootprint(bld, occupy: true)
                entities.append(bld)
                if ownerRaw == 0 { revealFog(centerRow: row, centerCol: col, radius: bld.sightRangeTiles(tables: tables)) }
            } else if cmd >= 8 && cmd <= 15 {
                let unit = Entity.makeUnit(id: nextEntityId, owner: ownerRaw, unitType: cmd - 8, row: row, col: col, engine: self)
                nextEntityId += 1
                entities.append(unit)
                if ownerRaw == 0 { revealFog(centerRow: row, centerCol: col, radius: unit.sightRangeTiles(tables: tables)) }
            }
        }
    }

    public func stampBuildingFootprint(_ bld: Entity, occupy: Bool) {
        let bt = bld.buildingType
        guard bt >= 0, bt < tables.hBB.count, let footprint = tables.hBB[bt] else { return }
        var idx = 0
        while idx + 2 < footprint.count {
            let rr = bld.tileRow + footprint[idx]
            let cc = bld.tileCol + footprint[idx + 1]
            let tileVal = footprint[idx + 2]
            if map.isInBounds(row: rr, col: cc) {
                let cell = rr * map.cols + cc
                if occupy {
                    map.fogGrid[cell] |= 4
                    if tileVal >= 0 { map.terrain[cell] = tileVal }
                } else {
                    map.fogGrid[cell] &= ~4
                }
            }
            idx += 3
        }
    }

    // MARK: - Building Footprint Queries

    public func buildingFootprintTiles(_ bld: Entity) -> [(Int, Int)] {
        let bt = bld.buildingType
        guard bt >= 0, bt < tables.hBB.count, let footprint = tables.hBB[bt] else {
            return [(bld.tileRow, bld.tileCol)]
        }
        var res = [(Int, Int)]()
        var i = 0
        while i + 2 < footprint.count {
            res.append((bld.tileRow + footprint[i], bld.tileCol + footprint[i + 1]))
            i += 3
        }
        return res.isEmpty ? [(bld.tileRow, bld.tileCol)] : res
    }

    public func distanceToBuildingFootprint(fromRow r: Int, col c: Int, building: Entity) -> Int {
        var best = Int.max
        for (br, bc) in buildingFootprintTiles(building) {
            best = min(best, GameMap.tileDistance(r0: r, c0: c, r1: br, c1: bc))
        }
        return best
    }

    public func nearestWalkableAdjacentToBuilding(_ building: Entity, fromRow r: Int, fromCol c: Int) -> (Int, Int)? {
        var best: (Int, Int)?
        var bestDist = Int.max
        for (br, bc) in buildingFootprintTiles(building) {
            for dr in -1...1 {
                for dc in -1...1 {
                    let tr = br + dr
                    let tc = bc + dc
                    if map.isTileWalkable(row: tr, col: tc, tables: tables) {
                        let d = abs(tr - r) + abs(tc - c)
                        if d < bestDist {
                            bestDist = d
                            best = (tr, tc)
                        }
                    }
                }
            }
        }
        return best
    }

    // MARK: - Per-Tick Simulation

    public func updateTick() {
        guard outcome == .playing else { return }
        tickCount += 1

        if activeMessageTimer > 0 {
            activeMessageTimer -= 1
            if activeMessageTimer == 0 { activeMessage = nil }
        }
        if var tm = tapMarker {
            tm.ticks -= 1
            tapMarker = tm.ticks > 0 ? tm : nil
        }

        if !homeCityShipmentReady {
            homeCityXP += 1
            if homeCityXP >= 240 {
                homeCityShipmentReady = true
                homeCityXP = 240
            }
        }

        for ai in aiControllers { ai.updateTick(engine: self) }
        for ent in entities where ent.active { ent.updateTick(engine: self) }
        entities.removeAll { !$0.active }
        selectedUnits.removeAll { !$0.active }
        if let sel = selectedEntity, !sel.active {
            selectedEntity = selectedUnits.first
            rebuildCommandList()
        }

        if isCampaign { evaluateCampaignTriggers() }
        else { evaluateSkirmishVictory() }

        recomputePopulations()
    }

    private func evaluateSkirmishVictory() {
        let playerAlive = entities.contains { $0.active && $0.owner == 0 && ($0.kind == .building || $0.kind == .unit) }
        let aiAlive = entities.contains { $0.active && $0.owner > 0 && ($0.kind == .building || $0.kind == .unit) }
        if !playerAlive { outcome = .defeat }
        else if !aiAlive { outcome = .victory }
    }

    private func evaluateCampaignTriggers() {
        let playerAlive = entities.contains { $0.active && $0.owner == 0 && ($0.kind == .building || $0.kind == .unit) }
        if !playerAlive { outcome = .defeat; return }
        guard campaignMission >= 0, campaignMission < tables.aSSS.count else { return }
        let trigs = tables.aSSS[campaignMission]
        for (idx, trig) in trigs.enumerated() where !firedTriggers.contains(idx) && !trig.isEmpty {
            let op = trig[0]
            switch op {
            case 1:
                if tickCount >= 60 + idx * 45 {
                    firedTriggers.insert(idx)
                    if trig.count > 1 && trig[1] >= 0 && trig[1] < map.spawnGroups.count { spawnGroup(trig[1]) }
                }
            case 2:
                if tickCount >= 10 + idx * 20 {
                    firedTriggers.insert(idx)
                    if trig.count >= 3 && trig[2] > 0 {
                        let strId = trig[2]
                        var msg = localization.text(strId)
                        if msg.contains("%U") {
                            if strId == 232 && trig.count >= 5 {
                                let resName = localization.text(196 + max(0, min(2, trig[3])))
                                msg = localization.format(strId, ["\(trig[4])", resName])
                            } else if strId == 230 && trig.count >= 5 {
                                let bldName = localization.text(174 + max(0, min(8, trig[3])))
                                msg = localization.format(strId, ["\(trig[4])", bldName])
                            } else if strId == 231 && trig.count >= 5 {
                                msg = localization.format(strId, ["\(trig[4])"])
                            } else if trig.count >= 4 {
                                msg = localization.format(strId, ["\(trig[3])"])
                            }
                            msg = msg.replacingOccurrences(of: "%U", with: "").trimmingCharacters(in: .whitespaces)
                        }
                        if !msg.isEmpty { showPopup(msg) }
                    }
                }
            case 3, 4:
                if trig.count > 1 && tickCount >= 140 + idx * 90 {
                    firedTriggers.insert(idx)
                    if trig[1] >= 0 && trig[1] < map.spawnGroups.count { spawnGroup(trig[1]) }
                }
            default: break
            }
        }
        let enemyAlive = entities.contains { $0.active && $0.owner > 0 && ($0.kind == .building || $0.kind == .unit) }
        if !enemyAlive { outcome = .victory }
    }

    // MARK: - Commands & Harvesting

    public static func resourceNodeCapacity(forType rType: Int, tables: GameTables) -> Int {
        // Playable node capacities matching e.k:[S ratios (Food < Gold, Wood finite per tree) so every tree, bush & rock visibly depletes
        switch rType {
        case 0: return 250  // Food (Berry bush): 12.5s single settler
        case 1: return 180  // Wood (Tree): 9s single settler
        case 2: return 400  // Gold (Stone/Gold mine): 20s single settler
        default:
            if rType >= 0 && rType < tables.kS.count { return min(400, tables.kS[rType]) }
            return 200
        }
    }

    public func resourceTypeName(_ resourceType: Int) -> String {
        return localization.text(196 + max(0, min(2, resourceType)))
    }

    public func remainingResource(atRow row: Int, col: Int) -> (type: Int, remaining: Int, capacity: Int)? {
        guard map.isInBounds(row: row, col: col) else { return nil }
        let idx = row * map.cols + col
        let code = map.terrain[idx]
        let rt = GameTables.pairLookup(tables.vB, key: code)
        guard rt >= 0 else { return nil }
        let cap = Self.resourceNodeCapacity(forType: rt, tables: tables)
        let rem = resourceAmounts[idx] ?? cap
        guard rem > 0 else { return nil }
        return (rt, rem, cap)
    }

    public func harvestTile(row: Int, col: Int, maxYield: Int) -> Int {
        guard map.isInBounds(row: row, col: col) else { return 0 }
        let idx = row * map.cols + col
        let code = map.terrain[idx]
        let rt = GameTables.pairLookup(tables.vB, key: code)
        guard rt >= 0 else { return 0 }
        let cap = Self.resourceNodeCapacity(forType: rt, tables: tables)
        let rem = resourceAmounts[idx] ?? cap
        guard rem > 0 else { return 0 }
        let take = min(rem, maxYield)
        let left = rem - take
        if left <= 0 {
            resourceAmounts.removeValue(forKey: idx)
            let depletedCode = GameTables.pairLookup(tables.wB, key: code)
            map.terrain[idx] = depletedCode >= 0 ? depletedCode : 2 // grass (2) or mined crater (4) per e.w:[B
            map.fogGrid[idx] &= ~8
            if inspectedResource?.row == row && inspectedResource?.col == col {
                inspectedResource = nil
            }
        } else {
            resourceAmounts[idx] = left
        }
        return take
    }

    public func showInsufficientCostPopup(for commandId: Int) {
        guard commandId >= 0, commandId < tables.aSS.count, tables.aSS[commandId].count >= 3 else {
            showPopup(localization.text(133))
            return
        }
        let c = tables.aSS[commandId]
        var parts = [String]()
        for r in 0..<3 where c[r] > 0 && playerResources[0][r] < c[r] {
            parts.append("\(c[r]) \(resourceTypeName(r))")
        }
        if parts.isEmpty {
            showPopup(localization.text(133))
        } else {
            showPopup("\(localization.text(133)) (can \(parts.joined(separator: ", ")))")
        }
    }

    public func isCommandUnlocked(_ cmd: Int) -> Bool {
        if cmd < 0 || cmd >= 31 { return true }
        return (commandUnlockMask & (1 << cmd)) != 0
    }

    public func canAfford(owner: Int, commandId: Int) -> Bool {
        guard commandId >= 0, commandId < tables.aSS.count, tables.aSS[commandId].count >= 3 else { return true }
        let c = tables.aSS[commandId]
        return playerResources[owner][0] >= c[0] && playerResources[owner][1] >= c[1] && playerResources[owner][2] >= c[2]
    }

    public func spendCost(owner: Int, commandId: Int) -> Bool {
        guard canAfford(owner: owner, commandId: commandId),
              commandId >= 0, commandId < tables.aSS.count, tables.aSS[commandId].count >= 3 else { return false }
        let c = tables.aSS[commandId]
        playerResources[owner][0] -= c[0]
        playerResources[owner][1] -= c[1]
        playerResources[owner][2] -= c[2]
        return true
    }

    public func addResource(owner: Int, resourceType: Int, amount: Int, atRow: Int, atCol: Int) {
        guard owner >= 0, owner < playerResources.count, resourceType >= 0, resourceType < 3 else { return }
        playerResources[owner][resourceType] += amount
        if owner == 0 {
            homeCityXP = min(240, homeCityXP + max(1, amount / 5))
            let pop = Entity.makeFloatingText(id: nextEntityId, row: atRow, col: atCol, amount: amount, resourceType: resourceType)
            nextEntityId += 1
            entities.append(pop)
        }
    }

    @discardableResult
    public func issueBuildingCommand(_ bld: Entity, commandId: Int) -> Bool {
        guard bld.kind == .building, bld.state == 1 else { return false }
        let owner = bld.owner

        if commandId == 22 {
            if owner == 0 && demolishArmedBuildingId != bld.id {
                demolishArmedBuildingId = bld.id
                showPopup(localization.text(193))
                return true
            }
            demolishArmedBuildingId = nil
            bld.active = false
            stampBuildingFootprint(bld, occupy: false)
            if selectedEntity === bld { selectedEntity = nil }
            rebuildCommandList()
            return true
        }

        if commandId == 23 {
            if owner == 0 {
                if bld.buildingType == 1 && homeCityShipmentReady {
                    sendHomeCityShipment(to: bld)
                } else {
                    rallyModeActive = true
                    showPopup(localization.text(194))
                }
            }
            return true
        }

        if commandId >= 18 && commandId <= 21 {
            guard spendCost(owner: owner, commandId: commandId) else {
                if owner == 0 { showInsufficientCostPopup(for: commandId) }
                return false
            }
            switch commandId {
            case 18: playerResources[owner][2] += 75
            case 19: playerResources[owner][2] += 75
            case 20: playerResources[owner][0] += 100
            case 21: playerResources[owner][1] += 100
            default: break
            }
            return true
        }

        if commandId >= 8 && commandId <= 15 && playerPopUsed[owner] >= playerPopCap[owner] {
            if owner == 0 { showPopup(localization.text(135)) }
            return false
        }
        if commandId == 16 && playerAges[owner] >= 1 { return false }
        if commandId == 17 && playerAges[owner] >= 2 { return false }

        guard spendCost(owner: owner, commandId: commandId) else {
            if owner == 0 { showInsufficientCostPopup(for: commandId) }
            return false
        }

        let trainTicks: Int
        if commandId >= 8 && commandId <= 15 {
            let ut = commandId - 8
            trainTicks = (ut < tables.eS.count) ? max(15, tables.eS[ut] * 3) : 45
        } else {
            trainTicks = 60
        }
        var queue = bld.intArrays[0] ?? []
        queue.append(commandId)
        queue.append(trainTicks)
        bld.intArrays[0] = queue
        return true
    }

    public func completeBuildingOrder(building: Entity, commandId: Int) {
        let owner = building.owner
        if commandId >= 8 && commandId <= 15 {
            let uType = commandId - 8
            let spawnPos = nearestWalkableAdjacentToBuilding(building, fromRow: building.tileRow, fromCol: building.tileCol)
                ?? (building.tileRow, building.tileCol)
            let unit = Entity.makeUnit(id: nextEntityId, owner: owner, unitType: uType, row: spawnPos.0, col: spawnPos.1, engine: self)
            nextEntityId += 1
            entities.append(unit)
            if owner == 0 {
                revealFog(centerRow: unit.tileRow, centerCol: unit.tileCol, radius: unit.sightRangeTiles(tables: self.tables))
            }
        } else if commandId == 16 {
            playerAges[owner] = max(playerAges[owner], 1)
            if owner == 0 { showPopup(localization.text(185)) }
        } else if commandId == 17 {
            playerAges[owner] = max(playerAges[owner], 2)
            if owner == 0 { showPopup(localization.text(186)) }
        } else if commandId >= 24 && commandId <= 26 {
            let targetTier = commandId - 23
            for cat in 0..<playerTechTiers[owner].count {
                playerTechTiers[owner][cat] = max(playerTechTiers[owner][cat], targetTier)
            }
            if owner == 0 { showPopup(localization.format(146, [localization.text(177)])) }
        }
        recomputePopulations()
    }

    public func sendHomeCityShipment(to tc: Entity) {
        guard homeCityShipmentReady else { return }
        homeCityShipmentReady = false
        homeCityXP = 0
        playerResources[0][0] += 150
        playerResources[0][1] += 150
        playerResources[0][2] += 100
        if let spot = nearestWalkableAdjacentToBuilding(tc, fromRow: tc.tileRow, fromCol: tc.tileCol) {
            let u = Entity.makeUnit(id: nextEntityId, owner: 0, unitType: 2, row: spot.0, col: spot.1, engine: self)
            nextEntityId += 1
            entities.append(u)
        }
        showPopup(localization.text(134))
    }

    public func canPlaceBuilding(buildingType: Int, row: Int, col: Int) -> Bool {
        let bt = buildingType
        guard bt >= 0, bt < tables.hBB.count, let footprint = tables.hBB[bt] else {
            return map.isTileWalkable(row: row, col: col, tables: tables)
        }
        var i = 0
        while i + 2 < footprint.count {
            let rr = row + footprint[i]
            let cc = col + footprint[i + 1]
            if !map.isTileWalkable(row: rr, col: cc, tables: tables) {
                return false
            }
            i += 3
        }
        return true
    }

    @discardableResult
    public func placeBuildingForOwner(owner: Int, buildingType: Int, row: Int, col: Int, constructedImmediately: Bool) -> Bool {
        let buildCmd = buildingType - 1
        guard canPlaceBuilding(buildingType: buildingType, row: row, col: col) else {
            if owner == 0 { showPopup(localization.text(140)) }
            return false
        }
        guard spendCost(owner: owner, commandId: buildCmd) else {
            if owner == 0 { showInsufficientCostPopup(for: buildCmd) }
            return false
        }
        let bld = Entity.makeBuilding(id: nextEntityId, owner: owner, buildingType: buildingType, row: row, col: col, constructed: constructedImmediately, engine: self)
        nextEntityId += 1
        stampBuildingFootprint(bld, occupy: true)
        entities.append(bld)
        if owner == 0 {
            revealFog(centerRow: row, centerCol: col, radius: bld.sightRangeTiles(tables: tables))
        }
        if !constructedImmediately {
            let workers = (owner == 0 ? selectedUnits.filter { $0.kind == .unit && $0.unitType == 0 } : [])
            if let builder = workers.first ?? entities.first(where: { $0.owner == owner && $0.kind == .unit && $0.unitType == 0 && !$0.flags[4] }) {
                builder.flags[4] = true
                builder.flags[2] = false
                builder.flags[1] = false
                builder.intArrays[1] = nil
                builder.bytes[25] = 0
                builder.refs[0] = nil
                builder.refs[1] = bld
            }
        }
        recomputePopulations()
        return true
    }

    public func onBuildingCompleted(_ bld: Entity) {
        if bld.owner == 0 {
            revealFog(centerRow: bld.tileRow, centerCol: bld.tileCol, radius: bld.sightRangeTiles(tables: tables))
        }
        recomputePopulations()
    }

    public func handleEntityKilled(_ victim: Entity, killerOwner: Int) {
        victim.active = false
        if victim.kind == .building { stampBuildingFootprint(victim, occupy: false) }
        if killerOwner == 0 {
            killsCount += 1
            homeCityXP = min(240, homeCityXP + 20)
        }
        let fx = Entity.makeFX(id: nextEntityId, fxType: 20, worldXFixed: victim.xFixed, worldYFixed: victim.yFixed, engine: self)
        nextEntityId += 1
        entities.append(fx)
        if selectedEntity === victim {
            selectedUnits.removeAll { $0 === victim }
            selectedEntity = selectedUnits.first
            rebuildCommandList()
        }
    }

    public func recomputePopulations() {
        playerPopUsed = [0, 0, 0, 0]
        playerPopCap = [5, 5, 5, 5]
        for ent in entities where ent.active {
            let o = max(0, min(3, ent.owner))
            if ent.kind == .unit {
                playerPopUsed[o] += 1
            } else if ent.kind == .building && ent.state == 1 {
                if ent.buildingType == 1 { playerPopCap[o] += 10 }
                else if ent.buildingType == 2 { playerPopCap[o] += 5 }
                else if ent.buildingType == 8 { playerPopCap[o] += 10 }
            }
        }
    }

    // MARK: - Search & Fog

    public func revealFog(centerRow: Int, centerCol: Int, radius: Int) {
        for dr in -radius...radius {
            for dc in -radius...radius where (dr * dr + dc * dc) <= (radius * radius + 1) {
                let rr = centerRow + dr
                let cc = centerCol + dc
                if map.isInBounds(row: rr, col: cc) { map.fogGrid[rr * map.cols + cc] |= 3 }
            }
        }
    }

    public func findNearestHostile(fromRow: Int, col: Int, myOwner: Int, maxTileDist: Int) -> Entity? {
        var best: Entity?
        var bestDist = Int.max
        for ent in entities where ent.active && ent.hp > 0 && ent.owner != myOwner && (ent.kind == .unit || ent.kind == .building) {
            let d = GameMap.tileDistance(r0: fromRow, c0: col, r1: ent.tileRow, c1: ent.tileCol)
            if d <= maxTileDist && d < bestDist { bestDist = d; best = ent }
        }
        return best
    }

    public func findNearestResourceTile(fromRow: Int, fromCol: Int, resourceType: Int?, maxRadius: Int) -> (Int, Int, Int)? {
        var best: (Int, Int, Int)?
        var bestDist = Int.max
        for dr in -maxRadius...maxRadius {
            for dc in -maxRadius...maxRadius {
                let rr = fromRow + dr
                let cc = fromCol + dc
                guard let info = remainingResource(atRow: rr, col: cc) else { continue }
                if let targetRT = resourceType, targetRT != info.type { continue }
                guard map.hasWalkableAdjacentTile(row: rr, col: cc, tables: tables) else { continue }
                let d = abs(dr) + abs(dc)
                if d < bestDist { bestDist = d; best = (rr, cc, info.type) }
            }
        }
        return best
    }

    public func findBestApproachPath(fromRow: Int, fromCol: Int, targetRow: Int, targetCol: Int, excludingEntity: Entity?) -> [Int]? {
        var candidates = [(row: Int, col: Int, score: Int)]()
        for dr in -1...1 {
            for dc in -1...1 where !(dr == 0 && dc == 0) {
                let nr = targetRow + dr
                let nc = targetCol + dc
                guard map.isTileWalkable(row: nr, col: nc, tables: tables) else { continue }
                let occupied = entities.contains {
                    $0.active && $0 !== excludingEntity && $0.kind == .unit && $0.tileRow == nr && $0.tileCol == nc
                }
                let dist = abs(nr - fromRow) + abs(nc - fromCol)
                candidates.append((nr, nc, (occupied ? 1000 : 0) + dist))
            }
        }
        candidates.sort { $0.score < $1.score }
        for cand in candidates {
            if cand.row == fromRow && cand.col == fromCol {
                return [cand.row, cand.col]
            }
            if let path = Pathfinder.findPath(
                map: map,
                tables: tables,
                startRow: fromRow,
                startCol: fromCol,
                goalRow: cand.row,
                goalCol: cand.col,
                maxExpansions: 450
            ) {
                return path
            }
        }
        return nil
    }

    // MARK: - Landscape Touch & Camera Interaction

    public func centerCamera(onWorldRow rPx: Int, worldCol cPx: Int) {
        let iso = GameMap.worldToIso(worldX: rPx, worldY: cPx)
        cameraIsoX = iso.0 - XSMaxLayout.gameLogicalWidth / 2
        cameraIsoY = iso.1 - (XSMaxLayout.playfieldBottomY / 2)
    }

    public func clampCamera() {
        let topCorner = GameMap.worldToIso(worldX: 0, worldY: 0)
        let botCorner = GameMap.worldToIso(worldX: (map.rows - 1) * GameMap.tileLogicSize, worldY: (map.cols - 1) * GameMap.tileLogicSize)
        let leftCorner = GameMap.worldToIso(worldX: (map.rows - 1) * GameMap.tileLogicSize, worldY: 0)
        let rightCorner = GameMap.worldToIso(worldX: 0, worldY: (map.cols - 1) * GameMap.tileLogicSize)
        let minX = leftCorner.0 - 120
        let maxX = rightCorner.0 - XSMaxLayout.gameLogicalWidth + 120
        let minY = topCorner.1 - 60
        let maxY = botCorner.1 - XSMaxLayout.playfieldBottomY + 60
        if minX <= maxX { cameraIsoX = max(minX, min(maxX, cameraIsoX)) }
        if minY <= maxY { cameraIsoY = max(minY, min(maxY, cameraIsoY)) }
    }

    public func moveCursor(dRow: Int, dCol: Int) {
        setCursor(row: cursorEntity.tileRow + dRow, col: cursorEntity.tileCol + dCol)
        ensureCursorInCameraView()
    }

    public func setCursor(row: Int, col: Int) {
        cursorEntity.tileRow = max(0, min(map.rows - 1, row))
        cursorEntity.tileCol = max(0, min(map.cols - 1, col))
        cursorEntity.xFixed = (cursorEntity.tileRow * GameMap.tileLogicSize) << 8
        cursorEntity.yFixed = (cursorEntity.tileCol * GameMap.tileLogicSize) << 8
    }

    private func ensureCursorInCameraView() {
        let iso = GameMap.worldToIso(worldX: cursorEntity.xFixed >> 8, worldY: cursorEntity.yFixed >> 8)
        let sx = iso.0 - cameraIsoX
        let sy = iso.1 - cameraIsoY
        if sx < 64 { cameraIsoX -= (64 - sx) }
        else if sx > XSMaxLayout.gameLogicalWidth - 64 { cameraIsoX += (sx - (XSMaxLayout.gameLogicalWidth - 64)) }
        if sy < 44 { cameraIsoY -= (44 - sy) }
        else if sy > XSMaxLayout.playfieldBottomY - 36 { cameraIsoY += (sy - (XSMaxLayout.playfieldBottomY - 36)) }
    }

    public func handleKeyPress(_ keyMask: Int) {
        if (keyMask & KeyBits.up) != 0 { moveCursor(dRow: -1, dCol: -1) }
        if (keyMask & KeyBits.down) != 0 { moveCursor(dRow: 1, dCol: 1) }
        if (keyMask & KeyBits.left) != 0 { moveCursor(dRow: 1, dCol: -1) }
        if (keyMask & KeyBits.right) != 0 { moveCursor(dRow: -1, dCol: 1) }
        if (keyMask & KeyBits.num1) != 0 && !activeCommandList.isEmpty {
            selectedCmdIndex = (selectedCmdIndex - 1 + activeCommandList.count) % activeCommandList.count
        }
        if (keyMask & KeyBits.num3) != 0 && !activeCommandList.isEmpty {
            selectedCmdIndex = (selectedCmdIndex + 1) % activeCommandList.count
        }
        if (keyMask & KeyBits.num7) != 0 { cyclePlayerUnit(militaryOnly: false) }
        if (keyMask & KeyBits.num9) != 0 { cyclePlayerUnit(militaryOnly: true) }
        if (keyMask & KeyBits.star) != 0,
           let tc = entities.first(where: { $0.owner == 0 && $0.kind == .building && $0.buildingType == 1 }) {
            selectSingleEntity(tc)
            setCursor(row: tc.tileRow, col: tc.tileCol)
            centerCamera(onWorldRow: tc.xFixed >> 8, worldCol: tc.yFixed >> 8)
        }
        if (keyMask & KeyBits.pound) != 0 { minimapVisible.toggle() }
        if (keyMask & KeyBits.num0) != 0 { triggerActiveCommand() }
        if (keyMask & KeyBits.fire) != 0 { activateCursorAtTile() }
    }

    // Touch-first Landscape Tap Mapping
    public func handleCanvasTap(screenX: Int, screenY: Int) {
        // 1. Top Bar buttons (y: 0..<topBarHeight)
        if screenY < XSMaxLayout.topBarHeight {
            if screenX >= 456 {
                onPauseRequested?()
                return
            } else if screenX >= 404 {
                minimapVisible.toggle()
                return
            } else if screenX >= 352 {
                selectIdleSettler()
                return
            } else if screenX >= 296 {
                selectAllSameUnits()
                return
            }
            return
        }

        // 2. Minimap tap-to-jump (top-right under topBar)
        if minimapVisible {
            let mmW = map.cols * 2
            let mmH = map.rows * 2
            let mx = XSMaxLayout.gameLogicalWidth - mmW - 6
            let my = XSMaxLayout.topBarHeight + 4
            if screenX >= mx && screenX < mx + mmW && screenY >= my && screenY < my + mmH {
                let targetCol = max(0, min(map.cols - 1, (screenX - mx) / 2))
                let targetRow = max(0, min(map.rows - 1, (screenY - my) / 2))
                setCursor(row: targetRow, col: targetCol)
                centerCamera(onWorldRow: targetRow * GameMap.tileLogicSize, worldCol: targetCol * GameMap.tileLogicSize)
                return
            }
        }

        // 3. Bottom Command HUD Bar (y: playfieldBottomY..<gameLogicalHeight)
        if screenY >= XSMaxLayout.playfieldBottomY {
            if buildPlacementCmd != nil && screenX >= 434 {
                buildPlacementCmd = nil
                return
            }
            if !activeCommandList.isEmpty {
                let cellW = 28
                let startX = 10
                let rel = screenX - startX
                if rel >= 0 && screenY <= XSMaxLayout.playfieldBottomY + 26 {
                    let idx = rel / cellW
                    if idx >= 0 && idx < activeCommandList.count {
                        selectedCmdIndex = idx
                        triggerActiveCommand()
                        return
                    }
                }
            }
            // Also allow direct tap on Menu/HomeCity bottom-right
            if screenX >= 434 {
                onPauseRequested?()
            }
            return
        }

        // 4. Playfield Map Tap (y: topBarHeight..<playfieldBottomY)
        // Check pixel-accurate hit against live units FIRST (people naturally tap unit sprites, which sit above tile feet!)
        let tappedUnit = hitTestUnitOnScreen(screenX: screenX, screenY: screenY)
        let isoX = screenX + cameraIsoX
        let isoY = screenY + cameraIsoY
        let (rPx, cPx) = GameMap.isoToWorld(isoX: isoX, isoY: isoY)
        let tileR = max(0, min(map.rows - 1, GameMap.worldPxToTile(rPx)))
        let tileC = max(0, min(map.cols - 1, GameMap.worldPxToTile(cPx)))

        setCursor(row: tileR, col: tileC)
        activateTap(atRow: tileR, col: tileC, screenX: screenX, screenY: screenY, hitUnit: tappedUnit)
    }

    private func hitTestUnitOnScreen(screenX: Int, screenY: Int) -> Entity? {
        // Test front-most entities first
        let candidates = entities.filter { $0.active && $0.kind == .unit }
            .sorted { ($0.xFixed + $0.yFixed) > ($1.xFixed + $1.yFixed) }
        for u in candidates {
            let rPx = (u.xFixed >> 8) + GameMap.tileHalfLogic
            let cPx = (u.yFixed >> 8) + GameMap.tileHalfLogic
            let iso = GameMap.worldToIso(worldX: rPx, worldY: cPx)
            let sx = iso.0 - cameraIsoX
            let sy = iso.1 - cameraIsoY
            if abs(screenX - sx) <= 13 && screenY >= sy - 24 && screenY <= sy + 8 {
                return u
            }
        }
        return nil
    }

    public func activateCursorAtTile() {
        let cIso = GameMap.worldToIso(worldX: cursorEntity.tileRow * GameMap.tileLogicSize, worldY: cursorEntity.tileCol * GameMap.tileLogicSize)
        activateTap(
            atRow: cursorEntity.tileRow,
            col: cursorEntity.tileCol,
            screenX: cIso.0 - cameraIsoX,
            screenY: cIso.1 - cameraIsoY + 8,
            hitUnit: nil
        )
    }

    private func activateTap(atRow r: Int, col c: Int, screenX sx: Int, screenY sy: Int, hitUnit: Entity?) {
        // 1. Building placement mode
        if let cmd = buildPlacementCmd {
            let bType = cmd + 1
            if placeBuildingForOwner(owner: 0, buildingType: bType, row: r, col: c, constructedImmediately: false) {
                buildPlacementCmd = nil
                tapMarker = (r, c, 0x00FF66, 12)
            } else {
                tapMarker = (r, c, 0xFF3333, 12)
            }
            return
        }

        // 2. Check direct unit hit (hit test or tile occupancy)
        if let tgt = hitUnit ?? unitAtTile(row: r, col: c) {
            if tgt.owner == 0 {
                if selectedEntity === tgt {
                    selectAllUnits(ofType: tgt.unitType)
                    tapMarker = (tgt.tileRow, tgt.tileCol, 0x44CCFF, 10)
                } else {
                    selectSingleEntity(tgt)
                    tapMarker = (tgt.tileRow, tgt.tileCol, 0x00FF66, 10)
                }
                return
            } else if !selectedUnits.isEmpty {
                for u in selectedUnits where u.active {
                    u.refs[0] = tgt
                    u.flags[2] = false
                    u.flags[4] = false
                    u.flags[1] = false
                    u.intArrays[1] = nil
                }
                tapMarker = (tgt.tileRow, tgt.tileCol, 0xFF4444, 14)
                return
            }
        }

        let tappedBuilding = buildingAtTile(row: r, col: c)
        let activeSelUnits = selectedUnits.filter { $0.active && $0.owner == 0 && $0.kind == .unit }
        let hasSelectedSettlers = activeSelUnits.contains(where: { $0.unitType == 0 })

        // 3. Prioritize exact resource tile or close finger-radius resource match when settlers are selected
        if hasSelectedSettlers {
            let directRes = remainingResource(atRow: r, col: c).map { (r, c, $0.type) }
            let pickedRes = directRes ?? (tappedBuilding == nil ? findResourceNearTap(row: r, col: c, screenX: sx, screenY: sy) : nil)
            if let (resR, resC, rType) = pickedRes {
                for s in activeSelUnits where s.unitType == 0 {
                    s.bytes[15] = resR
                    s.bytes[16] = resC
                    s.bytes[6] = rType
                    s.flags[1] = false
                    s.intArrays[1] = nil
                    s.flags[2] = true
                    s.flags[4] = false
                    s.refs[0] = nil
                    s.refs[1] = nil
                    s.bytes[24] = 0
                    s.bytes[25] = 0
                    if GameMap.tileDistance(r0: s.tileRow, c0: s.tileCol, r1: resR, c1: resC) > 1,
                       let path = findBestApproachPath(fromRow: s.tileRow, fromCol: s.tileCol, targetRow: resR, targetCol: resC, excludingEntity: s) {
                        s.intArrays[1] = path
                        s.flags[1] = true
                        s.bytes[25] = 6
                    }
                }
                inspectedResource = (resR, resC)
                tapMarker = (resR, resC, 0xFFDD44, 14)
                return
            }
        }

        // 4. Select friendly building or attack enemy building
        if let bld = tappedBuilding {
            if bld.owner == 0 {
                selectSingleEntity(bld)
                tapMarker = (bld.tileRow, bld.tileCol, 0x00FF66, 10)
            } else if !selectedUnits.isEmpty {
                for u in selectedUnits where u.active {
                    u.refs[0] = bld
                    u.flags[2] = false
                    u.flags[4] = false
                    u.flags[1] = false
                    u.intArrays[1] = nil
                }
                tapMarker = (bld.tileRow, bld.tileCol, 0xFF4444, 14)
            }
            return
        }

        // 5. Inspect resource node even if no settler is currently selected
        if let info = remainingResource(atRow: r, col: c) {
            inspectedResource = (r, c)
            tapMarker = (r, c, 0xFFDD44, 14)
            showPopup("\(resourceTypeName(info.type)): \(info.remaining)/\(info.capacity) (Chon Dan de thu)")
            return
        }

        // 6. Move selected units to tapped ground
        if !activeSelUnits.isEmpty {
            inspectedResource = nil
            for (idx, u) in activeSelUnits.enumerated() {
                u.refs[0] = nil
                u.flags[2] = false
                u.flags[4] = false
                u.flags[1] = false
                u.intArrays[1] = nil
                let dest = idx == 0 ? (r, c) : (Pathfinder.findNearestWalkableTile(map: map, tables: tables, nearRow: r, nearCol: c, maxRadius: 2) ?? (r, c))
                if let path = Pathfinder.findPath(map: map, tables: tables, startRow: u.tileRow, startCol: u.tileCol, goalRow: dest.0, goalCol: dest.1, maxExpansions: 450) {
                    u.intArrays[1] = path
                    u.flags[1] = true
                }
            }
            tapMarker = (r, c, 0x00FF88, 12)
        }
    }

    private func findResourceNearTap(row: Int, col: Int, screenX: Int, screenY: Int) -> (Int, Int, Int)? {
        if let exact = remainingResource(atRow: row, col: col) {
            return (row, col, exact.type)
        }
        // Check all 8 neighbors + isometric tree canopy offsets (for 52px tall props), choosing nearest visual node within 24px
        let offsets = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1), (2, 2)]
        var best: (r: Int, c: Int, rt: Int, distSq: Int)?
        for (dr, dc) in offsets {
            let rr = row + dr, cc = col + dc
            guard let info = remainingResource(atRow: rr, col: cc) else { continue }
            let code = map.terrainAt(row: rr, col: cc)
            let pairIdx = code * 2
            let isTallProp = (pairIdx >= 0 && pairIdx < tables.PB.count && tables.PB[pairIdx] >= 100)
            if (dr == 2 || dc == 2) && !isTallProp { continue }
            let iso = GameMap.worldToIso(worldX: rr * GameMap.tileLogicSize, worldY: cc * GameMap.tileLogicSize)
            let cx = iso.0 - cameraIsoX
            let cy = iso.1 - cameraIsoY + (isTallProp ? -6 : 8)
            let dx = screenX - cx
            let dy = screenY - cy
            let dSq = dx * dx + dy * dy
            let limitSq = isTallProp ? 900 : 576
            if dSq <= limitSq, (best == nil || dSq < best!.distSq) {
                best = (rr, cc, info.type, dSq)
            }
        }
        if let b = best { return (b.r, b.c, b.rt) }
        return nil
    }

    public func triggerActiveCommand() {
        guard selectedCmdIndex >= 0, selectedCmdIndex < activeCommandList.count else { return }
        let cmd = activeCommandList[selectedCmdIndex]
        if let sel = selectedEntity, sel.owner == 0 {
            if sel.kind == .unit && sel.unitType == 0 && cmd >= 0 && cmd <= 7 {
                if canAfford(owner: 0, commandId: cmd) {
                    buildPlacementCmd = cmd
                    showPopup("Cham ban do de xay: \(commandName(cmd))")
                } else {
                    showInsufficientCostPopup(for: cmd)
                }
            } else if sel.kind == .building {
                _ = issueBuildingCommand(sel, commandId: cmd)
            }
        }
    }

    private func selectSingleEntity(_ ent: Entity) {
        for u in selectedUnits { u.selected = false }
        selectedUnits.removeAll()
        selectedEntity?.selected = false
        selectedEntity = ent
        ent.selected = true
        if ent.kind == .unit && ent.owner == 0 {
            selectedUnits = [ent]
        }
        buildPlacementCmd = nil
        demolishArmedBuildingId = nil
        selectedCmdIndex = 0
        rebuildCommandList()
    }

    private func selectAllUnits(ofType uType: Int) {
        for u in entities { u.selected = false }
        let matched = entities.filter { $0.active && $0.owner == 0 && $0.kind == .unit && $0.unitType == uType }
        for m in matched { m.selected = true }
        selectedUnits = matched
        selectedEntity = matched.first
        rebuildCommandList()
    }

    private func selectAllSameUnits() {
        if let cur = selectedEntity, cur.kind == .unit {
            selectAllUnits(ofType: cur.unitType)
        } else {
            let military = entities.filter { $0.active && $0.owner == 0 && $0.kind == .unit && $0.unitType > 0 }
            let list = military.isEmpty ? entities.filter { $0.active && $0.owner == 0 && $0.kind == .unit } : military
            guard !list.isEmpty else { return }
            for u in entities { u.selected = false }
            for u in list { u.selected = true }
            selectedUnits = list
            selectedEntity = list.first
            rebuildCommandList()
        }
    }

    private func selectIdleSettler() {
        let settlers = entities.filter { $0.active && $0.owner == 0 && $0.kind == .unit && $0.unitType == 0 }
        let idle = settlers.filter { !$0.flags[1] && !$0.flags[2] && !$0.flags[4] }
        let pool = idle.isEmpty ? settlers : idle
        guard !pool.isEmpty else { return }
        let pick = pool[idleCycleIdx % pool.count]
        idleCycleIdx += 1
        selectSingleEntity(pick)
        setCursor(row: pick.tileRow, col: pick.tileCol)
        centerCamera(onWorldRow: pick.xFixed >> 8, worldCol: pick.yFixed >> 8)
    }

    private func cyclePlayerUnit(militaryOnly: Bool) {
        let candidates = entities.filter {
            $0.active && $0.owner == 0 && $0.kind == .unit && (!militaryOnly || $0.unitType > 0)
        }
        guard !candidates.isEmpty else { return }
        if let cur = selectedEntity, let idx = candidates.firstIndex(where: { $0 === cur }) {
            let next = candidates[(idx + 1) % candidates.count]
            selectSingleEntity(next)
            setCursor(row: next.tileRow, col: next.tileCol)
            ensureCursorInCameraView()
        } else {
            let first = candidates[0]
            selectSingleEntity(first)
            setCursor(row: first.tileRow, col: first.tileCol)
            ensureCursorInCameraView()
        }
    }

    private func unitAtTile(row: Int, col: Int) -> Entity? {
        return entities.first { $0.active && $0.kind == .unit && $0.tileRow == row && $0.tileCol == col }
    }

    private func buildingAtTile(row: Int, col: Int) -> Entity? {
        for bld in entities where bld.active && bld.kind == .building {
            let tiles = buildingFootprintTiles(bld)
            if tiles.contains(where: { $0.0 == row && $0.1 == col }) {
                return bld
            }
        }
        return nil
    }

    private func entityAtTile(row: Int, col: Int) -> Entity? {
        return unitAtTile(row: row, col: col) ?? buildingAtTile(row: row, col: col)
    }

    public func rebuildCommandList() {
        activeCommandList.removeAll()
        guard let sel = selectedEntity, sel.owner == 0 else { return }
        if sel.kind == .unit && sel.unitType == 0 {
            activeCommandList = tables.cBB[0].filter { isCommandUnlocked($0) }
        } else if sel.kind == .building {
            let bt = sel.buildingType
            if bt >= 0 && bt < tables.cBB.count {
                activeCommandList = tables.cBB[bt].filter { isCommandUnlocked($0) }
            }
        }
    }

    public func commandName(_ cmd: Int) -> String {
        if cmd >= 0 && cmd <= 7 { return localization.text(174 + cmd) }
        else if cmd >= 8 && cmd <= 15 {
            let ut = cmd - 8
            if ut < tables.cSS.count, let sid = tables.cSS[ut].first { return localization.text(sid) }
        } else if cmd == 16 { return localization.text(185) }
        else if cmd == 17 { return localization.text(186) }
        else if cmd == 18 { return localization.text(188) }
        else if cmd == 19 { return localization.text(189) }
        else if cmd == 20 { return localization.text(190) }
        else if cmd == 21 { return localization.text(191) }
        else if cmd == 22 { return localization.text(192) }
        else if cmd == 23 { return localization.text(194) }
        else if cmd >= 24 && cmd <= 26 { return localization.text(200 + (cmd - 24)) }
        return localization.text(146)
    }

    public func showPopup(_ msg: String) {
        activeMessage = msg
        activeMessageTimer = 55
    }

    // MARK: - Binary State Serialization (Port of e.b() / e.r())

    public func serializeState(title: String) -> Data {
        let w = BigEndianWriter()
        w.writeUTF(title)
        w.writeBool(isCampaign)
        w.writeIntByte(campaignMission)
        w.writeIntByte(difficulty)
        w.writeIntByte(faction)
        w.writeIntByte(map.mapSlotIndex)
        w.writeInt32(commandUnlockMask)
        w.writeInt32(tickCount)
        w.writeInt32(cameraIsoX)
        w.writeInt32(cameraIsoY)
        for p in 0..<4 {
            for r in 0..<3 { w.writeInt32(playerResources[p][r]) }
            w.writeIntByte(playerAges[p])
            for t in 0..<3 { w.writeIntByte(playerTechTiers[p][t]) }
        }
        w.writeIntShort(map.fogGrid.count)
        for fg in map.fogGrid { w.writeInt32(fg) }
        w.writeIntShort(entities.count)
        for ent in entities { ent.serialize(to: w) }
        w.writeIntShort(map.terrain.count)
        for t in map.terrain { w.writeIntByte(t) }
        w.writeIntShort(resourceAmounts.count)
        for (idx, rem) in resourceAmounts.sorted(by: { $0.key < $1.key }) {
            w.writeInt32(idx)
            w.writeIntShort(rem)
        }
        return w.data
    }

    public func deserializeState(data: Data) -> Bool {
        ensureGraphicsLoaded()
        let r = BigEndianReader(data: data)
        do {
            _ = try r.readUTF()
            isCampaign = try r.readBool()
            campaignMission = Int(try r.readByte())
            difficulty = Int(try r.readByte())
            faction = Int(try r.readByte())
            let mapIdx = Int(try r.readByte())
            commandUnlockMask = Int(try r.readInt())
            tickCount = Int(try r.readInt())
            cameraIsoX = Int(try r.readInt())
            cameraIsoY = Int(try r.readInt())
            for p in 0..<4 {
                for res in 0..<3 { playerResources[p][res] = Int(try r.readInt()) }
                playerAges[p] = Int(try r.readByte())
                for t in 0..<3 { playerTechTiers[p][t] = Int(try r.readByte()) }
            }
            _ = map.load(mapIndex: mapIdx, tables: tables, assets: assets, rng: &rngState)
            let fogLen = max(0, Int(try r.readShort()))
            var newFog = [Int](repeating: 0, count: fogLen)
            for idx in 0..<fogLen { newFog[idx] = Int(try r.readInt()) }
            if newFog.count == map.fogGrid.count { map.fogGrid = newFog }

            let entCount = max(0, Int(try r.readShort()))
            var decoded = [(Entity, [Int])]()
            var byId = [Int: Entity]()
            var maxId = 0
            for _ in 0..<entCount {
                let pair = try Entity.deserialize(from: r)
                decoded.append(pair)
                byId[pair.0.id] = pair.0
                maxId = max(maxId, pair.0.id)
            }
            for (ent, refIds) in decoded {
                for idx in 0..<min(refIds.count, ent.refs.count) {
                    let rid = refIds[idx]
                    ent.refs[idx] = rid >= 0 ? byId[rid] : nil
                }
                if ent.kind == .building { stampBuildingFootprint(ent, occupy: true) }
            }
            self.entities = decoded.map { $0.0 }
            self.nextEntityId = maxId + 1
            if r.remaining >= 2 {
                let tCount = Int(try r.readUnsignedShort())
                if tCount == map.terrain.count {
                    for i in 0..<tCount { map.terrain[i] = try r.readUnsignedByte() }
                }
                if r.remaining >= 2 {
                    let raCount = Int(try r.readUnsignedShort())
                    var newAmounts = [Int: Int]()
                    newAmounts.reserveCapacity(raCount)
                    for _ in 0..<raCount {
                        let k = Int(try r.readInt())
                        let v = Int(try r.readShort())
                        if v > 0 { newAmounts[k] = v }
                    }
                    self.resourceAmounts = newAmounts
                }
            }
            self.selectedEntity = self.entities.first(where: { $0.selected }) ?? self.entities.first(where: { $0.owner == 0 })
            self.selectedUnits = self.entities.filter { $0.selected && $0.kind == .unit && $0.owner == 0 }
            recomputePopulations()
            rebuildCommandList()
            outcome = .playing
            return true
        } catch {
            return false
        }
    }

    // MARK: - Isometric Software Renderer (Diagonal Painter's Algorithm matching e.a(Graphics))

    public func render(to g: SoftwareRenderer) {
        g.setColor(0x0B0F0A)
        g.fillRect(0, 0, XSMaxLayout.gameLogicalWidth, XSMaxLayout.gameLogicalHeight)

        g.pushClipAndSetFullWidth(height: XSMaxLayout.playfieldBottomY)

        // 1. Diagonal painter's-algorithm terrain + prop tiles (Anchor.hcenter | Anchor.bottom at (isoX, isoY + 16))
        let maxSum = (map.rows - 1) + (map.cols - 1)
        if maxSum >= 0 {
            for sum in 0...maxSum {
                let rStart = max(0, sum - (map.cols - 1))
                let rEnd = min(map.rows - 1, sum)
                if rStart > rEnd { continue }
                for row in rStart...rEnd {
                    let col = sum - row
                    let idx = row * map.cols + col
                    let fog = map.fogGrid[idx]
                    let code = map.terrain[idx]
                    if code < 0 { continue }

                    let wx = row * GameMap.tileLogicSize
                    let wy = col * GameMap.tileLogicSize
                    let iso = GameMap.worldToIso(worldX: wx, worldY: wy)
                    let sx = iso.0 - cameraIsoX
                    let sy = iso.1 - cameraIsoY

                    if sx < -48 || sx > XSMaxLayout.gameLogicalWidth + 48 || sy < -64 || sy > XSMaxLayout.playfieldBottomY + 64 {
                        continue
                    }

                    if (fog & 1) == 0 {
                        g.setColor(0x050605)
                        g.fillTriangle(sx, sy, sx + 16, sy + 8, sx, sy + 16)
                        g.fillTriangle(sx, sy, sx - 16, sy + 8, sx, sy + 16)
                        continue
                    }

                    let pairBase = code * 2
                    if let pair = (pairBase >= 0 && pairBase + 1 < tables.PB.count) ? (tables.PB[pairBase], tables.PB[pairBase + 1]) : nil {
                        let rawSlice = pair.0
                        let trans = pair.1
                        if rawSlice < 100 && rawSlice >= 0 && rawSlice < terrainTiles.count {
                            g.drawSprite(terrainTiles[rawSlice], x: sx, y: sy + GameMap.tilePixelH, transform: trans, anchor: Anchor.hcenter | Anchor.bottom)
                        } else if rawSlice >= 100 {
                            if !terrainTiles.isEmpty {
                                g.drawSprite(terrainTiles[0], x: sx, y: sy + GameMap.tilePixelH, transform: 0, anchor: Anchor.hcenter | Anchor.bottom)
                            }
                            let propIdx = rawSlice - 100
                            if propIdx >= 0 && propIdx < propTiles.count {
                                g.drawSprite(propTiles[propIdx], x: sx, y: sy + GameMap.tilePixelH, transform: trans, anchor: Anchor.hcenter | Anchor.bottom)
                            }
                        }
                    } else if !terrainTiles.isEmpty {
                        g.drawSprite(terrainTiles[0], x: sx, y: sy + GameMap.tilePixelH, transform: 0, anchor: Anchor.hcenter | Anchor.bottom)
                    }

                    // Draw live depletion bar when resource node has been partially harvested
                    if let resInfo = remainingResource(atRow: row, col: col), resInfo.remaining < resInfo.capacity {
                        let barW = 14
                        let filled = max(1, (barW - 2) * resInfo.remaining / max(1, resInfo.capacity))
                        let bx = sx - barW / 2
                        let by = sy + 13
                        g.setColor(0x000000)
                        g.fillRect(bx, by, barW, 3)
                        let fillColor = resInfo.type == 0 ? 0xEE5533 : (resInfo.type == 1 ? 0x99DD44 : 0xFFD43B)
                        g.setColor(fillColor)
                        g.fillRect(bx + 1, by + 1, filled, 1)
                    }
                }
            }
        }

        // 2. Depth-sorted Entities
        let sorted = entities.filter { $0.active }.sorted { ($0.xFixed + $0.yFixed) < ($1.xFixed + $1.yFixed) }
        for ent in sorted {
            let rPx = (ent.xFixed >> 8) + GameMap.tileHalfLogic
            let cPx = (ent.yFixed >> 8) + GameMap.tileHalfLogic
            let iso = GameMap.worldToIso(worldX: rPx, worldY: cPx)
            let sx = iso.0 - cameraIsoX
            let sy = iso.1 - cameraIsoY
            if sx < -48 || sx > XSMaxLayout.gameLogicalWidth + 48 || sy < -64 || sy > XSMaxLayout.playfieldBottomY + 48 { continue }

            switch ent.kind {
            case .floatingText:
                let rType = max(0, min(2, ent.bytes[6]))
                let txt = "+\(ent.ints[3])"
                if rType + 1 < resourcePips.count, let pip = resourcePips[rType + 1] {
                    g.drawSprite(pip, x: sx - 12, y: sy - 20)
                }
                g.setColor(rType == 0 ? 0xFF8866 : (rType == 1 ? 0xA8EE66 : 0xFFE066))
                g.drawString(fontId: 1, txt, x: sx + 4, y: sy - 12, anchor: Anchor.hcenter | Anchor.bottom)
            case .fx:
                drawEntitySprite(ent, sx: sx, sy: sy, g: g)
            case .building:
                if ent.selected || ent.hp < ent.maxHP(engine: self) || ent.state == 0 {
                    drawHealthBar(hp: ent.hp, maxHP: ent.maxHP(engine: self), owner: ent.owner, x: sx - 10, y: sy - 24, g: g)
                }
                if ent.selected {
                    drawIsoDiamond(centerX: sx, centerY: sy + 8, color: ent.owner == 0 ? 0x00FF66 : 0xFF4444, g: g)
                }
            case .unit:
                if ent.selected {
                    g.setColor(ent.owner == 0 ? 0x00FF00 : 0xFF3333)
                    g.drawLine(sx - 9, sy + 2, sx, sy - 2)
                    g.drawLine(sx, sy - 2, sx + 9, sy + 2)
                    g.drawLine(sx + 9, sy + 2, sx, sy + 6)
                    g.drawLine(sx, sy + 6, sx - 9, sy + 2)
                }
                drawEntitySprite(ent, sx: sx, sy: sy, g: g)
                if ent.selected || ent.hp < ent.maxHP(engine: self) {
                    drawHealthBar(hp: ent.hp, maxHP: ent.maxHP(engine: self), owner: ent.owner, x: sx - 6, y: sy - 21, g: g)
                }
            case .cursor:
                break
            }
        }

        // 3. Tap visual feedback diamond or Building Placement Footprint Preview
        if let buildCmd = buildPlacementCmd {
            let bType = buildCmd + 1
            let ok = canPlaceBuilding(buildingType: bType, row: cursorEntity.tileRow, col: cursorEntity.tileCol)
            let previewColor = ok ? 0x00FF88 : 0xFF3333
            if bType < tables.hBB.count, let fp = tables.hBB[bType] {
                var i = 0
                while i + 2 < fp.count {
                    let tr = cursorEntity.tileRow + fp[i], tc = cursorEntity.tileCol + fp[i + 1]
                    let pIso = GameMap.worldToIso(worldX: tr * GameMap.tileLogicSize, worldY: tc * GameMap.tileLogicSize)
                    drawIsoDiamond(centerX: pIso.0 - cameraIsoX, centerY: pIso.1 - cameraIsoY + 8, color: previewColor, g: g)
                    i += 3
                }
            }
        } else if let tm = tapMarker {
            let tIso = GameMap.worldToIso(worldX: tm.row * GameMap.tileLogicSize, worldY: tm.col * GameMap.tileLogicSize)
            drawIsoDiamond(centerX: tIso.0 - cameraIsoX, centerY: tIso.1 - cameraIsoY + 8, color: tm.color, g: g)
        } else {
            let cIso = GameMap.worldToIso(worldX: cursorEntity.tileRow * GameMap.tileLogicSize, worldY: cursorEntity.tileCol * GameMap.tileLogicSize)
            drawIsoDiamond(centerX: cIso.0 - cameraIsoX, centerY: cIso.1 - cameraIsoY + 8, color: 0xFFDD44, g: g)
        }

        if minimapVisible {
            drawMinimap(g: g)
        }

        g.popClip()

        // 4. Landscape HUD Top Bar & Touch Bottom Command Strip
        drawHUD(g: g)
    }

    private func drawIsoDiamond(centerX cx: Int, centerY cy: Int, color: Int, g: SoftwareRenderer) {
        g.setColor(color)
        g.drawLine(cx - 15, cy, cx, cy - 8)
        g.drawLine(cx, cy - 8, cx + 15, cy)
        g.drawLine(cx + 15, cy, cx, cy + 8)
        g.drawLine(cx, cy + 8, cx - 15, cy)
    }

    private func drawEntitySprite(_ ent: Entity, sx: Int, sy: Int, g: SoftwareRenderer) {
        guard ent.spriteSlot >= 0, let pack = spritePacks[ent.spriteSlot] else {
            g.setColor(ent.owner == 0 ? 0x3399FF : 0xEE4444)
            g.fillRect(sx - 5, sy - 12, 10, 12)
            return
        }
        let seq = max(0, min(ent.animSeq, pack.seqFrames.count - 1))
        guard !pack.seqFrames.isEmpty, !pack.seqFrames[seq].isEmpty else { return }
        let frameIdx = max(0, min(ent.animFrame, pack.seqFrames[seq].count - 1))
        let pieceIdx = pack.seqFrames[seq][frameIdx]
        let trans = (seq < pack.seqTransforms.count && frameIdx < pack.seqTransforms[seq].count) ? pack.seqTransforms[seq][frameIdx] : 0
        // Port of b.java:343-346: Heavy Cannon (unitType == 7) uses palette variant +3
        let palOffset = (ent.kind == .unit && ent.unitType == 7) ? 3 : 0
        let variantIdx = max(0, min(ent.owner + palOffset, pack.variantSprites.count - 1))
        guard variantIdx < pack.variantSprites.count, pieceIdx >= 0, pieceIdx < pack.variantSprites[variantIdx].count else { return }
        let sprite = pack.variantSprites[variantIdx][pieceIdx]
        var dx = pack.anchorX
        if trans == SpriteTransform.mirror {
            dx = -(sprite.width + dx)
        }
        g.drawSprite(sprite, x: sx + dx, y: sy + pack.anchorY, transform: trans)
    }

    private func drawHealthBar(hp: Int, maxHP: Int, owner: Int, x: Int, y: Int, g: SoftwareRenderer) {
        let w = 14
        let filled = maxHP > 0 ? max(0, min(w - 2, ((w - 2) * hp) / maxHP)) : 0
        g.setColor(0x000000)
        g.fillRect(x, y, w, 4)
        g.setColor(owner == 0 ? 0x00DD44 : 0xEE3322)
        g.fillRect(x + 1, y + 1, filled, 2)
    }

    private func drawMinimap(g: SoftwareRenderer) {
        let mmW = map.cols * 2
        let mmH = map.rows * 2
        let mx = XSMaxLayout.gameLogicalWidth - mmW - 6
        let my = XSMaxLayout.topBarHeight + 4
        g.setColor(0x111611)
        g.fillRect(mx - 2, my - 2, mmW + 4, mmH + 4)
        g.setColor(0x8E7441)
        g.drawRect(mx - 2, my - 2, mmW + 4, mmH + 4)
        for r in 0..<map.rows {
            for c in 0..<map.cols {
                let fog = map.fogGrid[r * map.cols + c]
                if (fog & 1) == 0 { g.setColor(0x000000) }
                else if (fog & 8) != 0 { g.setColor(0x226622) }
                else { g.setColor(0x4E683B) }
                g.fillRect(mx + c * 2, my + r * 2, 2, 2)
            }
        }
        for ent in entities where ent.active && (ent.kind == .unit || ent.kind == .building) {
            g.setColor(ent.owner == 0 ? 0x44AAFF : 0xFF3333)
            g.fillRect(mx + ent.tileCol * 2, my + ent.tileRow * 2, 2, 2)
        }
    }

    private func drawHUD(g: SoftwareRenderer) {
        // Top Resource Bar (y = 0..20, 512px wide) with 53.res icons (Food, Wood, Gold, Pop)
        g.setColor(0x1B140C)
        g.fillRect(0, 0, XSMaxLayout.gameLogicalWidth, XSMaxLayout.topBarHeight)
        g.setColor(0x9E7D44)
        g.drawLine(0, XSMaxLayout.topBarHeight, XSMaxLayout.gameLogicalWidth, XSMaxLayout.topBarHeight)

        let res = playerResources[0]
        let topSlots: [(Int, Int, String)] = [
            (6, 1, "\(res[0])"),
            (66, 2, "\(res[1])"),
            (126, 3, "\(res[2])"),
            (186, 4, "\(playerPopUsed[0])/\(playerPopCap[0])")
        ]
        for (sxPos, pipIdx, valueText) in topSlots {
            if pipIdx < resourcePips.count, let pip = resourcePips[pipIdx] {
                g.drawSprite(pip, x: sxPos, y: 7)
            }
            g.setColor(0xFFFFFF)
            g.drawString(fontId: 1, valueText, x: sxPos + 9, y: 2, anchor: Anchor.top | Anchor.left)
        }
        g.drawString(fontId: 1, "Age\(playerAges[0] + 1)", x: 252, y: 2, anchor: Anchor.top | Anchor.left)

        // Touch action buttons on Top-Right bar: [Tat ca], [Dan], [Map], [Menu]
        let topBtns: [(Int, Int, String)] = [(296, 54, "Tat ca"), (352, 50, "Dan"), (404, 50, "Map"), (456, 52, "Menu")]
        for (bx, bw, label) in topBtns {
            g.setColor(0x3B2B17)
            g.fillRect(bx, 2, bw, 16)
            g.setColor(0x9E7D44)
            g.drawRect(bx, 2, bw, 16)
            g.drawString(fontId: 1, label, x: bx + bw / 2, y: 3, anchor: Anchor.top | Anchor.hcenter)
        }

        // Active / Inspected Resource Node Remaining Chip (Port of e.pseudo.java:3803)
        let activeNodeCoord: (Int, Int)? = {
            if let s = selectedEntity, s.kind == .unit, s.unitType == 0, s.flags[2] {
                return (s.bytes[15], s.bytes[16])
            }
            return inspectedResource
        }()
        if let (nr, nc) = activeNodeCoord, let info = remainingResource(atRow: nr, col: nc) {
            g.setColor(0x1B140C)
            g.fillRect(6, 24, 96, 16)
            g.setColor(0xB8914E)
            g.drawRect(6, 24, 96, 16)
            if info.type + 1 < resourcePips.count, let pip = resourcePips[info.type + 1] {
                g.drawSprite(pip, x: 10, y: 29)
            }
            g.setColor(0xFFE066)
            g.drawString(fontId: 1, "\(info.remaining)/\(info.capacity)", x: 20, y: 24, anchor: Anchor.top | Anchor.left)
        }

        // Toast popup banner (shifted clear of minimap and resource badge)
        if let msg = activeMessage {
            g.setColor(0x22180D)
            g.fillRect(108, 24, 316, 20)
            g.setColor(0xD4AF37)
            g.drawRect(108, 24, 316, 20)
            g.drawString(fontId: 1, msg, x: 266, y: 27, anchor: Anchor.top | Anchor.hcenter)
        }

        // Bottom Landscape Command Touch Bar (y = 206..250, height 44px)
        let barY = XSMaxLayout.playfieldBottomY
        g.setColor(0x1A130B)
        g.fillRect(0, barY, XSMaxLayout.gameLogicalWidth, XSMaxLayout.bottomBarHeight)
        g.setColor(0x8E7441)
        g.drawLine(0, barY, XSMaxLayout.gameLogicalWidth, barY)

        if !activeCommandList.isEmpty {
            let cellW = 28
            let startX = 10
            let bldQueue = (selectedEntity?.kind == .building) ? (selectedEntity?.intArrays[0] ?? []) : []
            for (idx, cmd) in activeCommandList.enumerated() {
                let bx = startX + idx * cellW
                let by = barY + 4
                let canPay = canAfford(owner: 0, commandId: cmd)
                g.setColor(idx == selectedCmdIndex ? 0x543B15 : (canPay ? 0x261B0E : 0x2A1111))
                g.fillRect(bx - 1, by - 1, 22, 22)
                g.setColor(idx == selectedCmdIndex ? 0xFFE066 : 0x6E5630)
                g.drawRect(bx - 1, by - 1, 22, 22)
                if cmd >= 0 && cmd < tables.FB.count {
                    let iconIdx = tables.FB[cmd]
                    if iconIdx >= 0 && iconIdx < commandIcons.count {
                        g.drawSprite(commandIcons[iconIdx], x: bx + 1, y: by + 1)
                    }
                }
                // Count queued instances of this command on the selected building
                var qCount = 0
                var qi = 0
                while qi + 1 < bldQueue.count {
                    if bldQueue[qi] == cmd { qCount += 1 }
                    qi += 2
                }
                if qCount > 0 {
                    g.setColor(0xFFE066)
                    g.drawString(fontId: 1, "\(qCount)", x: bx + 13, y: by + 8, anchor: Anchor.top | Anchor.left)
                }
            }
            if bldQueue.count >= 2 {
                g.setColor(0xFFE066)
                g.drawString(fontId: 1, "Tao: \(commandName(bldQueue[0]))", x: 426, y: barY + 8, anchor: Anchor.top | Anchor.right)
            }
            if selectedCmdIndex < activeCommandList.count {
                let cmd = activeCommandList[selectedCmdIndex]
                let nameStr = commandName(cmd)
                g.setColor(0xFFFFFF)
                g.drawString(fontId: 1, nameStr, x: 10, y: barY + 27, anchor: Anchor.top | Anchor.left)
                var cx = 10 + g.bitmapFont.stringWidth(fontId: 1, text: nameStr) + 8
                if cmd < tables.aSS.count && tables.aSS[cmd].count >= 3 {
                    let c = tables.aSS[cmd]
                    for r in 0..<3 where c[r] > 0 {
                        if r + 1 < resourcePips.count, let pip = resourcePips[r + 1] {
                            g.drawSprite(pip, x: cx, y: barY + 32)
                            cx += 8
                        }
                        let valStr = "\(c[r])"
                        let vw = g.bitmapFont.stringWidth(fontId: 1, text: valStr)
                        if playerResources[0][r] < c[r] {
                            // Port of e.pseudo.java:6371 (red shortfall box behind unaffordable resource cost)
                            g.setColor(0x9F0B13)
                            g.fillRect(cx - 1, barY + 28, vw + 2, 13)
                        }
                        g.setColor(0xFFFFFF)
                        g.drawString(fontId: 1, valStr, x: cx, y: barY + 27, anchor: Anchor.top | Anchor.left)
                        cx += vw + 8
                    }
                }
            }
        } else if let sel = selectedEntity {
            let title = sel.kind == .unit ? localization.text(150 + min(sel.unitType, 7)) : "Cong trinh #\(sel.buildingType)"
            let suffix = selectedUnits.count > 1 ? " x\(selectedUnits.count)" : ""
            g.drawString(fontId: 1, "\(title)\(suffix)  HP:\(sel.hp)/\(sel.maxHP(engine: self))", x: 12, y: barY + 14, anchor: Anchor.top | Anchor.left)
        } else {
            g.drawString(fontId: 1, "Cham dan/nha de chon | Cham cay/qua/vang de thu hoach", x: 12, y: barY + 14, anchor: Anchor.top | Anchor.left)
        }

        // Build Cancel or Quick Action button bottom-right (x: 434..506)
        let rightLabel = buildPlacementCmd != nil ? "Huy xay" : localization.text(331)
        g.setColor(buildPlacementCmd != nil ? 0x661B1B : 0x362714)
        g.fillRect(434, barY + 8, 72, 28)
        g.setColor(0xB8914E)
        g.drawRect(434, barY + 8, 72, 28)
        g.drawString(fontId: 1, rightLabel, x: 470, y: barY + 15, anchor: Anchor.top | Anchor.hcenter)
    }
}
