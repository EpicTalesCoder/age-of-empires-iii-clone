// Port of h.java (h.a(int), h.a(String)) — Resource loader for *.res, *.dat, *.png
import Foundation

public final class GameAssets {
    public static var shared = GameAssets()

    private let explicitDirectory: URL?
    private let bundle: Bundle

    public init(bundle: Bundle = .main, directory: URL? = nil) {
        self.bundle = bundle
        self.explicitDirectory = directory
    }

    // Port of h.a(int id) — reads /{id & 0xFFFF}.res and skips the 4-byte res header
    public func loadResource(id: Int) -> Data? {
        if id == -1 { return nil }
        let fileId = id & 0xFFFF
        let upper = (id >> 16) & 0xFFFF
        guard upper == 0 else { return nil }
        guard let raw = loadRawFile(named: "\(fileId).res"), raw.count >= 4 else {
            return nil
        }
        return raw.subdata(in: 4..<raw.count)
    }

    // Port of h.a(String name) — reads /{name} verbatim
    public func loadRawFile(named filename: String) -> Data? {
        let clean = filename.hasPrefix("/") ? String(filename.dropFirst()) : filename
        if let dir = explicitDirectory {
            let direct = dir.appendingPathComponent(clean)
            if let data = try? Data(contentsOf: direct) {
                return data
            }
        }
        let ns = clean as NSString
        let stem = ns.deletingPathExtension
        let ext = ns.pathExtension
        if let url = bundle.url(forResource: stem, withExtension: ext, subdirectory: "GameAssets"),
           let data = try? Data(contentsOf: url) {
            return data
        }
        if let url = bundle.url(forResource: stem, withExtension: ext),
           let data = try? Data(contentsOf: url) {
            return data
        }
        if let resRoot = bundle.resourceURL {
            for candidate in [resRoot.appendingPathComponent("GameAssets").appendingPathComponent(clean),
                              resRoot.appendingPathComponent(clean)] {
                if let data = try? Data(contentsOf: candidate) {
                    return data
                }
            }
        }
        return nil
    }
}
