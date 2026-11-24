// Port of e.a() — 33.res balance database & campaign script loader (Evidence: e.javap.txt:966-1200)
import Foundation

public final class GameTables {
    // Exact order & descriptors parsed from e.a() in e.javap.txt
    public var aB: [Int] = []          // e.a:[B — building build flags / HP scale
    public var bB: [Int] = []          // e.b:[B — unit move speed / anim
    public var cB: [Int] = []          // e.c:[B — unit counter bitmask / type
    public var dB: [Int] = []          // e.d:[B — unit class / attack type
    public var eB: [Int] = []          // e.e:[B — unit range / cooldown
    public var fB: [Int] = []          // e.f:[B — direction vectors / unit props (len=16)
    public var fI: [Int] = []          // e.f:[I — projectile/range/fixed constants (len=16)
    public var gI: [Int] = []          // e.g:[I — unit attack/speed params (len=16)
    public var xB: [Int] = []          // e.x:[B — unit armor/pop/modifiers (len=10)
    public var KB: [Int] = []          // e.K:[B — explosion/smoke SFX/sprite types (len=8)
    public var rB: [Int] = []          // e.r:[B — 29 command categories (len=29)
    public var sB: [Int] = []          // e.s:[B — 27 command age requirements (len=27)
    public var aSS: [[Int]] = []       // e.a:[[S — 27 command [Food, Wood, Gold] costs (len=27)
    public var gS: [Int] = []          // e.g:[S — starting/mission short constants (len=2)
    public var vB: [Int] = []          // e.v:[B — resource terrain -> resourceType pairs (len=20)
    public var kS: [Int] = []          // e.k:[S — resource capacity [Food=1000, Wood=300, Gold=3000]
    public var wB: [Int] = []          // e.w:[B — prop terrain -> gather sprite/mode pairs (len=20)
    public var LB: [Int] = []          // e.L:[B — impassable terrain codes (len=20)
    public var MB: [Int] = []          // e.M:[B — autotile / transition edge table (len=66)
    public var iI: [Int] = []          // e.i:[I — 14 map .res IDs [6,7,12..19,8..11]
    public var BB: [Int] = []          // e.B:[B — isometric diamond polygon X coords (len=12)
    public var CB: [Int] = []          // e.C:[B — isometric diamond polygon Y1 coords (len=12)
    public var DB: [Int] = []          // e.D:[B — isometric diamond polygon Y2 coords (len=12)
    public var QB: [Int] = []          // e.Q:[B — variant terrain tile codes for code 2
    public var RB: [Int] = []          // e.R:[B — variant terrain tile codes for code 3
    public var EB: [Int] = []          // e.E:[B — variant terrain codes (len=4)
    public var SB: [Int] = []          // e.S:[B — resource tile codes check (len=10)
    public var lS: [Int16] = []        // e.l:[S — animation duration lookup pairs
    public var yB: [Int] = []          // e.y:[B — 24 sprite slot properties
    public var PB: [Int] = []          // e.P:[B — terrain/prop tile code -> PNG slice lookup pairs (len=190)
    public var bII: [[Int]] = []       // e.b:[[I — 24 sprite slot .res IDs (len=24)
    public var nB: [Int] = []          // e.n:[B — unit base speed / subtype count (len=8)
    public var aS: [Int] = []          // e.a:[S — attack / pop / stat array (len=8)
    public var JB: [Int] = []          // e.J:[B — unit pop cost / category (len=8)
    public var bS: [Int] = []          // e.b:[S — unit fixed-point speed / range (len=8)
    public var cS: [Int] = []          // e.c:[S — unit HP (len=8)
    public var dS: [Int] = []          // e.d:[S — unit melee/ranged attack (len=8)
    public var gB: [Int] = []          // e.g:[B — unit armor/speed (len=8)
    public var eS: [Int] = []          // e.e:[S — unit training ticks (len=8)
    public var hB: [Int] = []          // e.h:[B — unit sight/aggro (len=8)
    public var iB: [Int] = []          // e.i:[B — unit splash/flag (len=8)
    public var jB: [Int] = []          // e.j:[B — unit range tiles (len=8)
    public var kB: [Int] = []          // e.k:[B — unit damage/bonus (len=8)
    public var bBB: [[Int]?] = []      // e.b:[[B — unit counter bonus target classes (len=8)
    public var lB: [Int] = []          // e.l:[B — unit build/sprite ID (len=8)
    public var mB: [Int] = []          // e.m:[B — unit tier/armor? (len=8)
    public var tB: [Int] = []          // e.t:[B — tech/upgrade param array (len=6)
    public var uB: [Int] = []          // e.u:[B — tech/upgrade param array (len=6)
    public var hS: [Int] = []          // e.h:[S — age/hero bonus values (len=3)
    public var cSS: [[Int]] = []       // e.c:[[S — localized unit upgrade names per archetype (len=8)
    public var aBB: [[Int]] = []       // e.a:[[B — unit upgrade tier sprite/index table (len=8)
    public var hBB: [[Int]?] = []      // e.h:[[B — building UI / training slots? (len=9)
    public var oB: [Int] = []          // e.o:[B — effect/projectile parameters (len=18)
    public var fS: [Int] = []          // e.f:[S — building max HP by type (len=9)
    public var pB: [Int] = []          // e.p:[B — building sight range (len=9)
    public var qB: [Int] = []          // e.q:[B — building train/attack capability (len=9)
    public var cBB: [[Int]] = []       // e.c:[[B — command sets per building/panel (len=9)
    public var FB: [Int] = []          // e.F:[B — command ID -> 39.res icon slice index (len=29)
    public var OB: [Int] = []          // e.O:[B — 8 building HUD icon offsets (len=16)
    public var zB: [Int] = []          // e.z:[B — building sprite mapping (len=18)
    public var AB: [Int] = []          // e.A:[B — building death/smoke params (len=9)
    public var TB: [Int] = []          // e.T:[B — faction/setting flags (len=2)
    public var NB: [Int] = []          // e.N:[B — 15 campaign mission -> map index (len=15)
    public var iBB: [[Int]] = []       // e.i:[[B — 15 campaign objectives/factions (len=15)
    public var hI: [Int] = []          // e.h:[I — 15 campaign command unlock bitmasks (len=15)
    public var aSSS: [[[Int]]] = []    // e.a:[[[S — 15 campaign trigger scripts

    // Static tables from j.<clinit>, e.o, e.p
    public static let aiBaseBuildPriority: [Int] = [0, 3, 4, 5, 2, 1, 6, 7]

    public init(assets: GameAssets = .shared) throws {
        guard let data = assets.loadResource(id: 33) else {
            throw BigEndianIOError.unexpectedEOF
        }
        let r = BigEndianReader(data: data)

        func rb(_ shortLen: Bool = false) throws -> [Int] {
            return (try r.readByteArray(shortLength: shortLen)).map(Int.init)
        }
        func rbm() throws -> [[Int]?] {
            return (try r.readByteMatrix()).map { $0?.map(Int.init) }
        }
        func rbmNonNil() throws -> [[Int]] {
            return (try r.readByteMatrix()).map { $0?.map(Int.init) ?? [] }
        }
        func rs() throws -> [Int] {
            return (try r.readShortArray()).map(Int.init)
        }
        func rsm() throws -> [[Int]] {
            return (try r.readShortMatrix()).map { $0?.map(Int.init) ?? [] }
        }
        func ri() throws -> [Int] {
            return (try r.readIntArray()).map(Int.init)
        }
        func rim() throws -> [[Int]] {
            return (try r.readIntMatrix()).map { $0?.map(Int.init) ?? [] }
        }

        aB = try rb()
        bB = try rb()
        cB = try rb()
        dB = try rb()
        eB = try rb()
        fB = try rb()
        fI = try ri()
        gI = try ri()
        xB = try rb()
        KB = try rb()
        rB = try rb()
        sB = try rb()
        aSS = try rsm()
        gS = try rs()
        vB = try rb()
        kS = try rs()
        wB = try rb()
        LB = try rb()
        MB = try rb()
        iI = try ri()
        BB = try rb()
        CB = try rb()
        DB = try rb()
        QB = try rb()
        RB = try rb()
        EB = try rb()
        SB = try rb()
        lS = try r.readShortArray()

        // Bytecode post-read patch right after e.l:[S (e.pseudo.java:471-472)
        if aSS.count > 17, aSS[17].count >= 3 {
            aSS[17][0] = 600
            aSS[17][2] = 300
        }

        yB = try rb()
        PB = try rb(true)
        bII = try rim()
        nB = try rb()
        aS = try rs()
        JB = try rb()
        bS = try rs()
        cS = try rs()
        dS = try rs()
        gB = try rb()
        eS = try rs()
        hB = try rb()
        iB = try rb()
        jB = try rb()
        kB = try rb()
        bBB = try rbm()
        lB = try rb()
        mB = try rb()
        tB = try rb()
        uB = try rb()
        hS = try rs()
        cSS = try rsm()
        aBB = try rbmNonNil()
        hBB = try rbm()
        oB = try rb()
        fS = try rs()
        pB = try rb()
        qB = try rb()
        cBB = try rbmNonNil()
        FB = try rb()
        OB = try rb()
        zB = try rb()
        AB = try rb()
        TB = try rb()
        NB = try rb()
        iBB = try rbmNonNil()
        hI = try ri()

        let missionCount = Int(try r.readByte())
        var missions = [[[Int]]]()
        missions.reserveCapacity(max(0, missionCount))
        for _ in 0..<max(0, missionCount) {
            missions.append(try rsm())
        }
        aSSS = missions
    }

    // Port of f.a(byte[], int):I key-value pair lookup
    public static func pairLookup(_ table: [Int], key: Int) -> Int {
        var i = 0
        while i + 1 < table.count {
            if table[i] == key { return table[i + 1] }
            i += 2
        }
        return -1
    }

    // Port of f.a(short[], int):S key-value pair lookup
    public static func pairLookup(_ table: [Int16], key: Int) -> Int16 {
        var i = 0
        while i + 1 < table.count {
            if Int(table[i]) == key { return table[i + 1] }
            i += 2
        }
        return -1
    }

    // Port of f.b(byte[], int):I linear index search
    public static func indexOf(_ table: [Int], value: Int) -> Int {
        for (idx, elem) in table.enumerated() where elem == value {
            return idx
        }
        return -1
    }
}
