// Port of l.java & c.java font subsystem (0.res bitmap atlas + 1.res metrics + system small font fallback)
import CoreGraphics
import CoreText
import Foundation

public struct Anchor {
    public static let hcenter = 1
    public static let vcenter = 2
    public static let left = 4
    public static let right = 8
    public static let top = 16
    public static let bottom = 32
    public static let baseline = 64
}

public final class BitmapFont {
    // Port of c.a, c.b, c.c, c.d font descriptor tables (c.<clinit>() lines 282-310)
    // Font 0: bitmap font (0.res PNG + 1.res metrics); Font 1: system small font (-2 = white w/ black shadow)
    public static let styleTypes: [Int] = [0, 1]
    public static let styleParams: [Int] = [0, -1, 0, -2]

    public struct MetricFont {
        public let charGap: Int
        public let spaceWidth: Int
        public let lineHeight: Int
        public let baselineOffset: Int
        public let chars: [Character]
        public let widths: [Int]
        public let glyphs: [GameSprite]
    }

    public private(set) var bitmapFont0: MetricFont?
    public let systemCTFont: CTFont
    public var lineHeights: [Int] = [17, 15]
    public var baselines: [Int] = [17, 13]
    public var wideWidths: [Int] = [11, 10]

    public init(assets: GameAssets = .shared) {
        self.systemCTFont = CTFontCreateWithName("HelveticaNeue-Medium" as CFString, 12.0, nil)
        loadSystemMetrics()
        loadBitmapFont(fontId: 0, assets: assets)
    }

    private func loadSystemMetrics() {
        var ascent: CGFloat = 0
        var descent: CGFloat = 0
        var leading: CGFloat = 0
        let sampleAttr = NSAttributedString(
            string: "W",
            attributes: [NSAttributedString.Key(kCTFontAttributeName as String): systemCTFont]
        )
        let sampleLine = CTLineCreateWithAttributedString(sampleAttr)
        let w = CTLineGetTypographicBounds(sampleLine, &ascent, &descent, &leading)
        lineHeights[1] = Int(ceil(ascent + descent)) + 1
        baselines[1] = Int(ceil(ascent))
        wideWidths[1] = max(8, Int(ceil(w)))
    }

    // Port of l.a(int p0) (l.pseudo.java:22-98)
    public func loadBitmapFont(fontId: Int, assets: GameAssets = .shared) {
        guard fontId == 0, bitmapFont0 == nil else { return }
        guard let metricsData = assets.loadResource(id: 1),
              let pngData = assets.loadResource(id: 0),
              let atlas = GameSprite(pngData: pngData) else {
            return
        }
        let r = BigEndianReader(data: metricsData)
        do {
            let charGap = Int(try r.readByte())
            let spaceW = Int(try r.readByte())
            let lineH = Int(try r.readByte())
            let descOffset = Int(try r.readByte())
            let count = try r.readUnsignedByte()
            let utf = try r.readUTF()
            let chars = Array(utf)
            var widths = [Int]()
            widths.reserveCapacity(count)
            for _ in 0..<count {
                widths.append(Int(try r.readByte()))
            }
            var xy = [Int]()
            xy.reserveCapacity(count * 2)
            for _ in 0..<(count * 2) {
                xy.append(Int(try r.readShort()))
            }
            var glyphs = [GameSprite]()
            glyphs.reserveCapacity(count)
            for idx in 0..<count {
                let gw = widths[idx]
                let gx = xy[idx * 2]
                let gy = xy[idx * 2 + 1]
                glyphs.append(GameSprite(surface: atlas.surface, srcX: gx, srcY: gy, width: gw, height: lineH))
            }
            self.bitmapFont0 = MetricFont(
                charGap: charGap,
                spaceWidth: spaceW,
                lineHeight: lineH,
                baselineOffset: lineH - descOffset,
                chars: chars,
                widths: widths,
                glyphs: glyphs
            )
            lineHeights[0] = lineH
            baselines[0] = lineH - descOffset
            wideWidths[0] = widths.first ?? spaceW
        } catch {
            // Leave nil fallback to system font if malformed
        }
    }

    public func isBitmapLoaded(_ fontId: Int) -> Bool {
        return fontId == 0 && bitmapFont0 != nil
    }

    // Port of l.a(int p0, char ch):I binary search
    public func glyphIndex(for ch: Character) -> Int {
        guard let bf = bitmapFont0 else { return -1 }
        var lo = 0
        var hi = bf.chars.count - 1
        while lo <= hi {
            let mid = (lo + hi) >> 1
            let mc = bf.chars[mid]
            if mc == ch { return mid }
            if mc < ch { lo = mid + 1 } else { hi = mid - 1 }
        }
        return -1
    }

    // Port of l.a(int fontId, String text):I
    public func stringWidth(fontId: Int, text: String) -> Int {
        let fid = (fontId == 0 && bitmapFont0 != nil) ? 0 : 1
        if fid == 0, let bf = bitmapFont0 {
            var total = 0
            for ch in text {
                if ch == " " {
                    total += bf.spaceWidth
                } else {
                    let idx = glyphIndex(for: ch)
                    if idx >= 0 {
                        total += bf.widths[idx] + bf.charGap
                    } else {
                        total += bf.spaceWidth
                    }
                }
            }
            return total
        } else {
            let attr = NSAttributedString(
                string: text,
                attributes: [NSAttributedString.Key(kCTFontAttributeName as String): systemCTFont]
            )
            let line = CTLineCreateWithAttributedString(attr)
            return Int(ceil(CTLineGetTypographicBounds(line, nil, nil, nil)))
        }
    }
}
