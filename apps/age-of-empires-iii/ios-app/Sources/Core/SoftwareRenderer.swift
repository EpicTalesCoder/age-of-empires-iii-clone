// Port of javax.microedition.lcdui.Graphics & l / k rendering on crisp 360x400 ARGB surface
import CoreGraphics
import CoreText
import Foundation

public final class SoftwareRenderer {
    public let width: Int
    public let height: Int
    public let surface: PixelSurface

    public private(set) var currentColor: UInt32 = 0xFF00_0000
    public private(set) var clipX: Int = 0
    public private(set) var clipY: Int = 0
    public private(set) var clipW: Int
    public private(set) var clipH: Int

    private var savedClip: (Int, Int, Int, Int)?
    public var bitmapFont: BitmapFont

    public init(width: Int = XSMaxLayout.gameLogicalWidth, height: Int = XSMaxLayout.gameLogicalHeight, font: BitmapFont) {
        self.width = width
        self.height = height
        self.clipW = width
        self.clipH = height
        self.surface = PixelSurface(width: width, height: height, fill: 0xFF00_0000)
        self.bitmapFont = font
    }

    public func setColor(_ rgb: Int) {
        currentColor = 0xFF00_0000 | UInt32(rgb & 0x00FF_FFFF)
    }

    public func setClip(_ x: Int, _ y: Int, _ w: Int, _ h: Int) {
        let x0 = max(0, x)
        let y0 = max(0, y)
        let x1 = min(width, x + w)
        let y1 = min(height, y + h)
        clipX = x0
        clipY = y0
        clipW = max(0, x1 - x0)
        clipH = max(0, y1 - y0)
    }

    public func resetClip() {
        clipX = 0
        clipY = 0
        clipW = width
        clipH = height
    }

    // Port of f.b(Graphics) / f.a(Graphics) clip push/pop
    public func pushClipAndSetFullWidth(height h: Int) {
        savedClip = (clipX, clipY, clipW, clipH)
        setClip(0, 0, width, h)
    }

    public func popClip() {
        if let s = savedClip {
            clipX = s.0; clipY = s.1; clipW = s.2; clipH = s.3
            savedClip = nil
        } else {
            resetClip()
        }
    }

    @inline(__always)
    private func plotClipped(_ x: Int, _ y: Int, color: UInt32) {
        if x >= clipX && x < clipX + clipW && y >= clipY && y < clipY + clipH {
            surface.pixels[y * width + x] = color
        }
    }

    public func fillRect(_ x: Int, _ y: Int, _ w: Int, _ h: Int) {
        guard w > 0, h > 0 else { return }
        let x0 = max(clipX, x)
        let y0 = max(clipY, y)
        let x1 = min(clipX + clipW, x + w)
        let y1 = min(clipY + clipH, y + h)
        guard x0 < x1, y0 < y1 else { return }
        for py in y0..<y1 {
            let rowStart = py * width
            for px in x0..<x1 {
                surface.pixels[rowStart + px] = currentColor
            }
        }
    }

    public func drawRect(_ x: Int, _ y: Int, _ w: Int, _ h: Int) {
        guard w >= 0, h >= 0 else { return }
        fillRect(x, y, w + 1, 1)
        fillRect(x, y + h, w + 1, 1)
        fillRect(x, y, 1, h + 1)
        fillRect(x + w, y, 1, h + 1)
    }

    public func drawLine(_ x0: Int, _ y0: Int, _ x1: Int, _ y1: Int) {
        var cx = x0
        var cy = y0
        let dx = abs(x1 - x0)
        let sx = x0 < x1 ? 1 : -1
        let dy = -abs(y1 - y0)
        let sy = y0 < y1 ? 1 : -1
        var err = dx + dy
        while true {
            plotClipped(cx, cy, color: currentColor)
            if cx == x1 && cy == y1 { break }
            let e2 = 2 * err
            if e2 >= dy { err += dy; cx += sx }
            if e2 <= dx { err += dx; cy += sy }
        }
    }

    public func fillTriangle(_ x1: Int, _ y1: Int, _ x2: Int, _ y2: Int, _ x3: Int, _ y3: Int) {
        var vx = [x1, x2, x3]
        var vy = [y1, y2, y3]
        if vy[0] > vy[1] { vx.swapAt(0, 1); vy.swapAt(0, 1) }
        if vy[0] > vy[2] { vx.swapAt(0, 2); vy.swapAt(0, 2) }
        if vy[1] > vy[2] { vx.swapAt(1, 2); vy.swapAt(1, 2) }
        let totalHeight = vy[2] - vy[0]
        guard totalHeight > 0 else { return }
        for i in 0..<totalHeight {
            let secondHalf = i > vy[1] - vy[0] || vy[1] == vy[0]
            let segHeight = secondHalf ? (vy[2] - vy[1]) : (vy[1] - vy[0])
            guard segHeight > 0 else { continue }
            let alpha = Double(i) / Double(totalHeight)
            let beta = Double(i - (secondHalf ? (vy[1] - vy[0]) : 0)) / Double(segHeight)
            var ax = Int(Double(vx[0]) + Double(vx[2] - vx[0]) * alpha)
            var bx = secondHalf
                ? Int(Double(vx[1]) + Double(vx[2] - vx[1]) * beta)
                : Int(Double(vx[0]) + Double(vx[1] - vx[0]) * beta)
            if ax > bx { swap(&ax, &bx) }
            let py = vy[0] + i
            if py >= clipY && py < clipY + clipH {
                let startX = max(clipX, ax)
                let endX = min(clipX + clipW - 1, bx)
                if startX <= endX {
                    let row = py * width
                    for px in startX...endX {
                        surface.pixels[row + px] = currentColor
                    }
                }
            }
        }
    }

    // Port of k.a(Graphics, int x, int y, int transform, int anchor)
    public func drawSprite(_ sprite: GameSprite, x: Int, y: Int, transform: Int? = nil, anchor: Int = Anchor.top | Anchor.left) {
        let tr = transform ?? sprite.defaultTransform
        let swapsAxes = (tr == SpriteTransform.rot90 || tr == SpriteTransform.rot270
            || tr == SpriteTransform.mirrorRot90 || tr == SpriteTransform.mirrorRot270)
        let destW = swapsAxes ? sprite.height : sprite.width
        let destH = swapsAxes ? sprite.width : sprite.height
        guard destW > 0, destH > 0 else { return }

        var dx0 = x
        if (anchor & Anchor.hcenter) != 0 { dx0 -= destW >> 1 }
        else if (anchor & Anchor.right) != 0 { dx0 -= destW }

        var dy0 = y
        if (anchor & Anchor.vcenter) != 0 { dy0 -= destH >> 1 }
        else if (anchor & Anchor.bottom) != 0 { dy0 -= destH }

        let xStart = max(clipX, dx0)
        let yStart = max(clipY, dy0)
        let xEnd = min(clipX + clipW, dx0 + destW)
        let yEnd = min(clipY + clipH, dy0 + destH)
        guard xStart < xEnd, yStart < yEnd else { return }

        let srcPixels = sprite.surface.pixels
        let srcSurfW = sprite.surface.width
        let sw = sprite.width
        let sh = sprite.height

        for py in yStart..<yEnd {
            let ly = py - dy0
            let destRow = py * width
            for px in xStart..<xEnd {
                let lx = px - dx0
                let sxRel: Int
                let syRel: Int
                switch tr {
                case SpriteTransform.mirror:
                    sxRel = sw - 1 - lx; syRel = ly
                case SpriteTransform.mirrorRot180:
                    sxRel = lx; syRel = sh - 1 - ly
                case SpriteTransform.rot180:
                    sxRel = sw - 1 - lx; syRel = sh - 1 - ly
                case SpriteTransform.rot90:
                    sxRel = ly; syRel = sh - 1 - lx
                case SpriteTransform.rot270:
                    sxRel = sw - 1 - ly; syRel = lx
                case SpriteTransform.mirrorRot270:
                    sxRel = ly; syRel = lx
                case SpriteTransform.mirrorRot90:
                    sxRel = sw - 1 - ly; syRel = sh - 1 - lx
                default:
                    sxRel = lx; syRel = ly
                }
                let sp = srcPixels[(sprite.srcY + syRel) * srcSurfW + (sprite.srcX + sxRel)]
                let alpha = (sp >> 24) & 0xFF
                if alpha == 0 { continue }
                if alpha == 255 {
                    surface.pixels[destRow + px] = sp
                } else {
                    let dst = surface.pixels[destRow + px]
                    let inv = 255 - alpha
                    let sr = (sp >> 16) & 0xFF, sg = (sp >> 8) & 0xFF, sb = sp & 0xFF
                    let dr = (dst >> 16) & 0xFF, dg = (dst >> 8) & 0xFF, db = dst & 0xFF
                    let r = (sr * alpha + dr * inv) / 255
                    let g = (sg * alpha + dg * inv) / 255
                    let b = (sb * alpha + db * inv) / 255
                    surface.pixels[destRow + px] = 0xFF00_0000 | (r << 16) | (g << 8) | b
                }
            }
        }
    }

    // Port of l.a(int fontId, Graphics g, String text, int x, int y, int anchor)
    public func drawString(fontId: Int, _ text: String, x: Int, y: Int, anchor: Int = Anchor.top | Anchor.left) {
        let fid = (fontId == 0 && bitmapFont.isBitmapLoaded(0)) ? 0 : 1
        var drawX = x
        var drawY = y
        let w = bitmapFont.stringWidth(fontId: fid, text: text)
        let lineH = bitmapFont.lineHeights[fid]
        let baseOff = bitmapFont.baselines[fid]

        if (anchor & Anchor.hcenter) != 0 { drawX -= w >> 1 }
        else if (anchor & Anchor.right) != 0 { drawX -= w }

        if (anchor & Anchor.bottom) != 0 { drawY -= lineH }
        else if (anchor & Anchor.baseline) != 0 { drawY -= baseOff }
        else if (anchor & Anchor.vcenter) != 0 { drawY -= lineH >> 1 }

        if fid == 0, let bf = bitmapFont.bitmapFont0 {
            var cx = drawX
            for ch in text {
                if ch == " " {
                    cx += bf.spaceWidth
                    continue
                }
                let idx = bitmapFont.glyphIndex(for: ch)
                if idx >= 0 {
                    drawSprite(bf.glyphs[idx], x: cx, y: drawY, transform: 0, anchor: Anchor.top | Anchor.left)
                    cx += bf.widths[idx] + bf.charGap
                } else {
                    cx += bf.spaceWidth
                }
            }
        } else {
            let styleColor = BitmapFont.styleParams[min(BitmapFont.styleParams.count - 1, fid * 2 + 1)]
            if styleColor == -2 {
                drawSystemText(text, x: drawX + 1, y: drawY + 1, argb: 0xFF00_0000)
                drawSystemText(text, x: drawX, y: drawY, argb: 0xFFFF_FFFF)
            } else if styleColor == -1 {
                drawSystemText(text, x: drawX, y: drawY, argb: currentColor)
            } else {
                drawSystemText(text, x: drawX, y: drawY, argb: 0xFF00_0000 | UInt32(styleColor & 0x00FF_FFFF))
            }
        }
    }

    private func drawSystemText(_ text: String, x: Int, y: Int, argb: UInt32) {
        guard !text.isEmpty else { return }
        let r = CGFloat((argb >> 16) & 0xFF) / 255.0
        let g = CGFloat((argb >> 8) & 0xFF) / 255.0
        let b = CGFloat(argb & 0xFF) / 255.0
        let cgColor = CGColor(red: r, green: g, blue: b, alpha: 1.0)
        let attr = NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key(kCTFontAttributeName as String): bitmapFont.systemCTFont,
                NSAttributedString.Key(kCTForegroundColorAttributeName as String): cgColor
            ]
        )
        let line = CTLineCreateWithAttributedString(attr)
        let w = max(1, Int(ceil(CTLineGetTypographicBounds(line, nil, nil, nil))) + 4)
        let h = max(1, bitmapFont.lineHeights[1] + 2)
        var buf = [UInt8](repeating: 0, count: w * h * 4)
        guard let cs = CGColorSpace(name: CGColorSpace.sRGB),
              let ctx = CGContext(
                data: &buf,
                width: w,
                height: h,
                bitsPerComponent: 8,
                bytesPerRow: w * 4,
                space: cs,
                bitmapInfo: CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
              ) else { return }
        ctx.textMatrix = .identity
        ctx.textPosition = CGPoint(x: 0, y: CGFloat(h - bitmapFont.baselines[1]))
        CTLineDraw(line, ctx)

        let cr = (argb >> 16) & 0xFF
        let cg = (argb >> 8) & 0xFF
        let cb = argb & 0xFF
        for py in 0..<h {
            let destY = y + py
            guard destY >= clipY && destY < clipY + clipH else { continue }
            for px in 0..<w {
                let destX = x + px
                guard destX >= clipX && destX < clipX + clipW else { continue }
                let a = UInt32(buf[(py * w + px) * 4 + 3])
                if a == 0 { continue }
                let idx = destY * width + destX
                if a >= 200 {
                    surface.pixels[idx] = 0xFF00_0000 | (cr << 16) | (cg << 8) | cb
                } else {
                    let dst = surface.pixels[idx]
                    let inv = 255 - a
                    let rr = (cr * a + ((dst >> 16) & 0xFF) * inv) / 255
                    let gg = (cg * a + ((dst >> 8) & 0xFF) * inv) / 255
                    let bb = (cb * a + (dst & 0xFF) * inv) / 255
                    surface.pixels[idx] = 0xFF00_0000 | (rr << 16) | (gg << 8) | bb
                }
            }
        }
    }
}
