// Port of f.a(byte[], byte[]):[B & CoreGraphics indexed PNG decoder (Evidence: f.javap.txt:4944)
import CoreGraphics
import Foundation
import ImageIO

public final class PixelSurface {
    public let width: Int
    public let height: Int
    // Straight (non-premultiplied) 0xAARRGGBB pixels or RGBA bytes stored as 0xAABBGGRR? Wait: let's store uniform 0xAARRGGBB in Swift!
    public var pixels: [UInt32]

    public init(width: Int, height: Int, fill: UInt32 = 0) {
        self.width = width
        self.height = height
        self.pixels = [UInt32](repeating: fill, count: max(0, width * height))
    }

    public init(width: Int, height: Int, pixels: [UInt32]) {
        self.width = width
        self.height = height
        self.pixels = pixels
    }

    // Decodes standard or PLTE-patched PNG bytes via CoreGraphics into ARGB8888 unpremultiplied/clean pixel buffer
    public static func decodePNG(data: Data) -> PixelSurface? {
        guard let provider = CGDataProvider(data: data as CFData),
              let cgImage = CGImage(
                pngDataProviderSource: provider,
                decode: nil,
                shouldInterpolate: false,
                intent: .defaultIntent
              ) else {
            return nil
        }
        let w = cgImage.width
        let h = cgImage.height
        guard w > 0, h > 0 else { return nil }
        var rgba = [UInt8](repeating: 0, count: w * h * 4)
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
        guard let ctx = CGContext(
            data: &rgba,
            width: w,
            height: h,
            bitsPerComponent: 8,
            bytesPerRow: w * 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            return nil
        }
        ctx.interpolationQuality = .none
        ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: w, height: h))

        var out = [UInt32](repeating: 0, count: w * h)
        for i in 0..<(w * h) {
            let base = i * 4
            let a = UInt32(rgba[base + 3])
            if a == 0 {
                out[i] = 0
            } else if a == 255 {
                let r = UInt32(rgba[base])
                let g = UInt32(rgba[base + 1])
                let b = UInt32(rgba[base + 2])
                out[i] = (0xFF00_0000) | (r << 16) | (g << 8) | b
            } else {
                // Un-premultiply cleanly for crisp overlay/cutout alpha
                let r = min(255, (UInt32(rgba[base]) * 255) / a)
                let g = min(255, (UInt32(rgba[base + 1]) * 255) / a)
                let b = min(255, (UInt32(rgba[base + 2]) * 255) / a)
                out[i] = (a << 24) | (r << 16) | (g << 8) | b
            }
        }
        return PixelSurface(width: w, height: h, pixels: out)
    }

    public func makeCGImage() -> CGImage? {
        guard width > 0, height > 0 else { return nil }
        var rgba = [UInt8](repeating: 0, count: width * height * 4)
        for i in 0..<pixels.count {
            let p = pixels[i]
            let a = UInt8((p >> 24) & 0xFF)
            let r = UInt8((p >> 16) & 0xFF)
            let g = UInt8((p >> 8) & 0xFF)
            let b = UInt8(p & 0xFF)
            let base = i * 4
            rgba[base] = r
            rgba[base + 1] = g
            rgba[base + 2] = b
            rgba[base + 3] = a == 0 ? 255 : a
        }
        let cfData = Data(rgba) as CFData
        guard let provider = CGDataProvider(data: cfData),
              let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else {
            return nil
        }
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.noneSkipLast.rawValue
        return CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: CGBitmapInfo(rawValue: bitmapInfo),
            provider: provider,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent
        )
    }
}

public enum PLTEPatcher {
    // Port of f.a(byte[] pngBytes, byte[] plteChunk):[B
    // Finds "PLTE" chunk inside PNG, swaps [chunkLength + "PLTE" + data + CRC] with plteChunk.
    public static func replacePLTE(pngData: Data, plteChunk: Data) -> Data {
        let bytes = [UInt8](pngData)
        guard bytes.count >= 37 else { return pngData }
        var plteTypeOffset = 37
        var found = false
        for i in 0..<(bytes.count - 4) {
            if bytes[i] == 80 && bytes[i + 1] == 76 && bytes[i + 2] == 84 && bytes[i + 3] == 69 {
                plteTypeOffset = i
                found = true
                break
            }
        }
        guard found, plteTypeOffset >= 4 else { return pngData }
        let chunkStart = plteTypeOffset - 4
        let chunkDataLen = (Int(bytes[chunkStart]) << 24)
            | (Int(bytes[chunkStart + 1]) << 16)
            | (Int(bytes[chunkStart + 2]) << 8)
            | Int(bytes[chunkStart + 3])
        let chunkEnd = chunkStart + 4 + 4 + chunkDataLen + 4
        guard chunkEnd <= bytes.count else { return pngData }

        var result = Data()
        result.reserveCapacity(bytes.count - (chunkEnd - chunkStart) + plteChunk.count)
        result.append(contentsOf: bytes[0..<chunkStart])
        result.append(plteChunk)
        result.append(contentsOf: bytes[chunkEnd..<bytes.count])
        return result
    }
}
