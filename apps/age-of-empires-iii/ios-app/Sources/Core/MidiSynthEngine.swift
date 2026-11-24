// Port of a.java (MIDI Music Player a.a=[4,2,3,5], a.b[0..12]) using SMF parser + AVAudioEngine polyphonic synth
import AVFoundation
import Foundation

public struct MidiNoteEvent {
    public let timeSec: Double
    public let channel: Int
    public let isNoteOn: Bool
    public let note: Int
    public let velocity: Int
    public let program: Int
}

public struct ParsedMidiSequence {
    public let division: Int
    public let events: [MidiNoteEvent]
    public let durationSec: Double

    public static func parse(data: Data) -> ParsedMidiSequence? {
        let bytes = [UInt8](data)
        guard bytes.count >= 14,
              bytes[0] == 0x4D, bytes[1] == 0x54, bytes[2] == 0x68, bytes[3] == 0x64 else {
            return nil
        }
        let headerLen = Int(bytes[4]) << 24 | Int(bytes[5]) << 16 | Int(bytes[6]) << 8 | Int(bytes[7])
        let nTracks = Int(bytes[10]) << 8 | Int(bytes[11])
        let division = max(1, Int(bytes[12]) << 8 | Int(bytes[13]))
        var pos = 8 + headerLen

        struct RawEvent {
            let tick: Int
            let kind: Int // 0 = tempo, 1 = noteOn, 2 = noteOff, 3 = prog
            let ch: Int
            let a: Int
            let b: Int
        }
        var rawEvents = [RawEvent]()

        for _ in 0..<nTracks {
            guard pos + 8 <= bytes.count else { break }
            guard bytes[pos] == 0x4D, bytes[pos + 1] == 0x54, bytes[pos + 2] == 0x72, bytes[pos + 3] == 0x6B else {
                break
            }
            let trkLen = Int(bytes[pos + 4]) << 24 | Int(bytes[pos + 5]) << 16 | Int(bytes[pos + 6]) << 8 | Int(bytes[pos + 7])
            pos += 8
            let endPos = min(bytes.count, pos + trkLen)
            var cur = pos
            var tick = 0
            var runningStatus: UInt8 = 0

            func readVLQ() -> Int {
                var val = 0
                while cur < endPos {
                    let b = bytes[cur]
                    cur += 1
                    val = (val << 7) | Int(b & 0x7F)
                    if (b & 0x80) == 0 { break }
                }
                return val
            }

            while cur < endPos {
                tick += readVLQ()
                guard cur < endPos else { break }
                var status = bytes[cur]
                if (status & 0x80) != 0 {
                    cur += 1
                    if status < 0xF0 { runningStatus = status }
                } else {
                    status = runningStatus
                }

                if status == 0xFF {
                    guard cur < endPos else { break }
                    let metaType = bytes[cur]; cur += 1
                    let mLen = readVLQ()
                    if metaType == 0x51, mLen == 3, cur + 3 <= endPos {
                        let usPerQuarter = (Int(bytes[cur]) << 16) | (Int(bytes[cur + 1]) << 8) | Int(bytes[cur + 2])
                        rawEvents.append(RawEvent(tick: tick, kind: 0, ch: 0, a: max(100_000, usPerQuarter), b: 0))
                    }
                    cur = min(endPos, cur + mLen)
                } else if status == 0xF0 || status == 0xF7 {
                    let sLen = readVLQ()
                    cur = min(endPos, cur + sLen)
                } else {
                    let hi = status & 0xF0
                    let ch = Int(status & 0x0F)
                    switch hi {
                    case 0x80:
                        guard cur + 2 <= endPos else { cur = endPos; break }
                        let n = Int(bytes[cur]); let v = Int(bytes[cur + 1]); cur += 2
                        rawEvents.append(RawEvent(tick: tick, kind: 2, ch: ch, a: n, b: v))
                    case 0x90:
                        guard cur + 2 <= endPos else { cur = endPos; break }
                        let n = Int(bytes[cur]); let v = Int(bytes[cur + 1]); cur += 2
                        rawEvents.append(RawEvent(tick: tick, kind: v > 0 ? 1 : 2, ch: ch, a: n, b: v))
                    case 0xC0:
                        guard cur + 1 <= endPos else { cur = endPos; break }
                        let prog = Int(bytes[cur]); cur += 1
                        rawEvents.append(RawEvent(tick: tick, kind: 3, ch: ch, a: prog, b: 0))
                    case 0xD0:
                        cur = min(endPos, cur + 1)
                    case 0xA0, 0xB0, 0xE0:
                        cur = min(endPos, cur + 2)
                    default:
                        cur = endPos
                    }
                }
            }
            pos = endPos
        }

        rawEvents.sort { $0.tick < $1.tick }
        var curTempo = 500_000.0
        var lastTick = 0
        var curSec = 0.0
        var channelPrograms = [Int](repeating: 0, count: 16)
        var noteEvents = [MidiNoteEvent]()
        noteEvents.reserveCapacity(rawEvents.count)

        for ev in rawEvents {
            let delta = ev.tick - lastTick
            if delta > 0 {
                curSec += (Double(delta) / Double(division)) * (curTempo / 1_000_000.0)
                lastTick = ev.tick
            }
            switch ev.kind {
            case 0:
                curTempo = Double(ev.a)
            case 3:
                if ev.ch >= 0 && ev.ch < 16 { channelPrograms[ev.ch] = ev.a }
            case 1:
                noteEvents.append(MidiNoteEvent(timeSec: curSec, channel: ev.ch, isNoteOn: true, note: ev.a, velocity: ev.b, program: channelPrograms[ev.ch]))
            case 2:
                noteEvents.append(MidiNoteEvent(timeSec: curSec, channel: ev.ch, isNoteOn: false, note: ev.a, velocity: ev.b, program: channelPrograms[ev.ch]))
            default:
                break
            }
        }
        return ParsedMidiSequence(division: division, events: noteEvents, durationSec: max(0.25, curSec))
    }
}

public final class MidiSynthEngine {
    // Port of a.a & a.b (a.<clinit>)
    public static let trackResIds: [Int] = [4, 2, 3, 5]
    public static let eventToTrackMap: [Int] = [0, 1, 2, 1, -1, -1, -1, -1, -1, -1, -1, -1, 3]

    private let lock = NSLock()
    private var engine: AVAudioEngine?
    private var sourceNode: AVAudioSourceNode?
    private var isAudioRunning = false

    private var cachedSequences: [Int: ParsedMidiSequence] = [:]
    private var activeSequence: ParsedMidiSequence?
    private var activeTrackIndex: Int = -1
    private var loopEnabled = true
    private var playbackTimeSec: Double = 0
    private var nextEventIndex: Int = 0
    private var isPausedByLifecycle = false

    public var isSoundEnabled: Bool = true {
        didSet {
            if !isSoundEnabled { stopAll() }
        }
    }

    private struct Voice {
        var note: Int
        var channel: Int
        var phase: Double
        var freq: Double
        var amp: Double
        var isPerc: Bool
        var releasing: Bool
        var env: Double
        var ageSec: Double
    }
    private var voices: [Voice] = []
    private let sampleRate: Double = 44100.0
    private var noiseSeed: UInt32 = 0x1234_5678

    public init() {}

    // Port of a.a(int eventId)
    public func playEvent(_ eventId: Int, savedTrackSlot: inout Int, pausedByMenu: Bool, assets: GameAssets = .shared) {
        guard eventId >= 0, eventId < Self.eventToTrackMap.count else { return }
        let slot = Self.eventToTrackMap[eventId]
        guard slot != -1 else { return }
        let resId = Self.trackResIds[slot]
        if resId != 5 {
            savedTrackSlot = slot
        }
        guard isSoundEnabled, !pausedByMenu else { return }
        startTrackSlot(slot, loops: resId != 5, assets: assets)
    }

    public func startTrackSlot(_ slot: Int, loops: Bool = true, assets: GameAssets = .shared) {
        guard slot >= 0, slot < Self.trackResIds.count else { return }
        let resId = Self.trackResIds[slot]
        let seq: ParsedMidiSequence
        if let existing = cachedSequences[resId] {
            seq = existing
        } else if let data = assets.loadResource(id: resId), let parsed = ParsedMidiSequence.parse(data: data) {
            cachedSequences[resId] = parsed
            seq = parsed
        } else {
            return
        }

        ensureEngineStarted()
        lock.lock()
        activeSequence = seq
        activeTrackIndex = slot
        loopEnabled = loops
        playbackTimeSec = 0
        nextEventIndex = 0
        voices.removeAll()
        lock.unlock()
    }

    // Port of a.a()
    public func stopAll() {
        lock.lock()
        activeSequence = nil
        activeTrackIndex = -1
        voices.removeAll()
        lock.unlock()
    }

    public func setLifecyclePaused(_ paused: Bool) {
        isPausedByLifecycle = paused
        if paused {
            lock.lock()
            voices.removeAll()
            lock.unlock()
        }
    }

    private func ensureEngineStarted() {
        if engine != nil && isAudioRunning { return }
        #if os(iOS)
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
        try? session.setActive(true)
        #endif

        let eng = AVAudioEngine()
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1) else { return }
        let sr = sampleRate
        let src = AVAudioSourceNode(format: format) { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self = self else { return noErr }
            let abl = UnsafeMutableAudioBufferListPointer(audioBufferList)
            guard let outBuf = abl.first?.mData?.assumingMemoryBound(to: Float.self) else { return noErr }
            self.renderAudio(into: outBuf, frames: Int(frameCount), sampleRate: sr)
            return noErr
        }
        eng.attach(src)
        eng.connect(src, to: eng.mainMixerNode, format: format)
        eng.mainMixerNode.outputVolume = 0.35
        do {
            try eng.start()
            self.engine = eng
            self.sourceNode = src
            self.isAudioRunning = true
        } catch {
            // Audio device unavailable (e.g. headless CI simulator without audio hardware)
        }
    }

    private func renderAudio(into out: UnsafeMutablePointer<Float>, frames: Int, sampleRate sr: Double) {
        lock.lock()
        guard isSoundEnabled, !isPausedByLifecycle, let seq = activeSequence, !seq.events.isEmpty else {
            for i in 0..<frames { out[i] = 0 }
            lock.unlock()
            return
        }

        let dt = 1.0 / sr
        for i in 0..<frames {
            while nextEventIndex < seq.events.count && seq.events[nextEventIndex].timeSec <= playbackTimeSec {
                let ev = seq.events[nextEventIndex]
                nextEventIndex += 1
                if ev.isNoteOn {
                    let isPerc = (ev.channel == 9)
                    let freq = 440.0 * pow(2.0, Double(ev.note - 69) / 12.0)
                    let amp = (Double(ev.velocity) / 127.0) * (isPerc ? 0.14 : 0.10)
                    if voices.count >= 24 { voices.removeFirst() }
                    voices.append(Voice(note: ev.note, channel: ev.channel, phase: 0, freq: freq, amp: amp, isPerc: isPerc, releasing: false, env: 1.0, ageSec: 0))
                } else {
                    for vIdx in voices.indices where voices[vIdx].note == ev.note && voices[vIdx].channel == ev.channel && !voices[vIdx].releasing {
                        voices[vIdx].releasing = true
                    }
                }
            }

            var mix = 0.0
            var idx = voices.count - 1
            while idx >= 0 {
                voices[idx].ageSec += dt
                if voices[idx].isPerc {
                    voices[idx].env *= 0.997
                    noiseSeed = noiseSeed &* 1664525 &+ 1013904223
                    let n = (Double(Int32(bitPattern: noiseSeed)) / Double(Int32.max))
                    let click = sin(voices[idx].phase * 2.0 * .pi)
                    voices[idx].phase += voices[idx].freq * dt
                    mix += (n * 0.65 + click * 0.35) * voices[idx].amp * voices[idx].env
                    if voices[idx].ageSec > 0.14 || voices[idx].env < 0.01 {
                        voices.remove(at: idx)
                    }
                } else {
                    if voices[idx].releasing {
                        voices[idx].env -= dt * 7.5
                    } else if voices[idx].ageSec > 0.25 {
                        voices[idx].env = max(0.35, voices[idx].env - dt * 0.4)
                    }
                    if voices[idx].env <= 0.0 {
                        voices.remove(at: idx)
                    } else {
                        let p = voices[idx].phase.truncatingRemainder(dividingBy: 1.0)
                        // Retro J2ME wavetable / soft square+triangle blend
                        let sq = p < 0.5 ? 0.65 : -0.65
                        let tri = 1.0 - 4.0 * abs(p - 0.5)
                        mix += (sq * 0.35 + tri * 0.65) * voices[idx].amp * voices[idx].env
                        voices[idx].phase += voices[idx].freq * dt
                    }
                }
                idx -= 1
            }

            out[i] = Float(max(-0.85, min(0.85, mix)))
            playbackTimeSec += dt

            if nextEventIndex >= seq.events.count && playbackTimeSec >= seq.durationSec {
                if loopEnabled {
                    playbackTimeSec = 0
                    nextEventIndex = 0
                    voices.removeAll()
                } else {
                    activeSequence = nil
                    voices.removeAll()
                    for j in (i + 1)..<frames { out[j] = 0 }
                    break
                }
            }
        }
        lock.unlock()
    }
}
