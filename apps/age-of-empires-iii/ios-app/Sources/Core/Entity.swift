// Port of b.java — Game Entities (Cursor=1, Unit=2, Building=3, FX=5, FloatingText=6)
// Includes combat, splash, 3x anti-class bonus, gathering, queues, animations, and binary serialization
import Foundation

public enum EntityKind: Int {
    case cursor = 1
    case unit = 2
    case building = 3
    case fx = 5
    case floatingText = 6
}

public final class Entity {
    // Core b.java fields
    public var id: Int = 0              // b.b: unique entity ID (assigned in GameEngine)
    public var kind: EntityKind         // b.d: 1, 2, 3, 5, 6
    public var state: Int = 0           // b.c: state (unit: 0 idle,1 move,2 work/attack,3 dead; building: 0 placing/constructing, 1 active, 2 dying; cursor: 0 free, 1 build placement)
    public var xFixed: Int = 0          // b.e: world X << 8 (48 << 8 per tile)
    public var yFixed: Int = 0          // b.f: world Y << 8
    public var vxFixed: Int = 0         // b.g: fixed velocity / offset
    public var vyFixed: Int = 0         // b.h: fixed velocity / offset
    public var tileRow: Int = 0         // b.i: grid row
    public var tileCol: Int = 0         // b.j: grid col
    public var active: Bool = true      // b.b: alive/active
    public var isVisible: Bool = true   // b.a: visibility flag

    // Sprite & animation fields (k, m, n, o, l, c)
    public var spriteSlot: Int = -1     // b.k: index into GameEngine.spritePacks (0..23)
    public var animSeq: Int = 0         // b.m: sequence index
    public var animFrame: Int = 0       // b.n: current frame index
    public var animTimer: Int = 0       // b.o: remaining ticks on frame
    public var zOrderBias: Int = 0      // b.l
    public var animLoops: Bool = true   // b.c

    // Fixed slots matching b.a:[B, b.a:[I, b.a:[[I, b.a:[Z, b.a:[Lb;
    // b.a:[B mapping:
    //   [0]=owner (0=Player,1=AI/Enemy,2=Ally/Neutral)
    //   [1]=hp/flag, [3]=age/construction progress, [4]=buildingType (if d==3) or fxType (d==5)
    //   [5]=facing 0..7, [6]=gatherResourceType, [7]=carryingQty, [8]=workerSlotIdx
    //   [10]=unitCategory, [11]=rally/aiRole, [12]=unitType (0..7)
    //   [14]=buildCommandId, [15]=targetRow, [16]=targetCol, [24]=attackCooldown, [25]=moveCooldown
    public var bytes: [Int]
    public var ints: [Int]              // [0]=HP, [1]=attackTargetX, [2]=attackTargetY, [3]=damage/carryCap, [4]=maxCarry/timer
    public var intArrays: [[Int]?]      // [0]=training queue flat [cmd, remTicks, ...], [1]=A* path waypoints
    public var flags: [Bool]            // [0]=selected, [1]=moving, [2]=gathering, [3]=returning, [4]=repairing/upgrading
    public var refs: [Entity?]          // [0]=targetEntity, [1]=homeBuilding, [2]=reserved

    public static let byteCount = 27
    public static let intCount = 6
    public static let flagCount = 5
    public static let refCount = 3

    public var owner: Int {
        get { bytes[0] }
        set { bytes[0] = newValue }
    }
    public var unitType: Int {
        get { bytes[12] }
        set { bytes[12] = newValue }
    }
    public var buildingType: Int {
        get { bytes[4] }
        set { bytes[4] = newValue }
    }
    public var facing: Int {
        get { bytes[5] }
        set { bytes[5] = ((newValue % 8) + 8) % 8 }
    }
    public var hp: Int {
        get { ints[0] }
        set { ints[0] = max(0, newValue) }
    }
    public var selected: Bool {
        get { flags[0] }
        set { flags[0] = newValue }
    }

    public init(kind: EntityKind, id: Int = 0) {
        self.id = id
        self.kind = kind
        self.bytes = [Int](repeating: 0, count: Self.byteCount)
        self.ints = [Int](repeating: 0, count: Self.intCount)
        self.intArrays = [nil, nil]
        self.flags = [Bool](repeating: false, count: Self.flagCount)
        self.refs = [Entity?](repeating: nil, count: Self.refCount)
        if kind == .building {
            intArrays[0] = []
        }
    }

    public static func makeUnit(id: Int, owner: Int, unitType: Int, row: Int, col: Int, engine: GameEngine) -> Entity {
        let e = Entity(kind: .unit, id: id)
        e.owner = owner
        e.unitType = unitType
        e.tileRow = row
        e.tileCol = col
        e.xFixed = (row * GameMap.tileLogicSize) << 8
        e.yFixed = (col * GameMap.tileLogicSize) << 8
        e.state = 0
        e.facing = 2
        e.ints[0] = e.maxHP(engine: engine)
        e.ints[3] = 0
        e.spriteSlot = e.unitSpriteSlot(tables: engine.tables)
        e.setAnimation(seq: e.animSeqForIdle(facing: e.facing), loop: true, engine: engine)
        return e
    }

    public static func makeBuilding(id: Int, owner: Int, buildingType: Int, row: Int, col: Int, constructed: Bool = true, engine: GameEngine) -> Entity {
        let e = Entity(kind: .building, id: id)
        e.owner = owner
        e.buildingType = buildingType // 1=TC, 2=House, 3=Outpost, 4=Barracks, 5=Foundry, 6=Stable, 7=Market, 8=Fort
        e.tileRow = row
        e.tileCol = col
        e.xFixed = (row * GameMap.tileLogicSize) << 8
        e.yFixed = (col * GameMap.tileLogicSize) << 8
        e.state = constructed ? 1 : 0
        let fullHP = e.maxHP(engine: engine)
        e.ints[0] = constructed ? fullHP : max(20, fullHP / 4)
        e.bytes[3] = constructed ? 0 : 100
        e.intArrays[0] = []
        e.spriteSlot = -1 // Buildings composite from 55.res prop tiles via tables.hBB[buildingType]
        e.animSeq = 0
        return e
    }

    public static func makeFloatingText(id: Int, row: Int, col: Int, amount: Int, resourceType: Int) -> Entity {
        let e = Entity(kind: .floatingText, id: id)
        e.tileRow = row
        e.tileCol = col
        e.xFixed = (row * GameMap.tileLogicSize) << 8
        e.yFixed = (col * GameMap.tileLogicSize) << 8
        e.ints[3] = amount
        e.bytes[6] = resourceType
        e.ints[4] = 28 // lifetime ticks
        return e
    }

    public static func makeFX(id: Int, fxType: Int, worldXFixed: Int, worldYFixed: Int, owner: Int = 0, damage: Int = 0, target: Entity? = nil, engine: GameEngine) -> Entity {
        let e = Entity(kind: .fx, id: id)
        e.owner = owner
        e.buildingType = fxType
        e.xFixed = worldXFixed
        e.yFixed = worldYFixed
        e.tileRow = (worldXFixed >> 8) / GameMap.tileLogicSize
        e.tileCol = (worldYFixed >> 8) / GameMap.tileLogicSize
        e.ints[3] = damage
        e.ints[4] = 16
        e.refs[0] = target
        e.spriteSlot = (fxType == 19) ? 19 : 20
        e.setAnimation(seq: 0, loop: false, engine: engine)
        return e
    }

    private func unitSpriteSlot(tables: GameTables) -> Int {
        // Port of e.n[unitType] (tables-33.json: [0, 2, 8, 10, 4, 6, 12, 12])
        if unitType >= 0 && unitType < tables.nB.count {
            return tables.nB[unitType]
        }
        return min(23, unitType * 2)
    }

    // Port of b.a(owner, unitType, isMax):I & b.b():I (b.javap.txt)
    public func upgradeTier(engine: GameEngine, maxOverride: Bool = false) -> Int {
        guard kind == .unit else { return 0 }
        let ownerIdx = max(0, min(owner, engine.playerTechTiers.count - 1))
        let cat = (unitType >= 0 && unitType < engine.tables.lB.count) ? engine.tables.lB[unitType] : 0
        if maxOverride { return 3 }
        guard cat >= 0, cat < engine.playerTechTiers[ownerIdx].count else { return 0 }
        return engine.playerTechTiers[ownerIdx][cat]
    }

    public func statMultiplierPercent(engine: GameEngine) -> Int {
        guard kind == .unit else { return 100 }
        let tier = upgradeTier(engine: engine)
        guard unitType >= 0, unitType < engine.tables.aBB.count,
              tier >= 0, tier < engine.tables.aBB[unitType].count else {
            return 100
        }
        let lvl = engine.tables.aBB[unitType][tier]
        return 100 + lvl * 10
    }

    // Port of b.b():I (max HP)
    public func maxHP(engine: GameEngine) -> Int {
        if kind == .unit {
            let base = (unitType >= 0 && unitType < engine.tables.cS.count) ? engine.tables.cS[unitType] : 100
            return (base * statMultiplierPercent(engine: engine)) / 100
        } else if kind == .building {
            let base = (buildingType >= 0 && buildingType < engine.tables.fS.count) ? engine.tables.fS[buildingType] : 1000
            return base
        }
        return 100
    }

    // Port of b.c():I attack damage
    public func baseAttackDamage(tables: GameTables) -> Int {
        if kind == .unit {
            return (unitType >= 0 && unitType < tables.dS.count) ? tables.dS[unitType] : 10
        }
        if kind == .building {
            // Outpost (3) and Fort (8) deal ranged defensive damage
            return buildingType == 8 ? 32 : (buildingType == 3 ? 18 : 0)
        }
        return 0
    }

    public func attackRangeTiles(tables: GameTables) -> Int {
        if kind == .unit {
            return (unitType >= 0 && unitType < tables.jB.count) ? max(1, tables.jB[unitType]) : 1
        }
        if kind == .building {
            return (buildingType == 3 || buildingType == 8) ? 5 : 0
        }
        return 1
    }

    public func sightRangeTiles(tables: GameTables) -> Int {
        if kind == .unit {
            return (unitType >= 0 && unitType < tables.hB.count) ? max(3, tables.hB[unitType]) : 4
        }
        if kind == .building {
            return (buildingType >= 0 && buildingType < tables.pB.count) ? max(3, tables.pB[buildingType]) : 5
        }
        return 3
    }

    public func moveSpeedFixed(tables: GameTables) -> Int {
        guard kind == .unit, unitType >= 0, unitType < tables.bS.count else { return 512 }
        return max(384, tables.bS[unitType])
    }

    // Port of b.a(b target, int bonusMode) & b.b(b attacker, int dmg)
    public func applyCombatDamage(from attacker: Entity, engine: GameEngine) {
        guard active, hp > 0 else { return }
        var dmg = max(1, attacker.baseAttackDamage(tables: engine.tables))
        dmg = (dmg * attacker.statMultiplierPercent(engine: engine)) / 100

        // Counter class 3x bonus (e.b:[[B)
        if attacker.kind == .unit && self.kind == .unit {
            let ut = attacker.unitType
            if ut >= 0, ut < engine.tables.bBB.count, let counters = engine.tables.bBB[ut] {
                let targetClass = (self.unitType >= 0 && self.unitType < engine.tables.mB.count) ? engine.tables.mB[self.unitType] : -1
                if counters.contains(targetClass) {
                    dmg *= 3
                }
            }
        }
        // Difficulty handicap on Player/AI in Skirmish
        if owner == 0 && engine.difficulty == 2 {
            dmg = (dmg * 115) / 100
        } else if owner == 0 && engine.difficulty == 0 {
            dmg = (dmg * 80) / 100
        }

        hp = max(0, hp - dmg)

        // Splash AoE (e.iB[unitType] > 0) for Grenadiers & Cannons
        if attacker.kind == .unit && attacker.unitType >= 0 && attacker.unitType < engine.tables.iB.count {
            let splash = engine.tables.iB[attacker.unitType]
            if splash > 0 {
                for other in engine.entities where other !== self && other.active && other.owner != attacker.owner && (other.kind == .unit || other.kind == .building) {
                    let dist = GameMap.tileDistance(r0: tileRow, c0: tileCol, r1: other.tileRow, c1: other.tileCol)
                    if dist <= splash {
                        other.hp = max(0, other.hp - max(1, dmg / 2))
                        if other.hp == 0 {
                            engine.handleEntityKilled(other, killerOwner: attacker.owner)
                        }
                    }
                }
            }
        }

        if hp == 0 {
            engine.handleEntityKilled(self, killerOwner: attacker.owner)
        }
    }

    // Port of b.f(seq, frame):V
    public func setAnimation(seq: Int, loop: Bool = true, engine: GameEngine) {
        self.animSeq = max(0, seq)
        self.animFrame = 0
        self.animLoops = loop
        if spriteSlot >= 0, let pack = engine.spritePacks[spriteSlot],
           animSeq < pack.seqDurations.count, !pack.seqDurations[animSeq].isEmpty {
            self.animTimer = max(1, pack.seqDurations[animSeq][0])
        } else {
            self.animTimer = 4
        }
    }

    private func animSeqForIdle(facing: Int) -> Int {
        return min(7, max(0, facing))
    }

    // Port of b.f() frame advance
    public func advanceAnimation(engine: GameEngine) {
        guard spriteSlot >= 0, let pack = engine.spritePacks[spriteSlot],
              animSeq < pack.seqFrames.count, !pack.seqFrames[animSeq].isEmpty else {
            return
        }
        animTimer -= 1
        if animTimer <= 0 {
            animFrame += 1
            if animFrame >= pack.seqFrames[animSeq].count {
                if animSeq < pack.loopFlags.count && pack.loopFlags[animSeq] == 1 && animLoops {
                    animFrame = 0
                } else {
                    animFrame = pack.seqFrames[animSeq].count - 1
                    animLoops = false
                }
            }
            if animSeq < pack.seqDurations.count && animFrame < pack.seqDurations[animSeq].count {
                animTimer = max(1, pack.seqDurations[animSeq][animFrame])
            } else {
                animTimer = 3
            }
        }
    }

    // Port of b.b(int queueSlot, int decTicks):V (production/research progress tick)
    public func tickProductionQueue(engine: GameEngine) {
        guard kind == .building, state == 1, var queue = intArrays[0], queue.count >= 2 else { return }
        if queue[1] > 1 {
            queue[1] -= 1
            intArrays[0] = queue
            return
        }
        // Item finished!
        let cmd = queue[0]
        queue.removeFirst(2)
        intArrays[0] = queue
        engine.completeBuildingOrder(building: self, commandId: cmd)
    }

    // Main per-tick update (Port of b.a() b.pseudo.java:600-950)
    public func updateTick(engine: GameEngine) {
        guard active else { return }

        switch kind {
        case .floatingText:
            yFixed -= 192
            ints[4] -= 1
            if ints[4] <= 0 { active = false }
            return
        case .fx:
            ints[4] -= 1
            advanceAnimation(engine: engine)
            if ints[4] <= 0 && !animLoops { active = false }
            return
        case .cursor:
            advanceAnimation(engine: engine)
            return
        case .building:
            advanceAnimation(engine: engine)
            if state == 0 {
                // Under construction progress by nearby allied settlers
                if bytes[3] > 0 { bytes[3] -= 1 }
                if bytes[3] == 0 {
                    state = 1
                    hp = maxHP(engine: engine)
                    engine.onBuildingCompleted(self)
                }
            } else if state == 1 {
                tickProductionQueue(engine: engine)
                if bytes[24] > 0 { bytes[24] -= 1 }
                // Defensive fire for Outpost (3) and Fort (8)
                if (buildingType == 3 || buildingType == 8) && bytes[24] == 0 {
                    let range = attackRangeTiles(tables: engine.tables)
                    if let target = engine.findNearestHostile(fromRow: tileRow, col: tileCol, myOwner: owner, maxTileDist: range) {
                        target.applyCombatDamage(from: self, engine: engine)
                        bytes[24] = 20
                    }
                }
            }
            return
        case .unit:
            break
        }

        if bytes[24] > 0 { bytes[24] -= 1 }
        advanceAnimation(engine: engine)

        // State machine for Unit: moving along A* path -> arriving -> attacking / gathering / building / idle
        if flags[1], let path = intArrays[1], path.count >= 2 {
            let nextR = path[0]
            let nextC = path[1]
            let destX = (nextR * GameMap.tileLogicSize) << 8
            let destY = (nextC * GameMap.tileLogicSize) << 8
            let dx = destX - xFixed
            let dy = destY - yFixed
            let speed = moveSpeedFixed(tables: engine.tables)
            let distSq = Int64(dx) * Int64(dx) + Int64(dy) * Int64(dy)

            facing = GameMap.direction8(fromX: xFixed, y0: yFixed, toX: destX, y1: destY)

            if distSq <= Int64(speed) * Int64(speed) {
                xFixed = destX
                yFixed = destY
                tileRow = nextR
                tileCol = nextC
                var updated = path
                updated.removeFirst(2)
                intArrays[1] = updated.isEmpty ? nil : updated
                if updated.isEmpty {
                    flags[1] = false
                }
                if owner == 0 {
                    engine.revealFog(centerRow: tileRow, centerCol: tileCol, radius: sightRangeTiles(tables: engine.tables))
                }
            } else {
                let d = sqrt(Double(distSq))
                xFixed += Int(Double(dx) * Double(speed) / d)
                yFixed += Int(Double(dy) * Double(speed) / d)
                tileRow = (xFixed >> 8) / GameMap.tileLogicSize
                tileCol = (yFixed >> 8) / GameMap.tileLogicSize
            }
            return
        }

        // Settler gathering / construction workflow
        if unitType == 0 && (flags[2] || flags[3] || flags[4]) {
            updateSettlerTask(engine: engine)
            return
        }

        // Combat target engagement
        if let target = refs[0], target.active, target.hp > 0, target.owner != owner {
            let range = attackRangeTiles(tables: engine.tables)
            let dist = GameMap.tileDistance(r0: tileRow, c0: tileCol, r1: target.tileRow, c1: target.tileCol)
            if dist <= range {
                facing = GameMap.direction8(fromX: tileRow, y0: tileCol, toX: target.tileRow, y1: target.tileCol)
                if bytes[24] == 0 {
                    target.applyCombatDamage(from: self, engine: engine)
                    bytes[24] = 16
                    if target.kind == .unit && target.refs[0] == nil && target.owner != 0 {
                        target.refs[0] = self
                    }
                }
            } else if bytes[25] == 0 {
                // Chase target
                if let p = Pathfinder.findPath(map: engine.map, tables: engine.tables, startRow: tileRow, startCol: tileCol, goalRow: target.tileRow, goalCol: target.tileCol) {
                    intArrays[1] = p
                    flags[1] = true
                    bytes[25] = 8
                }
            } else {
                bytes[25] -= 1
            }
            return
        } else {
            refs[0] = nil
        }

        // Auto-acquire nearby enemies within sight range (aggressive stance for military units)
        if unitType > 0 {
            let sight = sightRangeTiles(tables: engine.tables)
            if let enemy = engine.findNearestHostile(fromRow: tileRow, col: tileCol, myOwner: owner, maxTileDist: sight) {
                refs[0] = enemy
            }
        }
    }

    private func updateSettlerTask(engine: GameEngine) {
        if flags[4], let site = refs[1], site.active, site.kind == .building, site.state == 0 {
            let dist = GameMap.tileDistance(r0: tileRow, c0: tileCol, r1: site.tileRow, c1: site.tileCol)
            if dist <= 2 {
                site.hp = min(site.maxHP(engine: engine), site.hp + 35)
                site.bytes[3] = max(0, site.bytes[3] - 3)
                if site.bytes[3] == 0 {
                    site.state = 1
                    site.hp = site.maxHP(engine: engine)
                    engine.onBuildingCompleted(site)
                    flags[4] = false
                }
            } else if let p = Pathfinder.findPath(map: engine.map, tables: engine.tables, startRow: tileRow, startCol: tileCol, goalRow: site.tileRow, goalCol: site.tileCol) {
                intArrays[1] = p
                flags[1] = true
            }
            return
        }

        if flags[2] {
            // Gathering at resource node (bytes[15], bytes[16])
            let resR = bytes[15]
            let resC = bytes[16]
            let dist = GameMap.tileDistance(r0: tileRow, c0: tileCol, r1: resR, c1: resC)
            if dist <= 1 {
                if bytes[24] == 0 {
                    bytes[7] += 10
                    bytes[24] = 20
                    if bytes[7] >= 20 {
                        // Deliver directly (instant bank + floating indicator matching J2ME streamlined flow or return to TC)
                        let rType = max(0, min(2, bytes[6]))
                        engine.addResource(owner: owner, resourceType: rType, amount: bytes[7], atRow: tileRow, atCol: tileCol)
                        bytes[7] = 0
                    }
                }
            } else if let p = Pathfinder.findPath(map: engine.map, tables: engine.tables, startRow: tileRow, startCol: tileCol, goalRow: resR, goalCol: resC) {
                intArrays[1] = p
                flags[1] = true
            }
        }
    }

    // Port of b.a():[B & b.a(DataInputStream):Lb (b.javap.txt)
    public func serialize(to w: BigEndianWriter) {
        w.writeIntShort(id)
        w.writeIntByte(kind.rawValue)
        w.writeIntByte(state)
        w.writeInt32(xFixed)
        w.writeInt32(yFixed)
        w.writeInt32(vxFixed)
        w.writeInt32(vyFixed)
        w.writeIntShort(tileRow)
        w.writeIntShort(tileCol)
        w.writeBool(active)
        w.writeIntByte(spriteSlot)
        w.writeIntByte(animSeq)
        w.writeIntByte(animFrame)
        w.writeIntByte(bytes.count)
        for b in bytes { w.writeIntByte(b) }
        w.writeNullableIntArray(ints)
        w.writeNullableIntMatrix(intArrays)
        w.writeNullableBoolArray(flags)
        w.writeIntByte(refs.count)
        for r in refs {
            w.writeIntShort(r?.id ?? -1)
        }
    }

    public static func deserialize(from r: BigEndianReader) throws -> (Entity, [Int]) {
        let eid = Int(try r.readShort())
        let rawKind = Int(try r.readByte())
        let kind = EntityKind(rawValue: rawKind) ?? .unit
        let ent = Entity(kind: kind, id: eid)
        ent.state = Int(try r.readByte())
        ent.xFixed = Int(try r.readInt())
        ent.yFixed = Int(try r.readInt())
        ent.vxFixed = Int(try r.readInt())
        ent.vyFixed = Int(try r.readInt())
        ent.tileRow = Int(try r.readShort())
        ent.tileCol = Int(try r.readShort())
        ent.active = try r.readBool()
        ent.spriteSlot = Int(try r.readByte())
        ent.animSeq = Int(try r.readByte())
        ent.animFrame = Int(try r.readByte())
        let bLen = max(0, Int(try r.readByte()))
        for idx in 0..<bLen {
            let val = Int(try r.readByte())
            if idx < ent.bytes.count { ent.bytes[idx] = val }
        }
        if let ii = try r.readNullableIntArray() {
            for idx in 0..<min(ii.count, ent.ints.count) { ent.ints[idx] = ii[idx] }
        }
        if let mat = try r.readNullableIntMatrix() {
            ent.intArrays = mat
        }
        if let fl = try r.readNullableBoolArray() {
            for idx in 0..<min(fl.count, ent.flags.count) { ent.flags[idx] = fl[idx] }
        }
        let rLen = max(0, Int(try r.readByte()))
        var refIds = [Int](repeating: -1, count: rLen)
        for idx in 0..<rLen {
            refIds[idx] = Int(try r.readShort())
        }
        return (ent, refIds)
    }
}
