// Port of j.java — Computer AI Controller (resource workers, build priorities, training, age-up, attack waves)
import Foundation

public final class AIController {
    public let ownerId: Int
    public var decisionCooldown: Int = 10
    public var attackWaveCooldown: Int = 180
    public var attackWaveSize: Int = 5

    public init(ownerId: Int) {
        self.ownerId = ownerId
    }

    // Port of j.a() periodic strategic tick
    public func updateTick(engine: GameEngine) {
        if decisionCooldown > 0 {
            decisionCooldown -= 1
            return
        }
        // Difficulty tunes AI tempo: Easy=40 ticks, Normal=22 ticks, Hard=12 ticks
        switch engine.difficulty {
        case 0: decisionCooldown = 40
        case 2: decisionCooldown = 12
        default: decisionCooldown = 22
        }

        let myBuildings = engine.entities.filter { $0.active && $0.kind == .building && $0.owner == ownerId }
        let myUnits = engine.entities.filter { $0.active && $0.kind == .unit && $0.owner == ownerId }
        let settlers = myUnits.filter { $0.unitType == 0 }
        let soldiers = myUnits.filter { $0.unitType > 0 }

        guard !myBuildings.isEmpty else { return }
        let townCenter = myBuildings.first(where: { $0.buildingType == 1 }) ?? myBuildings[0]

        // 1. Assign idle settlers to Food / Wood / Gold proportionally
        assignIdleSettlers(settlers: settlers, near: townCenter, engine: engine)

        // 2. Build House (cmd 1 -> buildingType 2) if near population cap
        if engine.playerPopUsed[ownerId] + 2 >= engine.playerPopCap[ownerId] && engine.playerPopCap[ownerId] < 40 {
            if engine.canAfford(owner: ownerId, commandId: 1) {
                tryPlaceBuilding(commandId: 1, near: townCenter, engine: engine)
            }
        }

        // 3. Construct core military production buildings (cmd -> buildingType = cmd + 1: Barracks=3->4, Stable=5->6, Foundry=4->5, Market=6->7)
        for bCmd in [3, 5, 4, 6] {
            let bType = bCmd + 1
            let hasBuilding = myBuildings.contains { $0.buildingType == bType }
            if !hasBuilding && engine.isCommandUnlocked(bCmd) && engine.canAfford(owner: ownerId, commandId: bCmd) {
                if tryPlaceBuilding(commandId: bCmd, near: townCenter, engine: engine) {
                    break
                }
            }
        }

        // 4. Advance Age if sufficient resources & Town Center idle
        if engine.playerAges[ownerId] == 0 && engine.canAfford(owner: ownerId, commandId: 16) {
            _ = engine.issueBuildingCommand(townCenter, commandId: 16)
        } else if engine.playerAges[ownerId] == 1 && engine.canAfford(owner: ownerId, commandId: 17) {
            _ = engine.issueBuildingCommand(townCenter, commandId: 17)
        }

        // 5. Train additional settlers up to 6
        if settlers.count < 6 && (townCenter.intArrays[0]?.isEmpty ?? true) && engine.canAfford(owner: ownerId, commandId: 8) {
            _ = engine.issueBuildingCommand(townCenter, commandId: 8)
        }

        // 6. Train balanced military units from Barracks / Stable / Foundry
        for bld in myBuildings where bld.state == 1 && (bld.intArrays[0]?.count ?? 0) < 2 {
            guard bld.buildingType >= 0, bld.buildingType < engine.tables.cBB.count else { continue }
            let cmds = engine.tables.cBB[bld.buildingType]
            for cmd in cmds where cmd >= 9 && cmd <= 15 {
                if engine.isCommandUnlocked(cmd) && engine.canAfford(owner: ownerId, commandId: cmd) {
                    if engine.issueBuildingCommand(bld, commandId: cmd) { break }
                }
            }
        }

        // 7. Launch coordinated attack waves against player
        if attackWaveCooldown > 0 {
            attackWaveCooldown -= 1
        }
        if attackWaveCooldown == 0 && soldiers.count >= attackWaveSize {
            if let playerTarget = engine.findNearestHostile(fromRow: townCenter.tileRow, col: townCenter.tileCol, myOwner: ownerId, maxTileDist: 100) {
                for unit in soldiers where unit.refs[0] == nil {
                    unit.refs[0] = playerTarget
                }
                attackWaveCooldown = engine.difficulty == 2 ? 120 : 200
                attackWaveSize = min(12, attackWaveSize + 1)
            }
        }
    }

    private func assignIdleSettlers(settlers: [Entity], near tc: Entity, engine: GameEngine) {
        for (idx, s) in settlers.enumerated() where !s.flags[1] && !s.flags[2] && !s.flags[4] {
            let targetResType = idx % 3 // cycle Food(0), Wood(1), Gold(2)
            if let node = engine.findNearestResourceTile(fromRow: tc.tileRow, fromCol: tc.tileCol, resourceType: targetResType, maxRadius: 16) {
                s.bytes[15] = node.0
                s.bytes[16] = node.1
                s.bytes[6] = targetResType
                s.flags[2] = true
            } else if let anyNode = engine.findNearestResourceTile(fromRow: tc.tileRow, fromCol: tc.tileCol, resourceType: nil, maxRadius: 16) {
                s.bytes[15] = anyNode.0
                s.bytes[16] = anyNode.1
                s.bytes[6] = anyNode.2
                s.flags[2] = true
            }
        }
    }

    @discardableResult
    private func tryPlaceBuilding(commandId: Int, near tc: Entity, engine: GameEngine) -> Bool {
        if let spot = Pathfinder.findNearestWalkableTile(map: engine.map, tables: engine.tables, nearRow: tc.tileRow + 2, nearCol: tc.tileCol + 2, maxRadius: 6) {
            return engine.placeBuildingForOwner(owner: ownerId, buildingType: commandId + 1, row: spot.0, col: spot.1, constructedImmediately: false)
        }
        return false
    }
}
