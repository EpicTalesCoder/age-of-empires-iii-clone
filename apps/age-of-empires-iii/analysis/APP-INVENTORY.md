# App Inventory: Age of Empires III Mobile (360x640 Việt Hóa)

## 1. Source Container & Decryption Status

- **Slug**: `age-of-empires-iii`
- **Source Package**: [age_of_empires_iii_360x640_viet-hoa-2.jar](file:///Users/kd-qa-0294/Desktop/Project/clone-every-app/apps/age-of-empires-iii/original/age_of_empires_iii_360x640_viet-hoa-2.jar)
- **Container Format**: Standard J2ME MIDP-1.0 / CLDC-1.0 `.jar` (unencrypted ZIP archive, 86 entries)
- **Encryption / DRM Check**: Unencrypted Java bytecode & plain ZIP entries (Zero DRM protection; full static inspection verified).
- **MIDlet Manifest** (`META-INF/MANIFEST.MF`):
  - `MIDlet-Name`: `Age Of Empires III Mobile`
  - `MIDlet-Version`: `1.0.0`
  - `MIDlet-Vendor`: `GLU`
  - `MIDlet-1`: `Age Of Empires III Mobile, /i.png, Main`
  - `MIDlet-Icon`: `/i.png`
  - `MIDlet-Data-Size`: `4096` bytes (`RecordStore "aoe3"`)
  - `MicroEdition-Profile`: `MIDP-1.0`, `MicroEdition-Configuration`: `CLDC-1.0`

## 2. Target Device & OS Lock (iOS Rebuild)

- **Target Device**: iPhone XS Max (`iPhone11,6` / `iPhone11,4`, A12 Bionic `arm64`, 6.5" OLED `414x896 pt @3x`, Top Safe Area `44 pt`, Bottom Safe Area `34 pt`, 60 Hz, 4 GB RAM)
- **Target OS**: iOS 16.1.1 (`IPHONEOS_DEPLOYMENT_TARGET: "16.0"`, `MinimumOSVersion: "16.0"`, `SWIFT_VERSION: "5.0"`)
- **Distribution**: Unsigned / inside-out ad-hoc signed `.ipa` built via GitHub Actions `macos-15` for TrollStore 2 / Sideloadly / AltStore / SideStore

## 3. Compiled Java Class Inventory (13 Classes)

Lossless JVM bytecode (`*.javap.txt`) and CFG phi-aware decompilation (`*.pseudo.java`) generated under [decompiled/](file:///Users/kd-qa-0294/Desktop/Project/clone-every-app/apps/age-of-empires-iii/analysis/decompiled/), with full signature index at [javap-symbols-map.txt](file:///Users/kd-qa-0294/Desktop/Project/clone-every-app/apps/age-of-empires-iii/analysis/metadata/javap-symbols-map.txt):

| Class | Superclass / Interfaces | Role | Pseudo Lines |
| :--- | :--- | :--- | ---: |
| `Main` | `MIDlet` | Entry point, lifecycle (`startApp`, `pauseApp`, `destroyApp`) | 29 |
| `a` | `Object` | MIDI music player (`javax.microedition.media.Player`, tracks `2..5.res`) | 105 |
| `b` | `Object` | Entity simulation (Units `d=2`, Buildings `d=3`, Cursor `d=1`, FX `d=5`, Floating text `d=6`) | 1983 |
| `c` | `GameCanvas` | Screen (`360x400` canvas + `360x241` touch overlay), 14 keypad/softkey hitboxes, key masks | 426 |
| `d` | `Object` | Optional demo-mode gate (`ms-demoMode`, inactive when absent in `MANIFEST.MF`) | 109 |
| `e` | `Object` | Core RTS engine: tables (`33.res`), maps (`6..19.res`), A*, fog, isometric renderer, campaign triggers | 7128 |
| `f` | `c` (`Runnable`, `CommandListener`) | Main 50ms game loop, state machine, menus/dialogs, `RecordStore "aoe3"`, `PLTE` swapper, word wrap | 3427 |
| `g` | `Object` | Hierarchical menu screen descriptor & scroll state | 41 |
| `h` | `Object` | Resource loader (`h.a(int)` reads `/{id}.res` skipping 4-byte header; `h.a(String)` reads raw) | 68 |
| `i` | `Object` | A* pathfinding node (`parent`, `x`, `y`, `g`, `f`, `state`) | 20 |
| `j` | `Object` | Computer AI controller (gathering, threat sectors, build orders, age-up, attack waves) | 1071 |
| `k` | `Object` | Sprite / sub-region drawable (`Image`, `x`, `y`, `w`, `h`, `transform 0..7`) | 107 |
| `l` | `Object` | Hybrid bitmap (`0.res`+`1.res`) and system (`c.a`) text renderer + alignment | 389 |

## 4. Resource Inventory (57 `.res` + 7 `.dat` + 7 `.png`)

Full checksums in [ASSETS-SHA256.txt](file:///Users/kd-qa-0294/Desktop/Project/clone-every-app/apps/age-of-empires-iii/analysis/ASSETS-SHA256.txt) and decoded structural dumps in [metadata/](file:///Users/kd-qa-0294/Desktop/Project/clone-every-app/apps/age-of-empires-iii/analysis/metadata/).

### 4.1 `.res` Binary Resources (`4`-byte header + payload)
- **`0.res` (`2,321 B`) & `1.res` (`1,105 B`)**: Bitmap font PNG atlas (`126x136`, indexed 8-color PLTE) and metrics table (`lineHeight=17`, `spaceWidth=11`, `136` glyphs covering ASCII + Latin-1 including `©`).
- **`2.res`–`5.res` (`5,191 B`, `6,279 B`, `10,183 B`, `126 B`)**: Standard MIDI Files (`MThd`, division `480` ticks/quarter note; `2.res`/`3.res` format 1 with 10 tracks, `4.res` format 0 title theme, `5.res` format 1 with 2 tracks).
- **`6.res`–`19.res` (`14` files)**: Campaign & skirmish tilemaps (`22x32`, `29x40`, `29x42`) with terrain grid and initial entity spawn triples.
- **`20.res`–`32.res` (`13` files)**: Unit/building/FX/cursor sprite packs (grid split count, anchor offset `(dx, dy)`, animation sequences with frame indices, tick durations via `e.l`, and `Sprite.TRANS_*` flip transform, embedded indexed PNGs, and embedded `PLTE` chunks).
- **`33.res` (`3,735 B`)**: Master RTS database containing 65 typed arrays plus 15 campaign mission trigger scripts (`e.a:[[[S`).
- **`34.res`–`36.res` (`212 B` each)**: Standalone 64-color PNG `PLTE` chunks (208 B raw PNG chunk `length + "PLTE" + 192 B RGB + CRC32`) swapped at runtime for team colors (Blue, Red, Gold/Ally).
- **`37.res`–`56.res` (`20` files)**: Indexed PNG UI sprites, HUD icons (`39.res` `522x18` = 29 icons `18x18`), fog/border tiles (`40.res` `304x9`), Home City emblem (`49.res` `45x66`), terrain tileset (`54.res` `960x15` = 64 tiles), terrain props (`55.res` `480x52`), menu banner (`46.res` `360x110`).

### 4.2 Root PNGs & Localization `.dat` Files
- **PNGs (`7`)**: `splash.png` (`360x400`), `touch.png` (`360x241` phone keypad overlay), `brand0.png` (`217x162`), `brand1.png` (`226x55`), `brand2.png` (`228x149`), `demo.png` (`90x67`), `i.png` (`64x64` app icon).
- **`.dat` (`7`)**: `lang.dat` (`20,361 B`, `338` Vietnamese-localized strings ID `0..337`), `multi.dat` (`115 B`, 6-language selector list), plus `de.dat`, `es.dat`, `fr.dat`, `it.dat`, `pt.dat` (all containing the localized Vietnamese string table in this MOD).
