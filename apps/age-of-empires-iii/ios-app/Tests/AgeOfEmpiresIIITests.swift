// Evidence: ARCHITECTURE-MAP.md — XCTest parity verification suite for Age of Empires III Mobile (iOS 16.0+ Landscape)
import XCTest
@testable import AgeOfEmpiresIII

final class AgeOfEmpiresIIITests: XCTestCase {
    private func makeTestAssets() -> GameAssets {
        if GameAssets.shared.loadRawFile(named: "lang.dat") != nil {
            return GameAssets.shared
        }
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
        XCTAssertEqual(tables.aSS[17][0], 600)
        XCTAssertEqual(tables.aSS[17][2], 300)
    }

    func testBitmapFontSpritePackAnimationMappingAndPLTE() throws {
        let assets = makeTestAssets()
        let font = BitmapFont(assets: assets)
        XCTAssertTrue(font.isBitmapLoaded(0))
        XCTAssertEqual(font.bitmapFont0?.glyphs.count, 136)
        XCTAssertEqual(font.lineHeights[0], 17)
        XCTAssertGreaterThan(font.stringWidth(fontId: 0, text: "Age of Empires"), 60)

        let tables = try GameTables(assets: assets)
        // Verify 30.res (Settler) 3-byte animation layout: frameIdx, transform via lS, duration
        let settlerPack = SpritePackLoader.load(
            resId: 30,
            paletteResIds: [36, -1],
            durationLookup: tables.lS,
            assets: assets
        )
        XCTAssertNotNil(settlerPack)
        XCTAssertEqual(settlerPack?.seqFrames[4], [1, 0, 2, 0])
        XCTAssertEqual(settlerPack?.seqTransforms[4], [2, 2, 2, 2])
        XCTAssertEqual(settlerPack?.seqDurations[4], [4, 3, 4, 3])
        XCTAssertEqual(settlerPack?.seqFrames[9], [8, 9])

        let cannonPack = SpritePackLoader.load(
            resId: 20,
            paletteResIds: [36, -1, 34, 35, -1],
            durationLookup: tables.lS,
            assets: assets
        )
        XCTAssertEqual(cannonPack?.variantSprites.count, 6)
    }

    func testMapsIsometricColMinusRowAndAStarPathfinder() throws {
        let assets = makeTestAssets()
        let tables = try GameTables(assets: assets)
        let map = GameMap()
        var rng: UInt32 = 12345
        XCTAssertTrue(map.load(mapIndex: 10, tables: tables, assets: assets, rng: &rng))
        XCTAssertEqual(map.rows, 29)
        XCTAssertEqual(map.cols, 40)

        // Check (col - row) axis sign + inverse round-trip
        let isoPos = GameMap.worldToIso(worldX: 96, worldY: 144) // col=3, row=2 -> isoX=+16
        XCTAssertEqual(isoPos.0, 16)
        XCTAssertEqual(isoPos.1, 40)
        let rt = GameMap.isoToWorld(isoX: isoPos.0, isoY: isoPos.1)
        XCTAssertEqual(rt.0, 96)
        XCTAssertEqual(rt.1, 144)

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

    func testLandscapeTapGatheringAnimationBuildingAndCheat() throws {
        let assets = makeTestAssets()
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let coord = try MenuCoordinator(assets: assets, saveDirectory: tempDir, skipSplash: true)
        coord.engine.startCampaign(mission: 0)
        coord.screenState = .playing

        // Verify settler walk + diagonal gather animation and actual resource income
        guard let settler = coord.engine.entities.first(where: { $0.owner == 0 && $0.kind == .unit && $0.unitType == 0 }),
              let node = coord.engine.findNearestResourceTile(fromRow: settler.tileRow, fromCol: settler.tileCol, resourceType: 1, maxRadius: 12) else {
            XCTFail("Expected player settler and wood node")
            return
        }
        settler.bytes[15] = node.0
        settler.bytes[16] = node.1
        settler.bytes[6] = node.2
        settler.flags[2] = true

        let woodBefore = coord.engine.playerResources[0][1]
        var sawWalkSeq = false
        var sawGatherSeq = false
        var seenFrames = Set<Int>()
        for _ in 0..<80 {
            coord.tick50ms()
            if settler.animSeq >= 4 && settler.animSeq <= 7 { sawWalkSeq = true }
            if settler.animSeq >= 8 && settler.animSeq <= 11 { sawGatherSeq = true }
            seenFrames.insert(settler.animFrame)
        }
        XCTAssertTrue(sawWalkSeq || sawGatherSeq, "Settler must animate when walking/gathering")
        XCTAssertTrue(sawGatherSeq, "Settler must reach resource node and play gather animation")
        XCTAssertGreaterThan(seenFrames.count, 1, "Animation frames must advance")
        XCTAssertGreaterThan(coord.engine.playerResources[0][1], woodBefore, "Wood must increase during harvest")

        // Verify direct TC training (Settler 100F) and House placement (100W)
        if let tc = coord.engine.entities.first(where: { $0.owner == 0 && $0.kind == .building && $0.buildingType == 1 }) {
            XCTAssertTrue(coord.engine.issueBuildingCommand(tc, commandId: 8))
        }
        if let spot = Pathfinder.findNearestWalkableTile(map: coord.engine.map, tables: coord.engine.tables, nearRow: settler.tileRow + 1, nearCol: settler.tileCol + 1, maxRadius: 4) {
            XCTAssertTrue(coord.engine.placeBuildingForOwner(owner: 0, buildingType: 2, row: spot.0, col: spot.1, constructedImmediately: false))
        }

        // Verify 512x250 Landscape render
        let surf = coord.renderFrame()
        XCTAssertEqual(surf.width, 512)
        XCTAssertEqual(surf.height, 250)
        XCTAssertNotNil(surf.makeCGImage())
    }
}
