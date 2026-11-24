// Port of f localization loader (lang.dat, multi.dat), %U formatting, and f.a(String, int, int) word wrapper
import Foundation

public final class Localization {
    public private(set) var strings: [String] = []
    public private(set) var languages: [String] = []

    public init(assets: GameAssets = .shared) {
        loadLanguagePack(named: "lang.dat", assets: assets)
        loadMultiList(assets: assets)
    }

    // Port of f.b("lang.dat")
    public func loadLanguagePack(named filename: String, assets: GameAssets = .shared) {
        guard let data = assets.loadRawFile(named: filename) else { return }
        let r = BigEndianReader(data: data)
        do {
            let count = Int(try r.readInt())
            guard count >= 0, count < 10000 else { return }
            var loaded = [String]()
            loaded.reserveCapacity(count)
            for _ in 0..<count {
                loaded.append(try r.readUTF())
            }
            self.strings = loaded
        } catch {
            // Keep existing strings on parse failure
        }
    }

    public func loadMultiList(assets: GameAssets = .shared) {
        guard let data = assets.loadRawFile(named: "multi.dat") else { return }
        let r = BigEndianReader(data: data)
        do {
            let count = Int(try r.readInt())
            guard count >= 0, count < 100 else { return }
            var list = [String]()
            list.reserveCapacity(count)
            for _ in 0..<count {
                list.append(try r.readUTF())
            }
            self.languages = list
        } catch {}
    }

    // Port of f.a(int id)
    public func text(_ id: Int) -> String {
        guard id >= 0, id < strings.count else { return "" }
        return strings[id]
    }

    // Port of f.a(int id, String[] args) — replaces sequential "%U" markers
    public func format(_ id: Int, _ args: [String]) -> String {
        var result = text(id)
        for arg in args {
            if let range = result.range(of: "%U") {
                result.replaceSubrange(range, with: arg)
            } else {
                break
            }
        }
        return result
    }

    // Port of f.a(String text, int maxWidth, int fontId):[Ljava/lang/String;
    public func wrapText(_ input: String, maxWidth: Int, fontId: Int, font: BitmapFont) -> [String] {
        var lines = [String]()
        let paragraphs = input.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
        for paragraph in paragraphs {
            if paragraph.isEmpty {
                lines.append("")
                continue
            }
            var current = ""
            let words = paragraph.split(separator: " ", omittingEmptySubsequences: false).map(String.init)
            for (idx, word) in words.enumerated() {
                let candidate = current.isEmpty ? word : (current + " " + word)
                if font.stringWidth(fontId: fontId, text: candidate) <= maxWidth || current.isEmpty {
                    current = candidate
                } else {
                    lines.append(current)
                    current = word
                }
                if idx == words.count - 1 && !current.isEmpty {
                    lines.append(current)
                }
            }
        }
        return lines
    }
}
