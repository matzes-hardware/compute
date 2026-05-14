# AM4-compatible processor/interposer

## References

- Foxconn/FIT CPU Socket: `PZ1331A-51ZZ0-1H` / `PZ1331A-51ZZ1-1H`
- Socket type: AM4, PGA/BGA socket, SMT, 1331 positions
- Socket contact material: Copper alloy
- Socket contact finish: 10 microinch min PdNiAu in the contact area, 50–90 microinch nickel overall on the contact
- Socket:
  - Foxconn/FIT product page: https://www.fit-foxconn.com/mainssl/modules/MySpace/PrdInfo.php?sn=fit&xmlid=13899
  - Foxconn/FIT customer drawing PDF: https://www.fit-foxconn.com/w73/fit/image/Products/Drawing/Drawing/PZ1331A-51ZZ0-1H_20181218103252.pdf
  - Foxconn/FIT spec PDF: https://www.fit-foxconn.com/w73/fit/image/Products/Spec/Spec/PZ1331A-51ZZ0-1H_20181218103237.pdf
  - Gadget Manual, AMD CPU Socket Pinout/Data Sheet: https://www.gadget-manual.com/amd/amd-cpu-pinout/

## Additional information from Gadget Manual

| Source statement | Implication for mechanical AM4 design | Status in this design |
|---|---|---|
| AM4 is also referred to as `PGA 1331` | Confirms a male pin grid array as the mate to the motherboard socket; not LGA | Documented here as PGA1331 |
| AM4 is a `PGA (pin grid array) type socket` | Confirms: pads on the processor underside are not sufficient for a standard AM4 socket | Pins/studs required |
| AM4 has `1331 pins` | Confirms the number of positions to populate | 1331 positions from `designators.yml` |
| AM4 was introduced in 2016 for Zen-based processors; Excavator processors also exist | Mechanically relevant because AM4 spans multiple CPU/APU generations on the same mechanical socket | No change to pin mechanics; verify electrical/firmware compatibility separately |
| AM4 brought DDR4 support and integrated graphics on the same socket | Explains the pin groups for DDR4 (`MA_*`, `MB_*`) and display/graphics/I/O | Functional context only; no extra mechanical mass |
| The page shows two AM4 pin/signal diagrams and a socket photo | Useful for sanity-checking orientation, pin/contact field, and socket type | Do not use as a dimensioned mechanical drawing |
| Linked downloads: `Processors using Socket AM4` and `Processors using Socket AM4 Socket Diagrams` | Potentially useful secondary sources, but the site’s HTML does not provide numeric package dimensions from them | Use only if the original PDFs are obtained and checked separately |

## Pin grid and electrical designator geometry

| Parameter | Value | Comment |
|---|---:|---|
| Number of socket positions | 1331 | AM4 / PGA1331; confirmed by Gadget Manual as `1331 pins` |
| Nominal pitch | 1.00 mm | Foxconn drawing; Gadget Manual adds no numeric detail here |
| Nominal pitch extent | 38.00 mm × 38.00 mm | 39 coordinates per axis yield 38 intervals at 1.00 mm |
| Columns | 01 through 39 | see `designators.yml` |
| Rows | A, B, C, D, E, F, G, H, J, K, L, M, N, P, R, T, U, V, W, Y, AA, AB, AC, AD, AE, AF, AG, AH, AJ, AK, AL, AM, AN, AP, AR, AT, AU, AV, AW | Letters I, O, Q, S, X, Z, and AI are omitted |
| Populated/used grid points | 1331 | Not every 39×39 coordinate is filled; central and edge omissions exist; pin count confirmed by Gadget Manual |
| Designator normalization | e.g. `A03`, `AA01` | Some sources use `A03` vs `A3`; the YAML file uses `A03` |

### Coordinate model for CAD

Pin centers on a 1.00 mm grid:

```text
x = (column_number - 1) * 1.00 mm
y = (row_index - 1) * 1.00 mm
```

## Socket mating interface: known dimensions from Foxconn drawing

| Feature | Value | Implication for custom CPU/interposer design |
|---|---:|---|
| Pin/contact position pitch | 1.00 mm | Pin centers must lie on this grid |
| Contact/pin receptacle per detail A | diameter 0.485 +0.03 mm, 1331× | Relevant published socket value for the receptacle; **not** automatically the allowed CPU pin diameter |
| Detail A guide/contact feature | diameter 0.85 ± 0.03 mm | Socket geometry around the receptacle; do not use as CPU pin diameter |
| Contact receptacle position reference | position tolerance diameter 0.25 to A/B/C and diameter 0.13 to A | GD&T from socket drawing; include in tolerance stack |
| Socket thickness after reflow | 2.90 ± 0.20 mm | From package seating plane to bottom solder ball; **not** to be read directly as pin length |
| Component keep-in area device height | 1.50 mm max | Max component height in keep-in per socket drawing |
| Lever operation | 90° lift-up to open; bend-down to lock | Interposer/CPU must clear ZIF lever motion mechanically |

## Socket outline dimensions and keep-out notes

These values describe the socket and board surroundings. They are not the same as the CPU substrate size, but they help with interposer and fixture design.

| Feature | Value | Comment |
|---|---:|---|
| Socket width, top view | 46.8 mm max | Foxconn drawing |
| Socket width, upper reference | 46.2 mm | Foxconn drawing |
| Socket length/height in top view | 51.08 mm | Foxconn drawing |
| Socket length right side, max | 50.97 mm | Foxconn drawing |
| Socket length right side, reference | 48.69 mm | Foxconn drawing |
| Pin grid reference width | 38.00 mm | Pin field / land pattern |
| Half-pitch / center reference | 19.00 mm | From center to each grid edge |
| Local grid reference | 1.00 mm | Pitch and local dimensions |
| Central cutout / pin-free zone, min | 11.80 mm min | From pin-field drawing |
| Side socket/lever overhang | 5.4 mm | Drawing value in side view |
| Overall height/length side view | 57.0 mm max | Drawing value, socket/lever geometry |
| Cover height local | 2.6 mm max | Detail/side view |
| Lever overhang local | 1.80 mm max | Detail/side view |

## PCB land pattern of the socket (relevant only when designing a mainboard/socket footprint)

| Feature | Value | Comment |
|---|---:|---|
| PCB pad diameter | diameter 0.50 ± 0.05 mm, 1331× | Land pattern for socket solder balls |
| PCB pad position tolerance | position tolerance diameter 0.10 to X/Y | From Foxconn drawing |
| Socket solder ball diameter | diameter 0.60 ± 0.10 mm, 1331× | Socket underside |
| Solder ball position tolerance | diameter 0.40 to P/B/C and diameter 0.25 to P | From socket drawing |
| PCB component keep-out/keep-in, overall reference | 49.50 mm / 54.50 mm / 60.25 mm drawing reference | From page 2 of Foxconn drawing; copy into layout exactly from the original drawing |
| PCB component keep-out, local spacings | 3.00 mm min, 3.50 mm min, 8.75 mm min, 4.70 mm max, 5.40 mm max | From page 2 of Foxconn drawing; do not redraw without the original drawing |
