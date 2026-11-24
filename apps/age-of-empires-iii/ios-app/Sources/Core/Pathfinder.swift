// Port of i.java (A* node) & e.a(int,int,int,int,int,int[]) A* pathfinder + spiral search
import Foundation

public final class PathNode {
    public var parent: PathNode?
    public var row: Int
    public var col: Int
    public var g: Int
    public var f: Int
    public var state: Int // 1 = open, 2 = closed

    public init(parent: PathNode? = nil, row: Int = 0, col: Int = 0, g: Int = 0, f: Int = 0, state: Int = 1) {
        self.parent = parent
        self.row = row
        self.col = col
        self.g = g
        self.f = f
        self.state = state
    }
}

public enum Pathfinder {
    // Port of e.a(startRow, startCol, goalRow, goalCol, maxSteps, ...) — returns flat [r0, c0, r1, c1, ...]
    public static func findPath(
        map: GameMap,
        tables: GameTables,
        startRow: Int,
        startCol: Int,
        goalRow: Int,
        goalCol: Int,
        maxExpansions: Int = 220,
        allowGoalOccupied: Bool = true
    ) -> [Int]? {
        guard map.isInBounds(row: startRow, col: startCol),
              map.isInBounds(row: goalRow, col: goalCol) else {
            return nil
        }
        if startRow == goalRow && startCol == goalCol {
            return [goalRow, goalCol]
        }

        // If goal itself is unwalkable, snap to nearest walkable neighbor first
        var targetR = goalRow
        var targetC = goalCol
        if !map.isTileWalkable(row: targetR, col: targetC, tables: tables, ignoreOccupancy: allowGoalOccupied) {
            if let adj = findNearestWalkableTile(map: map, tables: tables, nearRow: targetR, nearCol: targetC, maxRadius: 4) {
                targetR = adj.0
                targetC = adj.1
            } else {
                return nil
            }
        }

        let cols = map.cols
        @inline(__always) func key(_ r: Int, _ c: Int) -> Int { r * cols + c }
        @inline(__always) func heuristic(_ r: Int, _ c: Int) -> Int {
            (abs(targetR - r) + abs(targetC - c)) * 10
        }

        var open = [PathNode]()
        var visited = [Int: PathNode]()
        let startNode = PathNode(parent: nil, row: startRow, col: startCol, g: 0, f: heuristic(startRow, startCol), state: 1)
        open.append(startNode)
        visited[key(startRow, startCol)] = startNode

        // 8-connected offsets with orthogonal=10, diagonal=14 costs matching e.a A*
        let dirs = [
            (-1, 0, 10), (1, 0, 10), (0, -1, 10), (0, 1, 10),
            (-1, -1, 14), (-1, 1, 14), (1, -1, 14), (1, 1, 14)
        ]

        var bestFallback = startNode
        var expansions = 0

        while !open.isEmpty && expansions < maxExpansions {
            var bestIdx = 0
            for idx in 1..<open.count where open[idx].f < open[bestIdx].f {
                bestIdx = idx
            }
            let current = open.remove(at: bestIdx)
            current.state = 2
            expansions += 1

            if current.row == targetR && current.col == targetC {
                return reconstructPath(from: current)
            }
            if heuristic(current.row, current.col) < heuristic(bestFallback.row, bestFallback.col) {
                bestFallback = current
            }

            for (dr, dc, stepCost) in dirs {
                let nr = current.row + dr
                let nc = current.col + dc
                guard map.isInBounds(row: nr, col: nc) else { continue }
                let isTarget = (nr == targetR && nc == targetC)
                if !map.isTileWalkable(row: nr, col: nc, tables: tables, ignoreOccupancy: isTarget && allowGoalOccupied) {
                    continue
                }
                // Prevent diagonal corner cutting through unwalkable corners
                if dr != 0 && dc != 0 {
                    if !map.isTileWalkable(row: current.row + dr, col: current.col, tables: tables)
                        && !map.isTileWalkable(row: current.row, col: current.col + dc, tables: tables) {
                        continue
                    }
                }
                let nk = key(nr, nc)
                let newG = current.g + stepCost
                if let existing = visited[nk] {
                    if existing.state == 2 { continue }
                    if newG < existing.g {
                        existing.parent = current
                        existing.g = newG
                        existing.f = newG + heuristic(nr, nc)
                    }
                } else {
                    let node = PathNode(parent: current, row: nr, col: nc, g: newG, f: newG + heuristic(nr, nc), state: 1)
                    visited[nk] = node
                    open.append(node)
                }
            }
        }

        return bestFallback.parent != nil ? reconstructPath(from: bestFallback) : nil
    }

    private static func reconstructPath(from endNode: PathNode) -> [Int] {
        var reversed = [(Int, Int)]()
        var cur: PathNode? = endNode
        while let node = cur, node.parent != nil {
            reversed.append((node.row, node.col))
            cur = node.parent
        }
        reversed.reverse()
        var flat = [Int]()
        flat.reserveCapacity(reversed.count * 2)
        for (r, c) in reversed {
            flat.append(r)
            flat.append(c)
        }
        return flat
    }

    // Port of e.a(r, c, ...) spiral free-tile search
    public static func findNearestWalkableTile(
        map: GameMap,
        tables: GameTables,
        nearRow: Int,
        nearCol: Int,
        maxRadius: Int = 6
    ) -> (Int, Int)? {
        if map.isTileWalkable(row: nearRow, col: nearCol, tables: tables) {
            return (nearRow, nearCol)
        }
        for rad in 1...maxRadius {
            for dr in -rad...rad {
                for dc in -rad...rad where abs(dr) == rad || abs(dc) == rad {
                    let r = nearRow + dr
                    let c = nearCol + dc
                    if map.isTileWalkable(row: r, col: c, tables: tables) {
                        return (r, c)
                    }
                }
            }
        }
        return nil
    }
}
