// Evidence: ARCHITECTURE-MAP.md — XCTest parity verification suite for Age of Empires III Mobile (iOS 16.0+)
import XCTest
@testable import AgeOfEmpiresIII

final class AgeOfEmpiresIIITests: XCTestCase {
    private func makeTestAssets() -> GameAssets {
        if GameAssets.shared.loadRawFile(named: "lang.dat") != nil {
            return GameAssets.shared
        }
        // Fallback relative to Tests/AgeOfEmpiresIIITests.swift -> ../Sources/Resources/GameAssets
        let testFileURL = URL(fileURLWithPath: #filePath)
        let gameAssetsDir = testFileURL
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Sources/Resources/GameAssets", isDirectory: true)
        return GameAssets(bundle: .main, directory: gameAssetsDir)
    }

    func testLocalizationAndFormatting() throws {
        let assets = makeTestAssets()
        let loc = Localization(assets: assets)
        XCTAssertEqual(loc.strings.count, 338)
        XCTAssertEqual(loc.text(1), "Age of Empires III Mobile")
        XCTAssertEqual(loc.text(2), "Menu chinh")
        XCTAssertEqual(loc.text(3), "Chien dich")
        XCTAssertEqual(loc.format(19, ["4"]), "Nhiem vu 4")
    }

    func testGameTables33ResAndBytecodePatch() throws {
        let assets = makeTestAssets()
        let tables = try GameTables(assets: assets)
        XCTAssertEqual(tables.iI.count, 14)
        XCTAssertEqual(tables.NB.count, 15)
        XCTAssertEqual(tables.aSSS.count, 15)
        XCTAssertEqual(tables.PB.count, 190)
        // Bytecode post-read patch in e.a(): e.a[17][0] = 600, e.a[17][2] = 300
        XCTAssertEqual(tables.aSS[17][0], 600)
        XCTAssertEqual(tables.aSS[17][2], 300)
    }

    func testBitmapFontAndPLTEPaletteSwap() throws {
        let assets = makeTestAssets()
        let font = BitmapFont(assets: assets)
        XCTAssertTrue(font.isBitmapLoaded(0))
        XCTAssertEqual(font.bitmapFont0?.charCountOrCount ?? font.bitmapFont0?.glyphs.count, 136)
        XCTAssertEqual(font.lineHeights[0], 17)
        XCTAssertGreaterThan(font.stringWidth(fontId: 0, text: "Age of Empires"), 60)

        let tables = try GameTables(assets: assets)
        let pack = SpritePackLoader.load(
            resId: 20,
            paletteResIds: [36, -1, 34, 35, -1],
            durationLookup: tables.lS,
            assets: assets
        )
        XCTAssertNotNil(pack)
        XCTAssertEqual(pack?.variantSprites.count, 6)
        XCTAssertGreaterThan(pack?.variantSprites[0].count ?? 0, 0)
    }

    func testMapsIsometricProjectionAndAStarPathfinder() throws {
        let assets = makeTestAssets()
        let tables = try GameTables(assets: assets)
        let map = GameMap()
        var rng: UInt32 = 12345
        XCTAssertTrue(map.load(mapIndex: 10, tables: tables, assets: assets, rng: &rng))
        XCTAssertEqual(map.rows, 29)
        XCTAssertEqual(map.cols, 40)

        let iso = GameMap.worldToIso(worldX: 480, worldY: 240)
        let roundTrip = GameMap.isoToWorld(isoX: iso.0, isoY: iso.1)
        XCTAssertLessThanOrEqual(abs(roundTrip.0 - 480), 4)
        XCTAssertLessThanOrEqual(abs(roundTrip.1 - 240), 4)

        let path = Pathfinder.findPath(map: map, tables: tables, startRow: 5, startCol: 5, goalRow: 8, goalCol: 7)
        XCTAssertNotNil(path)
        XCTAssertGreaterThanOrEqual(path?.count ?? 0, 2)
    }

    func testMidiParserAndSaveStoreRoundTrip() throws {
        let assets = makeTestAssets()
        let midiData = assets.loadResource(id: 4)
        XCTAssertNotNil(midiData)
        let seq = midiData.flatMap { ParsedMidiSequence.parse(data: $0) }
        XCTAssertNotNil(seq)
        XCTAssertGreaterThan(seq?.events.count ?? 0, 20)

        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }
        let store = SaveStore(directory: tempDir)
        let s = SettingsSaveData(soundEnabled: false, vibrationEnabled: true, hintsEnabled: false, maxUnlockedCampaign: 5, completedCampaignMask: 15)
        store.saveSettings(s)
        XCTAssertEqual(store.loadSettings(), s)
    }

    func testSimulationTickCheatAndSoftwareRenderer() throws {
        let assets = makeTestAssets()
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let coord = try MenuCoordinator(assets: assets, saveDirectory: tempDir, skipSplash: true)
        XCTAssertEqual(coord.screenState, .menu)

        // Start Campaign Mission 1
        coord.engine.startCampaign(mission: 0)
        coord.screenState = .playing
        XCTAssertFalse(coord.engine.entities.isEmpty)

        // Tick 25 frames (sim + AI + animations)
        for _ in 0..<25 { coord.tick50ms() }

        // Cheat sequence check: [L,R,L,L,R,R,L,L,L,R,R,R,0]
        let foodBefore = coord.engine.playerResources[0][0]
        for key in [-3, -4, -3, -3, -4, -4, -3, -3, -3, -4, -4, -4, 48] {
            coord.handleKeyCode(key)
        }
        XCTAssertEqual(coord.engine.playerResources[0][0], foodBefore + 10000)

        // Binary state round-trip
        let savedData = coord.engine.serializeState(title: "Test")
        let restoredEngine = GameEngine(assets: assets, tables: coord.tables, localization: coord.localization)
        XCTAssertTrue(restoredEngine.deserializeState(data: savedData))
        XCTAssertEqual(restoredEngine.playerResources[0][0], foodBefore + 10000)

        // Render 360x400 frame
        let surf = coord.renderFrame()
        XCTAssertEqual(surf.width, 360)
        XCTAssertEqual(surf.height, 400)
        XCTAssertNotNil(surf.makeCGImage())
    }
}

private extension BitmapFont.MetricFont {
    var charCountOrCount: Int { glyphs.count }
}
