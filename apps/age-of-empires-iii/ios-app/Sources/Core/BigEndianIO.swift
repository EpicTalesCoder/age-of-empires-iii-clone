// Port of java.io.DataInputStream / DataOutputStream & f.a array IO helpers (f.pseudo.java:2866-3300)
import Foundation

public enum BigEndianIOError: Error {
    case unexpectedEOF
    case invalidUTF8
    case negativeLength(Int)
}

public final class BigEndianReader {
    private let bytes: [UInt8]
    public private(set) var offset: Int = 0

    public var remaining: Int { max(0, bytes.count - offset) }

    public init(data: Data) {
        self.bytes = [UInt8](data)
    }

    public func readByte() throws -> Int8 {
        guard offset < bytes.count else { throw BigEndianIOError.unexpectedEOF }
        let v = Int8(bitPattern: bytes[offset])
        offset += 1
        return v
    }

    public func readUnsignedByte() throws -> Int {
        guard offset < bytes.count else { throw BigEndianIOError.unexpectedEOF }
        let v = Int(bytes[offset])
        offset += 1
        return v
    }

    public func readBool() throws -> Bool {
        return try readUnsignedByte() != 0
    }

    public func readShort() throws -> Int16 {
        guard offset + 2 <= bytes.count else { throw BigEndianIOError.unexpectedEOF }
        let raw = (UInt16(bytes[offset]) << 8) | UInt16(bytes[offset + 1])
        offset += 2
        return Int16(bitPattern: raw)
    }

    public func readUnsignedShort() throws -> Int {
        guard offset + 2 <= bytes.count else { throw BigEndianIOError.unexpectedEOF }
        let raw = (Int(bytes[offset]) << 8) | Int(bytes[offset + 1])
        offset += 2
        return raw
    }

    public func readInt() throws -> Int32 {
        guard offset + 4 <= bytes.count else { throw BigEndianIOError.unexpectedEOF }
        let raw = (UInt32(bytes[offset]) << 24)
            | (UInt32(bytes[offset + 1]) << 16)
            | (UInt32(bytes[offset + 2]) << 8)
            | UInt32(bytes[offset + 3])
        offset += 4
        return Int32(bitPattern: raw)
    }

    public func readBytes(_ count: Int) throws -> Data {
        guard count >= 0 else { throw BigEndianIOError.negativeLength(count) }
        guard offset + count <= bytes.count else { throw BigEndianIOError.unexpectedEOF }
        let slice = Data(bytes[offset..<(offset + count)])
        offset += count
        return slice
    }

    // Port of DataInputStream.readUTF()
    public func readUTF() throws -> String {
        let len = try readUnsignedShort()
        let raw = try readBytes(len)
        // Standard UTF-8 (DataOutputStream modified UTF-8 matches UTF-8 for BMP & ASCII; \xC0\x80 is NUL if present)
        if let str = String(data: raw, encoding: .utf8) {
            return str
        }
        return String(decoding: raw, as: UTF8.self)
    }

    // Port of f.a(DataInputStream, boolean):[B
    public func readByteArray(shortLength: Bool = false) throws -> [Int8] {
        let len = shortLength ? Int(try readShort()) : Int(try readByte())
        guard len >= 0 else { throw BigEndianIOError.negativeLength(len) }
        var out = [Int8]()
        out.reserveCapacity(len)
        for _ in 0..<len {
            out.append(try readByte())
        }
        return out
    }

    // Port of f.a(DataInputStream):[[B
    public func readByteMatrix() throws -> [[Int8]?] {
        let len = Int(try readByte())
        guard len >= 0 else { throw BigEndianIOError.negativeLength(len) }
        var out = [[Int8]?]()
        out.reserveCapacity(len)
        for _ in 0..<len {
            let subLen = Int(try readByte())
            if subLen > 0 {
                var sub = [Int8]()
                sub.reserveCapacity(subLen)
                for _ in 0..<subLen {
                    sub.append(try readByte())
                }
                out.append(sub)
            } else {
                out.append(nil)
            }
        }
        return out
    }

    // Port of f.a(DataInputStream):[S
    public func readShortArray() throws -> [Int16] {
        let len = Int(try readShort())
        guard len >= 0 else { throw BigEndianIOError.negativeLength(len) }
        var out = [Int16]()
        out.reserveCapacity(len)
        for _ in 0..<len {
            out.append(try readShort())
        }
        return out
    }

    // Port of f.a(DataInputStream):[[S
    public func readShortMatrix() throws -> [[Int16]?] {
        let len = Int(try readShort())
        guard len >= 0 else { throw BigEndianIOError.negativeLength(len) }
        var out = [[Int16]?]()
        out.reserveCapacity(len)
        for _ in 0..<len {
            let subLen = Int(try readShort())
            if subLen > 0 {
                var sub = [Int16]()
                sub.reserveCapacity(subLen)
                for _ in 0..<subLen {
                    sub.append(try readShort())
                }
                out.append(sub)
            } else {
                out.append(nil)
            }
        }
        return out
    }

    // Port of f.a(DataInputStream):[I
    public func readIntArray() throws -> [Int32] {
        let len = Int(try readInt())
        guard len >= 0 else { throw BigEndianIOError.negativeLength(len) }
        var out = [Int32]()
        out.reserveCapacity(len)
        for _ in 0..<len {
            out.append(try readInt())
        }
        return out
    }

    // Port of f.a(DataInputStream):[[I
    public func readIntMatrix() throws -> [[Int32]?] {
        let len = Int(try readInt())
        guard len >= 0 else { throw BigEndianIOError.negativeLength(len) }
        var out = [[Int32]?]()
        out.reserveCapacity(len)
        for _ in 0..<len {
            let subLen = Int(try readInt())
            if subLen > 0 {
                var sub = [Int32]()
                sub.reserveCapacity(subLen)
                for _ in 0..<subLen {
                    sub.append(try readInt())
                }
                out.append(sub)
            } else {
                out.append(nil)
            }
        }
        return out
    }

    // Save-format helpers (nullable byte-prefixed arrays matching f.b / f.a serialization)
    public func readNullableIntArray() throws -> [Int]? {
        let len = Int(try readByte())
        if len == -1 { return nil }
        guard len >= 0 else { return nil }
        var out = [Int]()
        out.reserveCapacity(len)
        for _ in 0..<len { out.append(Int(try readInt())) }
        return out
    }

    public func readNullableShortArray() throws -> [Int]? {
        let len = Int(try readByte())
        if len == -1 { return nil }
        guard len >= 0 else { return nil }
        var out = [Int]()
        out.reserveCapacity(len)
        for _ in 0..<len { out.append(Int(try readShort())) }
        return out
    }

    public func readNullableIntMatrix() throws -> [[Int]?]? {
        let len = Int(try readByte())
        if len == -1 { return nil }
        guard len >= 0 else { return nil }
        var out = [[Int]?]()
        out.reserveCapacity(len)
        for _ in 0..<len { out.append(try readNullableIntArray()) }
        return out
    }

    public func readNullableBoolArray() throws -> [Bool]? {
        let len = Int(try readShort())
        if len == -1 { return nil }
        guard len >= 0 else { return nil }
        var out = [Bool]()
        out.reserveCapacity(len)
        for _ in 0..<len { out.append(try readBool()) }
        return out
    }

    public func readNullableShortBytes() throws -> Data? {
        let len = Int(try readShort())
        if len == -1 { return nil }
        return try readBytes(len)
    }
}

public final class BigEndianWriter {
    public private(set) var bytes = [UInt8]()

    public init() {}

    public var data: Data { Data(bytes) }

    public func writeByte(_ v: Int8) {
        bytes.append(UInt8(bitPattern: v))
    }

    public func writeIntByte(_ v: Int) {
        bytes.append(UInt8(truncatingIfNeeded: v))
    }

    public func writeBool(_ v: Bool) {
        bytes.append(v ? 1 : 0)
    }

    public func writeShort(_ v: Int16) {
        let u = UInt16(bitPattern: v)
        bytes.append(UInt8((u >> 8) & 0xFF))
        bytes.append(UInt8(u & 0xFF))
    }

    public func writeIntShort(_ v: Int) {
        writeShort(Int16(truncatingIfNeeded: v))
    }

    public func writeInt(_ v: Int32) {
        let u = UInt32(bitPattern: v)
        bytes.append(UInt8((u >> 24) & 0xFF))
        bytes.append(UInt8((u >> 16) & 0xFF))
        bytes.append(UInt8((u >> 8) & 0xFF))
        bytes.append(UInt8(u & 0xFF))
    }

    public func writeInt32(_ v: Int) {
        writeInt(Int32(truncatingIfNeeded: v))
    }

    public func writeData(_ data: Data) {
        bytes.append(contentsOf: data)
    }

    public func writeUTF(_ str: String) {
        let utf8 = [UInt8](str.utf8)
        let len = min(utf8.count, 65535)
        bytes.append(UInt8((len >> 8) & 0xFF))
        bytes.append(UInt8(len & 0xFF))
        bytes.append(contentsOf: utf8.prefix(len))
    }

    public func writeNullableIntArray(_ arr: [Int]?) {
        guard let arr = arr else { writeIntByte(-1); return }
        writeIntByte(arr.count)
        for v in arr { writeInt32(v) }
    }

    public func writeNullableShortArray(_ arr: [Int]?) {
        guard let arr = arr else { writeIntByte(-1); return }
        writeIntByte(arr.count)
        for v in arr { writeIntShort(v) }
    }

    public func writeNullableIntMatrix(_ mat: [[Int]?]?) {
        guard let mat = mat else { writeIntByte(-1); return }
        writeIntByte(mat.count)
        for row in mat { writeNullableIntArray(row) }
    }

    public func writeNullableBoolArray(_ arr: [Bool]?) {
        guard let arr = arr else { writeIntShort(-1); return }
        writeIntShort(arr.count)
        for b in arr { writeBool(b) }
    }

    public func writeNullableShortBytes(_ data: Data?) {
        guard let data = data else { writeIntShort(-1); return }
        writeIntShort(data.count)
        writeData(data)
    }
}
