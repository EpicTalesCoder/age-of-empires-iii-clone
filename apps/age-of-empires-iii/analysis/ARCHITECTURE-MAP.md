# Architecture Map — Age of Empires III Mobile (1:1 iOS 16.1.1 Rebuild)

All structural facts below are directly observed in `apps/age-of-empires-iii/analysis/decompiled/*.pseudo.java`, `*.javap.txt`, and `analysis/metadata/*.json`.

---

## 1. Runtime Lifecycle & Threading Model

1. **Entry (`Main.java` / `Main.javap.txt`)**:
   - `Main.startApp()` constructs `f(this)` on first launch, calling `Display.getDisplay(this).setCurrent(f)` and starting the game thread (`new Thread(f).start()`).
   - `Main.pauseApp()` -> `f.hideNotify()`, `Main.destroyApp()` stops main loop (`f.d = false`) and stops audio (`a.a()`).
   - **iOS 16 Equivalent**: SwiftUI `@main` `AgeOfEmpiresIIIApp` hosting a `GameContainerView` (`ObservableObject` coordinator) running a 20 Hz simulation tick timer (`0.050s`, matching `f.run()` 50 ms frame pacing) and hooking `scenePhase` (`.background` / `.inactive` / `.active`) to `hideNotify()` / `showNotify()`.

2. **Canvas & Viewport Model (`c.java` + `f.java`)**:
   - Logical viewport: **`360 x 400`** px HUD/RTS playfield + **`360 x 241`** (`touch.png`) virtual keypad drawn at `y = 400` (`360 x 640` total).
   - Touch hitboxes (`c.a[14][5]` in `c.<clinit>`):
     - Keypad 4x3 grid mapped relative to `y >= 400` (`[0..90]`, `[91..180]`, `[181..270]`, `[271..360]` across rows `[3..82]`, `[83..161]`, `[162..240]`): `'1','2','3','*','4','5','6','0','7','8','9','#'`.
     - Softkeys (`[0..60, 360..400]` = LSK `-6`, `[300..360, 360..400]` = RSK `-7`).
   - **iPhone XS Max (`414 x 896 pt @3x`, Top Safe Area `44 pt`, Bottom Safe Area `34 pt`)**:
     - Playable safe height = `896 - 44 - 34 = 818 pt` (`414 x 818 pt`).
     - Render the `360 x 400` RTS canvas at aspect-fit (`414 x 460 pt`) in the upper safe zone below `44 pt`, paired below with the `360 x 241` original `touch.png` keypad (`414 x 277 pt` aspect-fit) + softkey controls + direct map-tap/pan gesture support inside the `360 x 400` canvas that moves cursor `e.d` & triggers selection/action. Both LSK (`[0..60, 360..400]`) and RSK (`[300..360, 360..400]`) stay 100% responsive on both canvas corners and touch buttons.

---

## 2. State Machine (`f.s` & `f.java`)

- `f.s` screen states (driven in `f.run()` / `f.paint()` / `f.h()`):
  - `0`: Splash / Brand logo sequence (`brand0.png`, `brand1.png`, `brand2.png`, `splash.png`)
  - `1`–`2`: Menu & submenus (`g` linked list): Main Menu (`Chien dich`, `Giao tranh`, `Game da luu`, `Cai dat`, `Huong dan`, `Gioi thieu`, `Thoat`), Campaign mission select (15 missions with `RecordStore` progress bitmask), Skirmish setup (4 maps `0..3` -> `8..11.res`, Faction, Difficulty), Saved Games (`3` slots), Settings (Sound, Vibration, Hints/Tips), Instructions/About scrolling text (`g.b == 2`).
  - `3`: Loading transition (`loading` gauge + gameplay tips from `lang.dat`)
  - `4`: Active RTS gameplay (`e.f()` update, `e.a(Graphics)` render, `e.a(int)` key handling, pause menu overlay)
  - `5`: Victory / Defeat / Campaign debriefing & Home City card rewards
- **Cheat Sequence (`f.f`)**: Key bitmask sequence `[4, 8, 4, 4, 8, 8, 4, 4, 4, 8, 8, 8, 16384]` (`L, R, L, L, R, R, L, L, L, R, R, R, 0`).

---

## 3. Resource & Rendering Pipeline (`h`, `k`, `l`, `f.a`, `e.o`, `e.p`)

- **Resource Loading (`h.java`)**:
  - `h.a(Int)`: opens `/{id & 0xFFFF}.res`, skips first 4 bytes (`skip(4L)`), returns remaining bytes.
  - `h.a(String)`: reads `/filename` verbatim (`lang.dat`, `multi.dat`, `*.png`).
- **PNG `PLTE` Chunk Swapping (`f.a(byte[] png, byte[] plteChunk)`)**:
  - Locates `"PLTE"` chunk signature in indexed PNG bytes (`png[pos...pos+4] == "PLTE"`), replaces the 4-byte length + `"PLTE"` + palette RGB data + 4-byte CRC with `plteChunk` (from `34..36.res` or embedded trailer in `24.res`/`32.res`) — preserving exact pixel-indexed colors for Player vs Enemy vs Neutral/Gold teams.
- **Bitmap & System Font (`l.java` + `c.java`)**:
  - `c.c = [0, 1]`:
    - Font `0`: Bitmap atlas `0.res` (`126x136`) + metrics `1.res` (`charGap=0, spaceWidth=11, lineHeight=17, 136 chars` indexed by binary search over UTF char array + per-glyph `(width, x, y)`).
    - Font `1`: System small font `c.a[0]` rendered in white with `(1, 1)` black drop shadow (`color = -2` in `c.d`).
- **Sprite Engine (`k.java`, `e.p()`, `20..32.res`)**:
  - `24` sprite slots (`e.a:[[[Lk;`, `e.a:[[I` anchor offsets, `e.a:[[[B` frame indices, `e.b:[[[S` frame durations indexed via `e.l`, `e.b:[[[B` `Sprite.TRANS_*` horizontal mirror `2`).
  - Image region transforms (`0` none, `2` `TRANS_MIRROR` horizontal flip, `1` vertical flip, `3` rotate 180, `5` rotate 90, `6` rotate 270).

---

## 4. Core Simulation (`e.java`, `b.java`, `j.java`, `i.java`, `33.res`)

- **World & Isometric Projection (`e.java`)**:
  - Logic grid: `48 x 48` sub-units per tile (fixed-point `<< 8` world coordinates in `b.h`/`b.i`).
  - Isometric screen transform: diamond projection converting `(tileX, tileY)` to isometric screen pixels relative to camera `(e.o, e.p)` with Y painter's-algorithm depth sort before rendering terrain `54.res`, props `55.res`, units, buildings, projectiles, and selection/HP bars.
  - Fog / Shroud (`e.k[tile]`): bitmask tracking unexplored, explored-shrouded, and currently visible states around allied units/buildings.
- **Entities (`b.java`)**:
  - `b.d == 1`: Cursor (`48px` snapped/free pointer + valid build footprint preview).
  - `b.d == 2`: Units (`8` archetypes `0..7`: Settler, Pikeman, Musketeer, Grenadier, Hussar, Dragoon, Falconet, Heavy Cannon), upgraded across tiers (`Veteran`, `Guard`, `Imperial`) via `e.c:[[S`.
  - `b.d == 3`: Buildings (`8` types `0..7`: Town Center, House, Market, Barracks, Stable, Artillery Foundry, Outpost/Tower, Fort) with training/research/age-advance queues (`a[]`), rally point, HP.
  - `b.d == 5`: Projectiles, impacts, explosions, smoke, corpses.
  - `b.d == 6`: Floating `+qty` resource popup indicators.
  - **Combat & Counters**: Direct melee/ranged cooldown combat, AoE artillery splash, `3x` bonus multiplier vs countered classes (`b.b`), building siege vs unit damage, auto-acquire within sight/aggro range.
  - **Economy**: `3` resources (`Food`, `Wood`, `Gold`), Settlers gather from berries/hunts (`1000`), trees (`300`), mines (`3000`) and return to Town Center / Market.
- **Pathfinding (`e.a` + `i.java`)**:
  - A* grid search on map passability (`e.L`, building occupancy, water/cliffs) using Manhattan/octile heuristic with path waypoint array stored in `b.a`.
- **AI (`j.java`)**:
  - Manages gatherer distribution by desired Food/Wood/Gold ratios, `10x10` tile threat sector map, house cap prevention, barracks/stable/foundry placement, age advancement, army staging, and coordinated wave attacks adjusted by Skirmish Difficulty (`Easy/Normal/Hard`).
- **Campaign & Skirmish (`e.c`, `e.a:[[[S`, `33.res`)**:
  - `15` campaign missions mapped onto `e.N` (`6, 7, 12..19.res`) with command unlock bitmasks `e.h:[I` and scripted event triggers `e.a:[[[S` (opcodes `0..12`).
  - `4` skirmish maps (`8..11.res`).

---

## 5. Audio (`a.java` + `2..5.res`)

- Track table `a.a = [4, 2, 3, 5]`; sound event map `a.b[0..12]` selects tracks (`0` title theme `4.res`, gameplay tracks `2.res`/`3.res`/`5.res`) looped at volume `50`.
- **iOS 16 Implementation**: Pure Swift SMF MIDI parser decoding delta ticks, tempo meta events (`0x51`), program changes (`0xC0`), note-on/note-off (`0x90`/`0x80`), and synthesizing polyphonic audio natively in real time via `AVAudioEngine` + `AVAudioSourceNode` (zero external SoundFont dependency).

---

## 6. Persistence (`RecordStore "aoe3"`)

- Original RMS store (`"aoe3"`) persists 5 binary records (`DataOutputStream` / `DataInputStream`):
  - **Record 1 (`settings & campaign progression`)**: Sound flag (`bool`), Vibration flag (`bool`), Hints flag (`bool`), unlocked campaign index, completed missions bitmask, unlocked Home City bonuses.
  - **Records 2–4 (`save slots 1..3`)**: Presence flag, save title/metadata, current map/mission/difficulty/faction/age/resources, RNG/camera state, fog array `e.k`, all `b` entities serialized in `b.a()` binary format, and AI `j` state.
  - **iOS 16 Implementation**: Stored cleanly under `Application Support/aoe3/` using big-endian `BigEndianReader`/`BigEndianWriter` matching the original `DataInputStream`/`DataOutputStream` byte layout 1:1.

---

## 7. Rebuild Module Plan (`apps/age-of-empires-iii/ios-app/`)

| Layer | Swift Files | Original Java Mapping |
| :--- | :--- | :--- |
| `DesignSystem/` | `XSMaxLayout.swift`, `GameAssets.swift`, `PLTEPatcher.swift`, `BitmapFont.swift`, `SpritePack.swift` | `h`, `k`, `l`, `f.a(byte[],byte[])`, `c.a` |
| `Core/` | `BigEndianIO.swift`, `Localization.swift`, `GameTables.swift`, `GameMap.swift`, `Pathfinder.swift`, `Entity.swift`, `AIController.swift`, `GameEngine.swift`, `MidiSynthEngine.swift`, `SaveStore.swift`, `MenuCoordinator.swift`, `SoftwareRenderer.swift` | `Main`, `a`, `b`, `d`, `e`, `f`, `g`, `i`, `j` |
| `Features/` | `GameCanvasView.swift`, `GameContainerView.swift`, `VirtualKeypadView.swift` | `c`, `f` (`GameCanvas` + `touch.png`) |
| `App/` | `AgeOfEmpiresIIIApp.swift` | `Main` |
| `Tests/` | `AgeOfEmpiresIIITests.swift` | XCTest parity verification suite |
