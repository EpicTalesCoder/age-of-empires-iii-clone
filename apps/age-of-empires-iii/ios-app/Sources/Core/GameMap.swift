// Port of e.c(int) map loader (6..19.res), fog/shroud bitmask e.k[], and isometric transform (e.a/e.b)
import Foundation

public final class GameMap {
    public static let tileLogicSize = 48
    public static let tileHalfLogic = 24
    public static let tilePixelW = 32   // e.d = e.a[0].width = 32 (960 / 30)
    public static let tilePixelH = 16   // e.e = e.a[0].height + e.T[0] = 15 + 1 = 16

    public var mapSlotIndex: Int = 0
    public var rows: Int = 0 // e.b
    public var cols: Int = 0 // e.c
    public var terrain: [Int] = []     // e.U (unsigned/signed tile codes per e.P lookup)
    public var fogGrid: [Int] = []     // e.k bitmask: bit 0=explored, bit 1=currently visible, higher=building/block flags
    public var spawnGroups: [[(Int, Int, Int)]] = [] // e.j: unit/building initial spawn triples

    public init() {}

    // Port of e.c(int mapIdx) (e.pseudo.java:1051-1105)
    public func load(mapIndex: Int, tables: GameTables, assets: GameAssets = .shared, rng: inout UInt32) -> Bool {
        guard mapIndex >= 0, mapIndex < tables.iI.count else { return false }
        let resId = tables.iI[mapIndex]
        guard let data = assets.loadResource(id: resId) else { return false }
        let r = BigEndianReader(data: data)
        do {
            self.mapSlotIndex = mapIndex
            self.rows = Int(try r.readByte())
            self.cols = Int(try r.readByte())
            let count = rows * cols
            var terr = [Int](repeating: 0, count: count)
            let fog = [Int](repeating: 0, count: count)

            for idx in 0..<count {
                var t = Int(try r.readByte())
                if t == 2 && !tables.QB.isEmpty {
                    rng = rng &* 1664525 &+ 1013904223
                    let rIdx = Int(rng >> 16) % tables.QB.count
                    t = tables.QB[rIdx]
                } else if t == 3 && !tables.RB.isEmpty {
                    rng = rng &* 1664525 &+ 1013904223
                    let rIdx = Int(rng >> 16) % tables.RB.count
                    t = tables.RB[rIdx]
                }
                terr[idx] = t
            }
            self.terrain = terr
            self.fogGrid = fog

            let gCount = max(0, Int(try r.readByte()))
            var groups = [[(Int, Int, Int)]]()
            groups.reserveCapacity(gCount)
            for _ in 0..<gCount {
                let n = max(0, Int(try r.readByte()))
                let raw = try r.readBytes(n * 3)
                let bytes = [UInt8](raw)
                var triples = [(Int, Int, Int)]()
                triples.reserveCapacity(n)
                for k in 0..<n {
                    let a = Int(Int8(bitPattern: bytes[k * 3]))
                    let b = Int(Int8(bitPattern: bytes[k * 3 + 1]))
                    let c = Int(Int8(bitPattern: bytes[k * 3 + 2]))
                    triples.append((a, b, c))
                }
                groups.append(triples)
            }
            self.spawnGroups = groups
            return true
        } catch {
            return false
        }
    }

    public func isInBounds(row: Int, col: Int) -> Bool {
        return row >= 0 && row < rows && col >= 0 && col < cols
    }

    public func terrainAt(row: Int, col: Int) -> Int {
        guard isInBounds(row: row, col: col) else { return -1 }
        return terrain[row * cols + col]
    }

    // Port of e.a(int row, int col):Z — true if terrain is a resource node (berries, forest, mine)
    public static func isResourceTerrain(_ code: Int, tables: GameTables) -> Bool {
        return tables.SB.contains(code)
    }

    // Port of e.b(int row, int col):Z — true if tile is passable for walking (checks e.L walkable whitelist & fog building bit)
    public func isTileWalkable(row: Int, col: Int, tables: GameTables, ignoreOccupancy: Bool = false) -> Bool {
        guard isInBounds(row: row, col: col) else { return false }
        let code = terrain[row * cols + col]
        guard tables.LB.contains(code) else { return false }
        if !ignoreOccupancy && (fogGrid[row * cols + col] & 4) != 0 { return false }
        return true
    }

    // Port of e.a(int worldX, int worldY, int tileW, int tileH):[I (e.javap.txt:14013)
    // Returns isometric screen coordinates relative to world origin (0,0)
    public static func worldToIso(worldX: Int, worldY: Int, tileW: Int = tilePixelW, tileH: Int = tilePixelH) -> (Int, Int) {
        let halfW = max(1, tileW / 2)
        let halfH = max(1, tileH / 2)
        if 48 % halfW == 0 && 48 % halfH == 0 {
            let sx = (worldX - worldY) / (48 / halfW)
            let sy = (worldX + worldY) / (48 / halfH)
            return (sx, sy)
        } else {
            let sx = ((worldX - worldY) * halfW) / 48
            let sy = ((worldX + worldY) * halfH) / 48
            return (sx, sy)
        }
    }

    // Inverse isometric projection from screen pixel back to world (worldX, worldY) logic coords
    public static func isoToWorld(isoX: Int, isoY: Int, tileW: Int = tilePixelW, tileH: Int = tilePixelH) -> (Int, Int) {
        let halfW = Double(max(1, tileW / 2))
        let halfH = Double(max(1, tileH / 2))
        let u = Double(isoX) * 48.0 / halfW // wx - wy
        let v = Double(isoY) * 48.0 / halfH // wx + wy
        let wx = Int((v + u) * 0.5)
        let wy = Int((v - u) * 0.5)
        return (wx, wy)
    }

    // Port of e.a(x0, y0, x1, y1):I -> 8-way facing direction 0..7
    public static func direction8(fromX x0: Int, y0: Int, toX x1: Int, y1: Int) -> Int {
        let dx = x1 - x0
        let dy = y1 - y0
        if abs(dy) == 0 {
            return dx > 0 ? 4 : 0
        }
        if abs(dx) == 0 {
            return dy > 0 ? 2 : 6
        }
        if dx < 0 {
            return dy < 0 ? 7 : 1
        } else {
            return dy < 0 ? 5 : 3
        }
    }

    // Port of e.a(r0, c0, r1, c1) Manhattan tile distance & chebyshev distance
    public static func tileDistance(r0: Int, c0: Int, r1: Int, c1: Int) -> Int {
        return abs(r1 - r0) + abs(c1 - c0)
    }
}
