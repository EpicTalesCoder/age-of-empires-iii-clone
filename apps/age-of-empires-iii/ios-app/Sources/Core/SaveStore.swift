// Port of f RecordStore "aoe3" binary persistence (records 1..5 in Application Support/aoe3)
import Foundation

public struct SettingsSaveData: Equatable {
    public var soundEnabled: Bool = true
    public var vibrationEnabled: Bool = true
    public var hintsEnabled: Bool = true
    public var maxUnlockedCampaign: Int = 1 // Mission index unlocked (1..15)
    public var completedCampaignMask: Int = 0
}

public final class SaveStore {
    public static let storeName = "aoe3"
    public let baseDirectory: URL

    public init(directory: URL? = nil) {
        if let dir = directory {
            self.baseDirectory = dir
        } else {
            let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
                ?? FileManager.default.temporaryDirectory
            self.baseDirectory = appSupport.appendingPathComponent(Self.storeName, isDirectory: true)
        }
        try? FileManager.default.createDirectory(at: baseDirectory, withIntermediateDirectories: true)
    }

    private func recordURL(id: Int) -> URL {
        return baseDirectory.appendingPathComponent("record_\(id).bin")
    }

    public func saveSettings(_ settings: SettingsSaveData) {
        let w = BigEndianWriter()
        w.writeBool(settings.soundEnabled)
        w.writeBool(settings.vibrationEnabled)
        w.writeBool(settings.hintsEnabled)
        w.writeByte(Int8(clamping: settings.maxUnlockedCampaign))
        w.writeInt32(settings.completedCampaignMask)
        try? w.data.write(to: recordURL(id: 1), options: .atomic)
    }

    public func loadSettings() -> SettingsSaveData {
        guard let data = try? Data(contentsOf: recordURL(id: 1)) else {
            return SettingsSaveData()
        }
        let r = BigEndianReader(data: data)
        var s = SettingsSaveData()
        do {
            s.soundEnabled = try r.readBool()
            s.vibrationEnabled = try r.readBool()
            s.hintsEnabled = try r.readBool()
            s.maxUnlockedCampaign = max(1, Int(try r.readByte()))
            s.completedCampaignMask = Int(try r.readInt())
        } catch {}
        return s
    }

    // Slots 0..2 map to RMS records 2..4
    public func hasSlot(_ slot: Int) -> Bool {
        guard slot >= 0, slot < 3 else { return false }
        return FileManager.default.fileExists(atPath: recordURL(id: slot + 2).path)
    }

    public func slotSummary(_ slot: Int) -> String? {
        guard let data = loadSlotData(slot), !data.isEmpty else { return nil }
        let r = BigEndianReader(data: data)
        return try? r.readUTF()
    }

    public func saveSlotData(_ slot: Int, data: Data) {
        guard slot >= 0, slot < 3 else { return }
        try? data.write(to: recordURL(id: slot + 2), options: .atomic)
    }

    public func loadSlotData(_ slot: Int) -> Data? {
        guard slot >= 0, slot < 3 else { return nil }
        return try? Data(contentsOf: recordURL(id: slot + 2))
    }

    public func deleteSlot(_ slot: Int) {
        guard slot >= 0, slot < 3 else { return }
        try? FileManager.default.removeItem(at: recordURL(id: slot + 2))
    }
}
