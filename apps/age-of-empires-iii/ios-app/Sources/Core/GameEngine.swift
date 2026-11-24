// Port of e.java — Core RTS Game Engine (terrain, fog, isometric rendering, combat, economy, triggers, saves)
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
    public var resourcePips: [GameSprite?] = []     // 53.res (5 x 6x6, slot 0 nil)
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
    public var campaignMission: Int = 0             // 0..14
    public var difficulty: Int = 1                  // 0=Easy, 1=Normal, 2=Hard
    public var faction: Int = 0
    public var commandUnlockMask: Int = 0x7FFF_FFFF // e.h[mission]
    public var outcome: GameOutcome = .playing

    public var entities: [Entity] = []
    public var nextEntityId: Int = 1
    public var cursorEntity: Entity = Entity(kind: .cursor, id: 0)
    public var selectedEntity: Entity?              // e.a:Lb
    public var rallyFlag: Entity?

    // Player stats (indices 0=Player, 1=AI1, 2=AI2)
    public var playerResources: [[Int]] = Array(repeating: [400, 400, 200], count: 4)
    public var playerPopUsed: [Int] = [0, 0, 0, 0]
    public var playerPopCap: [Int] = [10, 10, 10, 10]
    public var playerAges: [Int] = [0, 0, 0, 0]    // 0=Discovery, 1=Colonial, 2=Fortress
    public var playerTechTiers: [[Int]] = Array(repeating: [0, 0, 0], count: 4) // e.g:[[B per player
    public var playerSlotsMap: [Int]? = nil         // e.V
    public var aiControllers: [AIController] = []

    // HUD & Camera (360 x 400 viewport)
    public var cameraIsoX: Int = 0                  // e.o
    public var cameraIsoY: Int = 0                  // e.p
    public var selectedCmdIndex: Int = 0
    public var activeCommandList: [Int] = []
    public var buildPlacementCmd: Int? = nil        // non-nil when placing a building at cursor
    public var rallyModeActive: Bool = false
    public var demolishArmedBuildingId: Int? = nil
    public var homeCityXP: Int = 0
    public var homeCityShipmentReady: Bool = true
    public var minimapVisible: Bool = false

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

        // 54.res terrain split count & 55.res prop split count from e.P (e.o() bytecode)
        var terrCount = 1
        var propCount = 1
        var idx = 0
        while idx < tables.PB.count {
            let v = tables.PB[idx]
            if v < 100 {
                terrCount = max(terrCount, v + 1)
            } else {
                propCount = max(propCount, v - 100 + 1)
            }
            idx += 2
        }

        if let s54 = GameSprite(resId: 54, assets: assets) {
            terrainTiles = s54.splitHorizontally(count: terrCount)
        }
        if let s55 = GameSprite(resId: 55, assets: assets) {
            propTiles = s55.splitHorizontally(count: propCount)
        }
        if let s40 = GameSprite(resId: 40, assets: assets) {
            fogTiles = s40.splitHorizontally(count: 16)
        }
        let maxIcon = (tables.FB.max() ?? 28) + 1
        if let s39 = GameSprite(resId: 39, assets: assets) {
            commandIcons = s39.splitHorizontally(count: maxIcon)
        }
        if let s53 = GameSprite(resId: 53, assets: assets) {
            let sliced = s53.splitHorizontally(count: 5)
            resourcePips = [nil] + sliced.dropFirst().map { Optional($0) }
        }
        homeCityBanner = GameSprite(resId: 49, assets: assets)
        cursorBracketLeft = GameSprite(resId: 47, assets: assets)
        if let s48 = GameSprite(resId: 48, assets: assets) {
            cursorArrows = s48.splitHorizontally(count: 2)
        }
        hudTopCorner = GameSprite(resId: 50, assets: assets)
        if let s51 = GameSprite(resId: 51, assets: assets) {
            hudEdgeLine = s51.splitHorizontally(count: 1)
        }
        hpBarPieces = [
            GameSprite.solidColor(width: 12, height: 2, rgb: 0x000000),
            GameSprite.solidColor(width: 12, height: 2, rgb: 0xFF0000),
            GameSprite.solidColor(width: 12, height: 2, rgb: 0xFFFF00)
        ]

        // Load 24 sprite packs per e.p()
        let pal2: [Int] = [36, -1]
        let pal5: [Int] = [36, -1, 34, 35, -1]
        for slot in 0..<min(24, tables.bII.count) {
            let resId = tables.bII[slot].first(where: { $0 != -1 }) ?? -1
            let pals: [Int]?
            if slot == 4 || slot == 5 {
                pals = pal2
            } else if slot == 12 {
                pals = pal5
            } else if slot < 14 {
                pals = pal2
            } else {
                pals = nil
            }
            spritePacks[slot] = SpritePackLoader.load(resId: resId, paletteResIds: pals, durationLookup: tables.lS, assets: assets)
        }
    }

    // MARK: - Match Initialization

    // Port of e.<init>() + e.c(mapId) + e.b()
    public func startCampaign(mission: Int, difficulty: Int = 1) {
        ensureGraphicsLoaded()
        self.isCampaign = true
        self.campaignMission = max(0, min(mission, tables.NB.count - 1))
        self.difficulty = difficulty
        self.commandUnlockMask = campaignMission < tables.hI.count ? tables.hI[campaignMission] : 0x7FFF_FFFF
        self.playerSlotsMap = nil
        let mapIndex = tables.NB[self.campaignMission]
        setupMatchCommon(mapIndex: mapIndex)

        // Show initial mission briefing/objective
        if !tables.cSS.isEmpty {
            let header = localization.format(19, ["\(campaignMission + 1)"])
            showPopup("\(header)")
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
        // Skirmish maps live at e.i[10..13] -> 8..11.res (ARCHITECTURE-MAP)
        let mapIndex = min(tables.iI.count - 1, 10 + clampedChoice)
        self.playerSlotsMap = [0, 1]
        setupMatchCommon(mapIndex: mapIndex)
        objectiveText = localization.text(4)
    }

    private func setupMatchCommon(mapIndex: Int) {
        entities.removeAll()
        nextEntityId = 1
        outcome = .playing
        tickCount = 0
        killsCount = 0
        firedTriggers.removeAll()
        selectedEntity = nil
        buildPlacementCmd = nil
        rallyModeActive = false
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

        // Mark map resource nodes into fogGrid bit 4 so pathfinder navigates cleanly around dense mines/forests if needed
        for r in 0..<map.rows {
            for c in 0..<map.cols {
                let code = map.terrain[r * map.cols + c]
                if GameMap.isResourceTerrain(code, tables: tables) {
                    // Resource nodes remain walkable adjacent, mark bit 8 as resource marker
                    map.fogGrid[r * map.cols + c] |= 8
                }
            }
        }

        // Spawn group 0 (starting Town Centers & Settlers) and on Skirmish/initial setup group 1 if present in campaign
        spawnGroup(0)
        if !isCampaign {
            for g in 1..<map.spawnGroups.count {
                // Only spawn initial neutral defenses if small skirmish
                if map.spawnGroups[g].count <= 12 {
                    // Leave skirmish clean; group 0 holds TCs & initial settlers
                }
            }
        } else if map.spawnGroups.count > 1 && campaignMission == 0 {
            spawnGroup(1)
        }

        // Fallback ensure Player has at least a unit/building & cursor starts over player's TC
        let playerTC = entities.first(where: { $0.owner == 0 && $0.kind == .building })
            ?? entities.first(where: { $0.owner == 0 })
        if let anchor = playerTC {
            cursorEntity = Entity(kind: .cursor, id: 0)
            cursorEntity.tileRow = anchor.tileRow
            cursorEntity.tileCol = anchor.tileCol
            cursorEntity.xFixed = anchor.xFixed
            cursorEntity.yFixed = anchor.yFixed
            selectedEntity = anchor
            anchor.selected = true
            centerCamera(onWorldX: anchor.xFixed >> 8, worldY: anchor.yFixed >> 8)
            revealFog(centerRow: anchor.tileRow, centerCol: anchor.tileCol, radius: 6)
        } else {
            centerCamera(onWorldX: (map.rows / 2) * GameMap.tileLogicSize, worldY: (map.cols / 2) * GameMap.tileLogicSize)
        }

        // Setup AI controller(s) for active non-player teams
        let aiOwners = Set(entities.filter { $0.owner > 0 }.map { $0.owner })
        aiControllers = (aiOwners.isEmpty ? [1] : Array(aiOwners).sorted()).map { AIController(ownerId: $0) }

        recomputePopulations()
        rebuildCommandList()
    }

    // Port of e.d(int groupIndex) (e.javap.txt:2452)
    public func spawnGroup(_ groupIndex: Int) {
        guard groupIndex >= 0, groupIndex < map.spawnGroups.count else { return }
        for (rawCode, row, col) in map.spawnGroups[groupIndex] {
            var ownerRaw = rawCode / 16
            if let vMap = playerSlotsMap {
                if let mapped = vMap.firstIndex(of: ownerRaw) {
                    ownerRaw = mapped
                } else {
                    continue
                }
            }
            if ownerRaw == 2 { ownerRaw = 0 }
            let cmd = rawCode % 16
            guard cmd >= 0, cmd < tables.rB.count else { continue }
            if tables.rB[cmd] == 1 {
                // Building (cmd 0..7 -> buildingType 1..8)
                let bld = Entity.makeBuilding(id: nextEntityId, owner: ownerRaw, buildingType: cmd + 1, row: row, col: col, constructed: true, engine: self)
                nextEntityId += 1
                stampBuildingFootprint(bld, occupy: true)
                entities.append(bld)
                if ownerRaw == 0 {
                    revealFog(centerRow: row, centerCol: col, radius: bld.sightRangeTiles(tables: tables))
                }
            } else if cmd >= 8 && cmd <= 15 {
                let uType = cmd - 8
                let unit = Entity.makeUnit(id: nextEntityId, owner: ownerRaw, unitType: uType, row: row, col: col, engine: self)
                nextEntityId += 1
                entities.append(unit)
                if ownerRaw == 0 {
                    revealFog(centerRow: row, centerCol: col, radius: unit.sightRangeTiles(tables: tables))
                }
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
                    if tileVal >= 0 {
                        map.terrain[cell] = tileVal
                    }
                } else {
                    map.fogGrid[cell] &= ~4
                }
            }
            idx += 3
        }
    }

    // MARK: - Per-Tick Simulation

    // Port of e.f()
    public func updateTick() {
        guard outcome == .playing else { return }
        tickCount += 1

        if activeMessageTimer > 0 {
            activeMessageTimer -= 1
            if activeMessageTimer == 0 { activeMessage = nil }
        }

        // Recharge Home City XP passively over time
        if !homeCityShipmentReady {
            homeCityXP += 1
            if homeCityXP >= 240 {
                homeCityShipmentReady = true
                homeCityXP = 240
            }
        }

        for ai in aiControllers {
            ai.updateTick(engine: self)
        }

        for ent in entities where ent.active {
            ent.updateTick(engine: self)
        }
        entities.removeAll { !$0.active }

        if isCampaign {
            evaluateCampaignTriggers()
        } else {
            evaluateSkirmishVictory()
        }

        recomputePopulations()
    }

    private func evaluateSkirmishVictory() {
        let playerAlive = entities.contains { $0.active && $0.owner == 0 && ($0.kind == .building || $0.kind == .unit) }
        let aiAlive = entities.contains { $0.active && $0.owner > 0 && ($0.kind == .building || $0.kind == .unit) }
        if !playerAlive {
            outcome = .defeat
        } else if !aiAlive {
            outcome = .victory
        }
    }

    // Port of e.b() trigger evaluator over tables.aSSS[campaignMission]
    private func evaluateCampaignTriggers() {
        let playerAlive = entities.contains { $0.active && $0.owner == 0 && ($0.kind == .building || $0.kind == .unit) }
        if !playerAlive {
            outcome = .defeat
            return
        }
        guard campaignMission >= 0, campaignMission < tables.aSSS.count else { return }
        let trigs = tables.aSSS[campaignMission]
        for (idx, trig) in trigs.enumerated() where !firedTriggers.contains(idx) && !trig.isEmpty {
            let op = trig[0]
            switch op {
            case 1:
                // Delayed group spawn / trigger at tick threshold (trig[1] ticks or condition)
                if tickCount >= 60 + idx * 45 {
                    firedTriggers.insert(idx)
                    if trig.count > 1 && trig[1] >= 0 && trig[1] < map.spawnGroups.count {
                        spawnGroup(trig[1])
                    }
                }
            case 2:
                // Story popup dialog (trig[2] = localization string ID)
                if tickCount >= 10 + idx * 20 {
                    firedTriggers.insert(idx)
                    if trig.count >= 3 && trig[2] > 0 {
                        showPopup(localization.text(trig[2]))
                    }
                }
            case 3, 4:
                // Spawn reinforcement / enemy group
                if trig.count > 1 && tickCount >= 140 + idx * 90 {
                    firedTriggers.insert(idx)
                    if trig[1] >= 0 && trig[1] < map.spawnGroups.count {
                        spawnGroup(trig[1])
                    }
                }
            default:
                break
            }
        }
        // Standard mission completion check: all hostiles eliminated
        let enemyAlive = entities.contains { $0.active && $0.owner > 0 && ($0.kind == .building || $0.kind == .unit) }
        if !enemyAlive {
            outcome = .victory
        }
    }

    // MARK: - Commands, Economy & Combat Events

    public func isCommandUnlocked(_ cmd: Int) -> Bool {
        if cmd < 0 || cmd >= 31 { return true }
        return (commandUnlockMask & (1 << cmd)) != 0
    }

    public func canAfford(owner: Int, commandId: Int) -> Bool {
        guard commandId >= 0, commandId < tables.aSS.count, tables.aSS[commandId].count >= 3 else {
            return true
        }
        let c = tables.aSS[commandId]
        return playerResources[owner][0] >= c[0]
            && playerResources[owner][1] >= c[1]
            && playerResources[owner][2] >= c[2]
    }

    public func spendCost(owner: Int, commandId: Int) -> Bool {
        guard canAfford(owner: owner, commandId: commandId),
              commandId >= 0, commandId < tables.aSS.count, tables.aSS[commandId].count >= 3 else {
            return false
        }
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

        // Cancel/Demolish (22)
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

        // Rally / Home City (23)
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

        // Market instant barter trades (18..21)
        if commandId >= 18 && commandId <= 21 {
            guard spendCost(owner: owner, commandId: commandId) else { return false }
            switch commandId {
            case 18: playerResources[owner][2] += 75  // Sell 100 Food -> +75 Gold
            case 19: playerResources[owner][2] += 75  // Sell 100 Wood -> +75 Gold
            case 20: playerResources[owner][0] += 100 // Buy 100 Food
            case 21: playerResources[owner][1] += 100 // Buy 100 Wood
            default: break
            }
            return true
        }

        // Check pop cap before training units (8..15)
        if commandId >= 8 && commandId <= 15 {
            if playerPopUsed[owner] >= playerPopCap[owner] {
                if owner == 0 { showPopup(localization.text(135)) }
                return false
            }
        }

        // Age requirements
        if commandId == 16 && playerAges[owner] >= 1 { return false }
        if commandId == 17 && playerAges[owner] >= 2 { return false }

        guard spendCost(owner: owner, commandId: commandId) else { return false }

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
            let spawnPos = Pathfinder.findNearestWalkableTile(map: map, tables: tables, nearRow: building.tileRow + 1, nearCol: building.tileCol + 1, maxRadius: 4)
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
            // Military tier upgrade (Veteran/Guard/Imperial)
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
        if let spot = Pathfinder.findNearestWalkableTile(map: map, tables: tables, nearRow: tc.tileRow + 1, nearCol: tc.tileCol + 1, maxRadius: 4) {
            let u = Entity.makeUnit(id: nextEntityId, owner: 0, unitType: 2, row: spot.0, col: spot.1, engine: self)
            nextEntityId += 1
            entities.append(u)
        }
        showPopup(localization.text(134))
    }

    @discardableResult
    public func placeBuildingForOwner(owner: Int, buildingType: Int, row: Int, col: Int, constructedImmediately: Bool) -> Bool {
        let buildCmd = buildingType - 1
        guard map.isTileWalkable(row: row, col: col, tables: tables) else {
            if owner == 0 { showPopup(localization.text(140)) }
            return false
        }
        guard spendCost(owner: owner, commandId: buildCmd) else { return false }
        let bld = Entity.makeBuilding(id: nextEntityId, owner: owner, buildingType: buildingType, row: row, col: col, constructed: constructedImmediately, engine: self)
        nextEntityId += 1
        stampBuildingFootprint(bld, occupy: true)
        entities.append(bld)
        if owner == 0 {
            revealFog(centerRow: row, centerCol: col, radius: bld.sightRangeTiles(tables: tables))
        }
        // Assign nearby allied settlers to help construct
        if !constructedImmediately {
            for ent in entities where ent.owner == owner && ent.kind == .unit && ent.unitType == 0 && !ent.flags[4] {
                ent.flags[4] = true
                ent.flags[2] = false
                ent.refs[1] = bld
                break
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
        if victim.kind == .building {
            stampBuildingFootprint(victim, occupy: false)
        }
        if killerOwner == 0 {
            killsCount += 1
            homeCityXP = min(240, homeCityXP + 20)
        }
        let fx = Entity.makeFX(id: nextEntityId, fxType: 20, worldXFixed: victim.xFixed, worldYFixed: victim.yFixed, engine: self)
        nextEntityId += 1
        entities.append(fx)
        if selectedEntity === victim {
            selectedEntity = nil
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
        // Demote previous currently-visible bit (2) if desired; keep explored (1) + currently visible (2)
        for dr in -radius...radius {
            for dc in -radius...radius where (dr * dr + dc * dc) <= (radius * radius + 1) {
                let rr = centerRow + dr
                let cc = centerCol + dc
                if map.isInBounds(row: rr, col: cc) {
                    map.fogGrid[rr * map.cols + cc] |= 3
                }
            }
        }
    }

    public func findNearestHostile(fromRow: Int, col: Int, myOwner: Int, maxTileDist: Int) -> Entity? {
        var best: Entity?
        var bestDist = Int.max
        for ent in entities where ent.active && ent.hp > 0 && ent.owner != myOwner && (ent.kind == .unit || ent.kind == .building) {
            let d = GameMap.tileDistance(r0: fromRow, c0: col, r1: ent.tileRow, c1: ent.tileCol)
            if d <= maxTileDist && d < bestDist {
                bestDist = d
                best = ent
            }
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
                guard map.isInBounds(row: rr, col: cc) else { continue }
                let code = map.terrainAt(row: rr, col: cc)
                let rt = GameTables.pairLookup(tables.vB, key: code)
                if rt >= 0 {
                    if let targetRT = resourceType, targetRT != rt { continue }
                    let d = abs(dr) + abs(dc)
                    if d < bestDist {
                        bestDist = d
                        best = (rr, cc, rt)
                    }
                }
            }
        }
        return best
    }

    // MARK: - Controls & Commands

    public func centerCamera(onWorldX wx: Int, worldY wy: Int) {
        let iso = GameMap.worldToIso(worldX: wx, worldY: wy)
        cameraIsoX = iso.0 - XSMaxLayout.gameLogicalWidth / 2
        cameraIsoY = iso.1 - 190
    }

    public func moveCursor(dRow: Int, dCol: Int) {
        let nr = max(0, min(map.rows - 1, cursorEntity.tileRow + dRow))
        let nc = max(0, min(map.cols - 1, cursorEntity.tileCol + dCol))
        cursorEntity.tileRow = nr
        cursorEntity.tileCol = nc
        cursorEntity.xFixed = (nr * GameMap.tileLogicSize) << 8
        cursorEntity.yFixed = (nc * GameMap.tileLogicSize) << 8
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
        if sy < 56 { cameraIsoY -= (56 - sy) }
        else if sy > 300 { cameraIsoY += (sy - 300) }
    }

    public func handleKeyPress(_ keyMask: Int) {
        // Directions mapped to cursor tile movement (isometric diamond intuition)
        if (keyMask & KeyBits.up) != 0 { moveCursor(dRow: -1, dCol: -1) }
        if (keyMask & KeyBits.down) != 0 { moveCursor(dRow: 1, dCol: 1) }
        if (keyMask & KeyBits.left) != 0 { moveCursor(dRow: -1, dCol: 1) }
        if (keyMask & KeyBits.right) != 0 { moveCursor(dRow: 1, dCol: -1) }

        if (keyMask & KeyBits.num1) != 0 {
            if !activeCommandList.isEmpty {
                selectedCmdIndex = (selectedCmdIndex - 1 + activeCommandList.count) % activeCommandList.count
            }
        }
        if (keyMask & KeyBits.num3) != 0 {
            if !activeCommandList.isEmpty {
                selectedCmdIndex = (selectedCmdIndex + 1) % activeCommandList.count
            }
        }
        if (keyMask & KeyBits.num7) != 0 {
            cyclePlayerUnit(militaryOnly: false)
        }
        if (keyMask & KeyBits.num9) != 0 {
            cyclePlayerUnit(militaryOnly: true)
        }
        if (keyMask & KeyBits.star) != 0 {
            if let tc = entities.first(where: { $0.owner == 0 && $0.kind == .building && $0.buildingType == 1 }) {
                selectEntity(tc)
                setCursor(row: tc.tileRow, col: tc.tileCol)
                centerCamera(onWorldX: tc.xFixed >> 8, worldY: tc.yFixed >> 8)
            }
        }
        if (keyMask & KeyBits.pound) != 0 {
            minimapVisible.toggle()
        }
        if (keyMask & KeyBits.num0) != 0 {
            triggerActiveCommand()
        }
        if (keyMask & KeyBits.fire) != 0 {
            activateCursorAtTile()
        }
    }

    public func handleCanvasTap(screenX: Int, screenY: Int) {
        // Bottom command HUD bar hit test (y: 336..<384)
        if screenY >= 336 && screenY <= 384 && !activeCommandList.isEmpty {
            let cellW = 24
            let startX = max(8, (XSMaxLayout.gameLogicalWidth - activeCommandList.count * cellW) / 2)
            let rel = screenX - startX
            if rel >= 0 {
                let idx = rel / cellW
                if idx < activeCommandList.count {
                    selectedCmdIndex = idx
                    triggerActiveCommand()
                    return
                }
            }
        }
        // Convert screen pixel back to world logic & tile
        let isoX = screenX + cameraIsoX
        let isoY = screenY + cameraIsoY
        let (wx, wy) = GameMap.isoToWorld(isoX: isoX, isoY: isoY)
        let tileR = max(0, min(map.rows - 1, wx / GameMap.tileLogicSize))
        let tileC = max(0, min(map.cols - 1, wy / GameMap.tileLogicSize))
        setCursor(row: tileR, col: tileC)
        activateCursorAtTile()
    }

    public func activateCursorAtTile() {
        let r = cursorEntity.tileRow
        let c = cursorEntity.tileCol

        // 1. Building placement mode active
        if let cmd = buildPlacementCmd {
            let bType = cmd + 1
            if placeBuildingForOwner(owner: 0, buildingType: bType, row: r, col: c, constructedImmediately: false) {
                buildPlacementCmd = nil
            } else {
                showPopup(localization.text(canAfford(owner: 0, commandId: cmd) ? 140 : 133))
            }
            return
        }

        // 2. Check entity at tile
        if let target = entityAtTile(row: r, col: c) {
            if target.owner == 0 {
                selectEntity(target)
                return
            } else if let sel = selectedEntity, sel.owner == 0, sel.kind == .unit {
                // Attack hostile!
                sel.refs[0] = target
                sel.flags[2] = false
                sel.flags[4] = false
                if let path = Pathfinder.findPath(map: map, tables: tables, startRow: sel.tileRow, startCol: sel.tileCol, goalRow: target.tileRow, goalCol: target.tileCol) {
                    sel.intArrays[1] = path
                    sel.flags[1] = true
                }
                return
            }
        }

        // 3. Gather or Move command for currently selected Player unit(s)
        if let sel = selectedEntity, sel.owner == 0, sel.kind == .unit {
            let terrainCode = map.terrainAt(row: r, col: c)
            let resType = GameTables.pairLookup(tables.vB, key: terrainCode)
            if sel.unitType == 0 && resType >= 0 {
                sel.bytes[15] = r
                sel.bytes[16] = c
                sel.bytes[6] = resType
                sel.flags[2] = true
                sel.flags[4] = false
                sel.refs[0] = nil
                return
            }
            sel.refs[0] = nil
            sel.flags[2] = false
            sel.flags[4] = false
            if let path = Pathfinder.findPath(map: map, tables: tables, startRow: sel.tileRow, startCol: sel.tileCol, goalRow: r, goalCol: c) {
                sel.intArrays[1] = path
                sel.flags[1] = true
            }
        }
    }

    public func triggerActiveCommand() {
        guard selectedCmdIndex >= 0, selectedCmdIndex < activeCommandList.count else { return }
        let cmd = activeCommandList[selectedCmdIndex]
        if let sel = selectedEntity, sel.owner == 0 {
            if sel.kind == .unit && sel.unitType == 0 && cmd >= 0 && cmd <= 7 {
                // Settler enters building placement mode
                if canAfford(owner: 0, commandId: cmd) {
                    buildPlacementCmd = cmd
                    showPopup(commandName(cmd))
                } else {
                    showPopup(localization.text(133))
                }
            } else if sel.kind == .building {
                _ = issueBuildingCommand(sel, commandId: cmd)
            }
        }
    }

    private func selectEntity(_ ent: Entity) {
        selectedEntity?.selected = false
        selectedEntity = ent
        ent.selected = true
        buildPlacementCmd = nil
        demolishArmedBuildingId = nil
        selectedCmdIndex = 0
        rebuildCommandList()
    }

    private func cyclePlayerUnit(militaryOnly: Bool) {
        let candidates = entities.filter {
            $0.active && $0.owner == 0 && $0.kind == .unit && (!militaryOnly || $0.unitType > 0)
        }
        guard !candidates.isEmpty else { return }
        if let cur = selectedEntity, let idx = candidates.firstIndex(where: { $0 === cur }) {
            let next = candidates[(idx + 1) % candidates.count]
            selectEntity(next)
            setCursor(row: next.tileRow, col: next.tileCol)
            ensureCursorInCameraView()
        } else {
            let first = candidates[0]
            selectEntity(first)
            setCursor(row: first.tileRow, col: first.tileCol)
            ensureCursorInCameraView()
        }
    }

    private func entityAtTile(row: Int, col: Int) -> Entity? {
        if let unit = entities.first(where: { $0.active && $0.kind == .unit && $0.tileRow == row && $0.tileCol == col }) {
            return unit
        }
        if let bld = entities.first(where: {
            $0.active && $0.kind == .building && abs($0.tileRow - row) <= 1 && abs($0.tileCol - col) <= 1
        }) {
            return bld
        }
        return nil
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
        if cmd >= 0 && cmd <= 7 {
            return localization.text(174 + cmd)
        } else if cmd >= 8 && cmd <= 15 {
            let ut = cmd - 8
            if ut < tables.cSS.count, let sid = tables.cSS[ut].first {
                return localization.text(sid)
            }
        } else if cmd == 16 { return localization.text(185) }
        else if cmd == 17 { return localization.text(186) }
        else if cmd == 18 { return localization.text(188) }
        else if cmd == 19 { return localization.text(189) }
        else if cmd == 20 { return localization.text(190) }
        else if cmd == 21 { return localization.text(191) }
        else if cmd == 22 { return localization.text(192) }
        else if cmd == 23 { return localization.text(194) }
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
            self.selectedEntity = self.entities.first(where: { $0.selected }) ?? self.entities.first(where: { $0.owner == 0 })
            recomputePopulations()
            rebuildCommandList()
            outcome = .playing
            return true
        } catch {
            return false
        }
    }

    // MARK: - Isometric Software Renderer (Port of e.a(Graphics) & e.b(Graphics))

    public func render(to g: SoftwareRenderer) {
        g.setColor(0x0B0F0A)
        g.fillRect(0, 0, XSMaxLayout.gameLogicalWidth, XSMaxLayout.gameLogicalHeight)

        // 1. Render isometric terrain + props + shroud
        for row in 0..<map.rows {
            for col in 0..<map.cols {
                let idx = row * map.cols + col
                let fog = map.fogGrid[idx]
                let code = map.terrain[idx]
                let wx = row * GameMap.tileLogicSize
                let wy = col * GameMap.tileLogicSize
                let iso = GameMap.worldToIso(worldX: wx, worldY: wy)
                let sx = iso.0 - cameraIsoX - (GameMap.tilePixelW / 2)
                let sy = iso.1 - cameraIsoY

                // Quick viewport cull
                if sx < -40 || sx > XSMaxLayout.gameLogicalWidth + 40 || sy < -64 || sy > 360 { continue }

                if (fog & 1) == 0 {
                    // Unexplored shroud diamond
                    g.setColor(0x050605)
                    g.fillTriangle(sx + 16, sy, sx + 32, sy + 8, sx + 16, sy + 16)
                    g.fillTriangle(sx + 16, sy, sx, sy + 8, sx + 16, sy + 16)
                    continue
                }

                // Draw base terrain or prop tile from tables.PB lookup (e.a(int, bool))
                let pairBase = code * 2
                if pairBase >= 0 && pairBase + 1 < tables.PB.count {
                    let rawSlice = tables.PB[pairBase]
                    let trans = tables.PB[pairBase + 1]
                    if rawSlice < 100 && rawSlice < terrainTiles.count {
                        g.drawSprite(terrainTiles[rawSlice], x: sx, y: sy, transform: trans)
                    } else if rawSlice >= 100 {
                        // Draw underlying grass base 0 first, then prop sprite anchored upward!
                        if !terrainTiles.isEmpty {
                            g.drawSprite(terrainTiles[0], x: sx, y: sy)
                        }
                        let propIdx = rawSlice - 100
                        if propIdx < propTiles.count {
                            let sp = propTiles[propIdx]
                            g.drawSprite(sp, x: sx, y: sy + GameMap.tilePixelH - sp.height, transform: trans)
                        }
                    }
                } else if !terrainTiles.isEmpty {
                    g.drawSprite(terrainTiles[0], x: sx, y: sy)
                }
            }
        }

        // 2. Depth-sorted Entities (units, buildings HUD bars, FX, floating text)
        let sorted = entities.filter { $0.active }.sorted { ($0.xFixed + $0.yFixed) < ($1.xFixed + $1.yFixed) }
        for ent in sorted {
            let wx = (ent.xFixed >> 8) + GameMap.tileHalfLogic
            let wy = (ent.yFixed >> 8) + GameMap.tileHalfLogic
            let iso = GameMap.worldToIso(worldX: wx, worldY: wy)
            let sx = iso.0 - cameraIsoX
            let sy = iso.1 - cameraIsoY
            if sx < -48 || sx > XSMaxLayout.gameLogicalWidth + 48 || sy < -64 || sy > 370 { continue }

            switch ent.kind {
            case .floatingText:
                g.setColor(0xFFFF00)
                g.drawString(fontId: 1, "+\(ent.ints[3])", x: sx, y: sy - 10, anchor: Anchor.hcenter | Anchor.bottom)
            case .fx:
                drawEntitySprite(ent, sx: sx, sy: sy, g: g)
            case .building:
                if ent.selected || ent.hp < ent.maxHP(engine: self) || ent.state == 0 {
                    drawHealthBar(hp: ent.hp, maxHP: ent.maxHP(engine: self), owner: ent.owner, x: sx - 10, y: sy - 24, g: g)
                }
                if ent.selected {
                    g.setColor(0x00FF66)
                    g.drawRect(sx - 18, sy - 18, 36, 22)
                }
            case .unit:
                if ent.selected {
                    g.setColor(ent.owner == 0 ? 0x00FF00 : 0xFF3333)
                    g.drawLine(sx - 10, sy + 2, sx, sy - 3)
                    g.drawLine(sx, sy - 3, sx + 10, sy + 2)
                    g.drawLine(sx + 10, sy + 2, sx, sy + 7)
                    g.drawLine(sx, sy + 7, sx - 10, sy + 2)
                }
                drawEntitySprite(ent, sx: sx, sy: sy, g: g)
                if ent.selected || ent.hp < ent.maxHP(engine: self) {
                    drawHealthBar(hp: ent.hp, maxHP: ent.maxHP(engine: self), owner: ent.owner, x: sx - 6, y: sy - 22, g: g)
                }
            case .cursor:
                break
            }
        }

        // 3. Draw Cursor diamond + build footprint preview
        let cWX = cursorEntity.tileRow * GameMap.tileLogicSize + GameMap.tileHalfLogic
        let cWY = cursorEntity.tileCol * GameMap.tileLogicSize + GameMap.tileHalfLogic
        let cIso = GameMap.worldToIso(worldX: cWX, worldY: cWY)
        let cx = cIso.0 - cameraIsoX
        let cy = cIso.1 - cameraIsoY
        g.setColor(buildPlacementCmd != nil ? 0x00FFFF : 0xFFDD44)
        g.drawLine(cx - 16, cy, cx, cy - 8)
        g.drawLine(cx, cy - 8, cx + 16, cy)
        g.drawLine(cx + 16, cy, cx, cy + 8)
        g.drawLine(cx, cy + 8, cx - 16, cy)

        // 4. Optional Minimap (# key)
        if minimapVisible {
            drawMinimap(g: g)
        }

        // 5. HUD Top Bar & Bottom Command Strip
        drawHUD(g: g)
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
        let variantIdx = max(0, min(ent.owner, pack.variantSprites.count - 1))
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
        let my = 26
        g.setColor(0x111611)
        g.fillRect(mx - 2, my - 2, mmW + 4, mmH + 4)
        g.setColor(0x8E7441)
        g.drawRect(mx - 2, my - 2, mmW + 4, mmH + 4)
        for r in 0..<map.rows {
            for c in 0..<map.cols {
                let fog = map.fogGrid[r * map.cols + c]
                if (fog & 1) == 0 {
                    g.setColor(0x000000)
                } else if (fog & 8) != 0 {
                    g.setColor(0x226622)
                } else {
                    g.setColor(0x4E683B)
                }
                g.fillRect(mx + c * 2, my + r * 2, 2, 2)
            }
        }
        for ent in entities where ent.active && (ent.kind == .unit || ent.kind == .building) {
            g.setColor(ent.owner == 0 ? 0x44AAFF : 0xFF3333)
            g.fillRect(mx + ent.tileCol * 2, my + ent.tileRow * 2, 2, 2)
        }
    }

    private func drawHUD(g: SoftwareRenderer) {
        // Top Resource & Pop Bar (y = 0..22)
        g.setColor(0x1B140C)
        g.fillRect(0, 0, XSMaxLayout.gameLogicalWidth, 22)
        g.setColor(0x9E7D44)
        g.drawLine(0, 22, XSMaxLayout.gameLogicalWidth, 22)

        let res = playerResources[0]
        g.drawString(fontId: 1, "F:\(res[0])", x: 10, y: 3, anchor: Anchor.top | Anchor.left)
        g.drawString(fontId: 1, "W:\(res[1])", x: 92, y: 3, anchor: Anchor.top | Anchor.left)
        g.drawString(fontId: 1, "G:\(res[2])", x: 174, y: 3, anchor: Anchor.top | Anchor.left)
        g.drawString(fontId: 1, "\(playerPopUsed[0])/\(playerPopCap[0])", x: 256, y: 3, anchor: Anchor.top | Anchor.left)
        g.drawString(fontId: 1, "Age\(playerAges[0] + 1)", x: 352, y: 3, anchor: Anchor.top | Anchor.right)

        // Popup toast message
        if let msg = activeMessage {
            g.setColor(0x22180D)
            g.fillRect(16, 28, XSMaxLayout.gameLogicalWidth - 32, 24)
            g.setColor(0xB8914E)
            g.drawRect(16, 28, XSMaxLayout.gameLogicalWidth - 32, 24)
            g.drawString(fontId: 1, msg, x: 180, y: 33, anchor: Anchor.top | Anchor.hcenter)
        }

        // Bottom HUD Command Strip (y = 336..400)
        g.setColor(0x1A130B)
        g.fillRect(0, 336, XSMaxLayout.gameLogicalWidth, 64)
        g.setColor(0x8E7441)
        g.drawLine(0, 336, XSMaxLayout.gameLogicalWidth, 336)

        if !activeCommandList.isEmpty {
            let cellW = 24
            let startX = max(8, (XSMaxLayout.gameLogicalWidth - activeCommandList.count * cellW) / 2)
            for (idx, cmd) in activeCommandList.enumerated() {
                let bx = startX + idx * cellW
                let by = 342
                if idx == selectedCmdIndex {
                    g.setColor(0xFFE066)
                    g.drawRect(bx - 1, by - 1, 20, 20)
                }
                if cmd >= 0 && cmd < tables.FB.count {
                    let iconIdx = tables.FB[cmd]
                    if iconIdx >= 0 && iconIdx < commandIcons.count {
                        g.drawSprite(commandIcons[iconIdx], x: bx, y: by)
                    }
                }
            }
            if selectedCmdIndex < activeCommandList.count {
                let cmd = activeCommandList[selectedCmdIndex]
                var label = commandName(cmd)
                if cmd < tables.aSS.count && tables.aSS[cmd].count >= 3 {
                    let c = tables.aSS[cmd]
                    if c[0] + c[1] + c[2] > 0 {
                        label += " (\(c[0])/\(c[1])/\(c[2]))"
                    }
                }
                g.drawString(fontId: 1, label, x: 180, y: 365, anchor: Anchor.top | Anchor.hcenter)
            }
        } else if let sel = selectedEntity {
            let label = sel.kind == .unit ? "Unit #\(sel.unitType + 1) HP:\(sel.hp)/\(sel.maxHP(engine: self))" : "Bld #\(sel.buildingType) HP:\(sel.hp)"
            g.drawString(fontId: 1, label, x: 180, y: 350, anchor: Anchor.top | Anchor.hcenter)
        }

        // LSK / RSK softkeys at (2, 399) and (358, 399)
        g.drawString(fontId: 1, localization.text(334), x: 6, y: 398, anchor: Anchor.bottom | Anchor.left)
        g.drawString(fontId: 1, localization.text(331), x: 354, y: 398, anchor: Anchor.bottom | Anchor.right)
    }
}
