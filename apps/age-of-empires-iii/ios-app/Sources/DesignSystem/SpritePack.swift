// Port of k.java (Sprite/ImageRegion & split/transform engine) and e.a(int,int,int[]) loader (20..32.res)
import Foundation

public struct SpriteTransform {
    public static let none = 0
    public static let mirrorRot180 = 1 // flip vertical
    public static let mirror = 2       // flip horizontal
    public static let rot180 = 3
    public static let mirrorRot270 = 4
    public static let rot90 = 5
    public static let rot270 = 6
    public static let mirrorRot90 = 7
}

public final class GameSprite {
    public let surface: PixelSurface
    public let srcX: Int
    public let srcY: Int
    public let width: Int
    public let height: Int
    public let defaultTransform: Int

    public init(surface: PixelSurface, srcX: Int = 0, srcY: Int = 0, width: Int? = nil, height: Int? = nil, transform: Int = 0) {
        self.surface = surface
        self.srcX = srcX
        self.srcY = srcY
        self.width = width ?? surface.width
        self.height = height ?? surface.height
        self.defaultTransform = transform
    }

    public convenience init?(resId: Int, assets: GameAssets = .shared) {
        guard let data = assets.loadResource(id: resId),
              let surface = PixelSurface.decodePNG(data: data) else {
            return nil
        }
        self.init(surface: surface)
    }

    public convenience init?(filename: String, assets: GameAssets = .shared) {
        guard let data = assets.loadRawFile(named: filename),
              let surface = PixelSurface.decodePNG(data: data) else {
            return nil
        }
        self.init(surface: surface)
    }

    public convenience init?(pngData: Data) {
        guard let surface = PixelSurface.decodePNG(data: pngData) else { return nil }
        self.init(surface: surface)
    }

    public convenience init(copy base: GameSprite, transform: Int) {
        self.init(
            surface: base.surface,
            srcX: base.srcX,
            srcY: base.srcY,
            width: base.width,
            height: base.height,
            transform: transform
        )
    }

    public static func solidColor(width: Int, height: Int, rgb: UInt32) -> GameSprite {
        let argb = 0xFF00_0000 | (rgb & 0x00FF_FFFF)
        return GameSprite(surface: PixelSurface(width: width, height: height, fill: argb))
    }

    // Port of k.a(int count):[Lk;
    public func splitHorizontally(count: Int) -> [GameSprite] {
        guard count > 0, width >= count else { return [self] }
        let pieceW = width / count
        let pieceH = height
        let cols = width / pieceW
        let rows = height / pieceH
        var result = [GameSprite]()
        result.reserveCapacity(cols * rows)
        for r in 0..<rows {
            for c in 0..<cols {
                result.append(GameSprite(
                    surface: surface,
                    srcX: srcX + c * pieceW,
                    srcY: srcY + r * pieceH,
                    width: pieceW,
                    height: pieceH,
                    transform: defaultTransform
                ))
            }
        }
        return result
    }
}

public struct SpritePackData {
    public let anchorX: Int
    public let anchorY: Int
    public let loopFlags: [Int]              // e.f[slot][seq]
    public let seqFrames: [[Int]]            // e.a[slot][seq][frame] -> sprite piece index
    public let seqDurations: [[Int]]         // e.b[slot][seq][frame] -> ticks via f.a(e.l, rawByte)
    public let seqTransforms: [[Int]]        // e.b[slot][seq][frame] -> SpriteTransform
    public let variantSprites: [[GameSprite]] // e.a[slot][variant][pieceIdx]
}

public enum SpritePackLoader {
    // Port of e.a(int resId, int slotIndex, int[] paletteResIds) (e.javap.txt:1914-2045)
    // Byte 1 -> e.a:[[[B (frameSpriteIdx)
    // Byte 2 -> f.a(e.l:[S, b2) -> e.b:[[[S (SpriteTransform passed to k.a(..., transform, 20))
    // Byte 3 -> e.b:[[[B (durationTicks stored in b.o)
    public static func load(
        resId: Int,
        paletteResIds: [Int]?,
        durationLookup: [Int16],
        assets: GameAssets = .shared
    ) -> SpritePackData? {
        guard resId != -1, let data = assets.loadResource(id: resId) else {
            return nil
        }
        let r = BigEndianReader(data: data)
        do {
            let gridN = Int(try r.readByte())
            let anchorX = Int(try r.readByte())
            let anchorY = Int(try r.readByte())
            let seqCount = Int(try r.readByte())

            var loopFlags = [Int]()
            var seqFrames = [[Int]]()
            var seqDurations = [[Int]]()
            var seqTransforms = [[Int]]()

            for _ in 0..<seqCount {
                loopFlags.append(Int(try r.readByte()))
                let frameCount = Int(try r.readByte())
                var fIdx = [Int]()
                var fDur = [Int]()
                var fTrans = [Int]()
                for _ in 0..<frameCount {
                    let frameIdx = Int(try r.readByte())
                    let rawTransKey = Int(try r.readByte())
                    let mappedTrans = Int(GameTables.pairLookup(durationLookup, key: rawTransKey))
                    let delayTicks = Int(try r.readByte())
                    fIdx.append(frameIdx)
                    fTrans.append(mappedTrans >= 0 ? mappedTrans : 0)
                    fDur.append(max(1, delayTicks))
                }
                seqFrames.append(fIdx)
                seqDurations.append(fDur)
                seqTransforms.append(fTrans)
            }

            let imgCount = Int(try r.readByte())
            var pngDatas = [Data]()
            for _ in 0..<imgCount {
                let sz = Int(try r.readInt())
                pngDatas.append(try r.readBytes(sz))
            }

            var variantCount = Int(try r.readByte())
            if let palIds = paletteResIds {
                variantCount = palIds.count
            }

            var variants = [[GameSprite]]()
            variants.reserveCapacity(variantCount + 1)

            // Base palette variant 0
            if imgCount == 1, let baseSprite = GameSprite(pngData: pngDatas[0]) {
                variants.append(baseSprite.splitHorizontally(count: max(1, gridN)))
            } else {
                var arr = [GameSprite]()
                for d in pngDatas {
                    if let sp = GameSprite(pngData: d) { arr.append(sp) }
                }
                variants.append(arr)
            }

            // Palette-swapped variants 1...variantCount
            for vIdx in 0..<variantCount {
                var palData: Data? = nil
                if let palIds = paletteResIds {
                    if palIds[vIdx] != -1 {
                        palData = assets.loadResource(id: palIds[vIdx])
                    }
                } else {
                    let psz = Int(try r.readShort())
                    palData = try r.readBytes(psz)
                }

                if let plte = palData {
                    if imgCount == 1 {
                        let patched = PLTEPatcher.replacePLTE(pngData: pngDatas[0], plteChunk: plte)
                        if let sp = GameSprite(pngData: patched) {
                            variants.append(sp.splitHorizontally(count: max(1, gridN)))
                        } else {
                            variants.append([])
                        }
                    } else {
                        var arr = [GameSprite]()
                        for d in pngDatas {
                            let patched = PLTEPatcher.replacePLTE(pngData: d, plteChunk: plte)
                            if let sp = GameSprite(pngData: patched) { arr.append(sp) }
                        }
                        variants.append(arr)
                    }
                } else {
                    variants.append(variants[0])
                }
            }

            return SpritePackData(
                anchorX: anchorX,
                anchorY: anchorY,
                loopFlags: loopFlags,
                seqFrames: seqFrames,
                seqDurations: seqDurations,
                seqTransforms: seqTransforms,
                variantSprites: variants
            )
        } catch {
            return nil
        }
    }
}
