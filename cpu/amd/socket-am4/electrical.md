# AM4 electrical interface

## AM4 functional signal classes

* dual DDR4 channels (`MA_*`, `MB_*`)
* PCIe graphics/GPP/hub links
* SATA alternate functions
* DisplayPort
* USB
* HD Audio
* SPI/eSPI/LPC
* I2C/SMBus/GPIO
* clocks
* reset/power-management
* thermal/JTAG/SVI
* power rails

## Physical-pin functional inventory

* see also: functions.yml

| Function group | Pin count |
|---|---:|
| `power_rails` | 288 |
| `ground_reference` | 415 |
| `ddr4_channel_a` | 146 |
| `ddr4_channel_b` | 146 |
| `pcie_graphics` | 66 |
| `pcie_chipset_link` | 16 |
| `pcie_gpp_sata` | 28 |
| `displayport` | 37 |
| `usb` | 28 |
| `hd_audio` | 8 |
| `firmware_spi_espi_lpc` | 22 |
| `gpio_i2c_smbus_sgpio` | 33 |
| `clocks` | 6 |
| `power_management_reset` | 6 |
| `thermal_sideband_svi` | 8 |
| `debug_test_jtag` | 28 |
| `identification_straps` | 3 |
| `reserved` | 47 |


## Required voltage domains at the socket

* `VDDIO_MEM_S3`: 1.2V DRAM interface voltage rail
* `VDD_18`: 1.8V core voltage rail
* `VDD_33`: 3.3V TTL I/O voltage rail

| Domain / pins | Nominal or expected range | Direction at socket | Notes for a custom processor |
|---|---:|---|---|
| `VSS`, `*_ZVSS`, `VSS_SENSE_*` | 0 V | board <-> processor return | Must provide very low-inductance return paths for DDR4, PCIe, USB, DP, SATA and VRM sense loops. |
| `VDDCR_CPU` | variable VRM rail, AMD-specific | motherboard VRM -> CPU | Core rail controlled over SVI/SVI2. Public pinout does not define valid VID range, load-line, current limit, telemetry, transient response or sequencing. Must use official AMD SVI/AM4 electrical data. |
| `VDDCR_SOC` | variable VRM rail, AMD-specific | motherboard VRM -> CPU SoC | Supplies northbridge/SoC/I/O domains. Same public-data limitation as `VDDCR_CPU`. |
| `VDDCR_SOC_S5` | always-on SoC rail, AMD-specific | motherboard -> CPU | Present in S5/standby domains; public pinout names it but does not give current/sequence limits. |
| `VDDIO_MEM_S3` | 1.2 V nominal | motherboard -> CPU DDR PHY/DIMM interface | DDR4 VDD/VDDQ is commonly 1.2 V; Micron DDR4 datasheets state `VDD = VDDQ = 1.2 V +/- 60 mV` and `VPP = 2.5 V`. |
| `VDDIO_MEM_S3_SENSE` | sense for 1.2 V rail | CPU/VRM sense | Sense/feedback pin; do not load as a power pin. |
| `VDD_18`, `VDD_18_S5` | 1.8 V nominal | motherboard -> CPU | Normal and always-on 1.8 V rails per pin description. Exact tolerance/sequencing is not public here. |
| `VDD_33`, `VDD_33_S5` | 3.3 V nominal | motherboard -> CPU | Normal and always-on 3.3 V rails per pin description. Exact tolerance/sequencing is not public here. |
| `VDDBT_RTC_G` | battery/RTC domain, commonly ~3 V battery domain | motherboard battery -> RTC domain | Pin description identifies this as integrated RTC battery power. Exact allowed range must be taken from AMD package spec. |
| `VDDP`, `VDDP_S5`, `VDDP_SENSE` | AMD-specific auxiliary rail | motherboard -> CPU | Public pin description names the rail but does not give nominal/tolerance. Do not infer from DDR4 `VPP`. |
| `VDDIO_AUDIO` | audio I/O rail, AMD-specific | motherboard -> CPU/audio interface | Public pin description identifies it as Azalia/HD-audio power, not its tolerance. |
| High-speed differential pairs | AC-coupled / standard-specific common-mode and swing | bidirectional by interface | PCIe/SATA/USB/DP voltages are not simple CMOS rails. They require standard PHY compliance, equalization and loss-budget validation. |
| Low-speed sideband GPIO/I2C/LPC/eSPI/SPI/HD Audio | likely 1.8 V or 3.3 V domains depending rail and board implementation | mixed | The public AM4 pinout names the signals but does not publish VIH/VIL/VOH/VOL, pull-up voltage or 5 V tolerance. Treat all as not 5 V tolerant unless the official spec says otherwise. |

## Required frequency and data-rate support by interface

| Interface group | AM4 signal examples | Frequency / data-rate targets | Voltage / PHY notes |
|---|---|---:|---|
| CPU VRM control | `SVC`, `SVD`, `SVT` | SVI/SVI2 control bus; exact bus rate not public in the provided documents | Must speak AMD SVI/SVI2 protocol expected by AM4 VRM controllers before and during power-up. |
| DDR4 channel A/B | `MA_*`, `MB_*`, `MA0/1_*`, `MB0/1_*` | JEDEC DDR4-class operation. Practical AM4 CPU generations commonly span DDR4-2666, DDR4-2933 and DDR4-3200 depending CPU generation and DIMM topology; DDR data clock is half the MT/s rate, e.g. 1333-1600 MHz for DDR4-2666/3200. | 1.2 V SSTL/POD-style DDR4 I/O; Micron DDR4 lists VDD=VDDQ=1.2 V +/-60 mV and VPP=2.5 V. Must implement DDR4 training, write leveling, ODT and impedance calibration. |
| PCIe graphics | `P_GFX_RXP/N[15:0]`, `P_GFX_TXP/N[15:0]`, `GFX_CLKP/N` | 100 MHz reference clock; at least PCIe Gen3 8.0 GT/s for broad AM4 compatibility; PCIe Gen4 16.0 GT/s for Ryzen 3000/5000-era X570/B550-style compatibility. | AC-coupled differential serial links; implement PCIe PHY training, equalization, receiver detection, reset and clock request behavior. |
| PCIe GPP / chipset hub | `P_GPP_*`, `P_HUB_*`, `GPP_CLK*`, `CLK_REQ*` | 100 MHz reference clocks; PCIe Gen2/Gen3/Gen4 depends on CPU/chipset generation and lane use. Chipset links on many AM4 chipsets are PCIe-like; the public pinout alone is insufficient to define the link. | Same PCIe PHY rules; chipset/hub link also needs platform firmware expectations. |
| SATA alternate lanes | `P_GPP_* / SATA_RX* / SATA_TX*`, `SATA_ACT_L` | SATA 1.5, 3.0 and 6.0 Gb/s classes; SATA Revision 3.0 defines 6 Gb/s. | AC-coupled differential PHY with OOB signaling and SATA electrical compliance. |
| DisplayPort | `DP0..DP2_TXP/N[3:0]`, `AUXP/N`, `HPD` | DP main-link rates up to HBR3 are 8.1 Gb/s per lane in DP 1.3/1.4-class systems; lower RBR/HBR/HBR2 modes are 1.62/2.7/5.4 Gb/s per lane. | Main link is AC-coupled high-speed differential; AUX/HPD use separate low-speed electrical rules. Only APUs or CPUs with display engine use these pins. |
| USB 2.0 | `USB_HSD0..3P/N` | Low/full/high speed: 1.5, 12, 480 Mb/s | USB 2.0 differential signaling; 5 V VBUS is not a CPU pin here but board-side port power/OC handling must be compatible. |
| USB SuperSpeed | `USB_SS_*RXP/N`, `USB_SS_*TXP/N` | At least 5 Gb/s SuperSpeed-class lanes; USB 3.2 retains existing 5/10 Gb/s PHY data rates and can use 10 Gb/s lanes in Gen2 implementations. | AC-coupled differential SuperSpeed PHY. The exact AM4 CPU generation determines which rates are actually expected. |
| SPI / eSPI / LPC firmware and EC buses | `SPI_*`, `ESPI_*`, `LAD[3:0]`, `LFRAME_L`, `LPCCLK*` | LPC legacy clock is 33 MHz; eSPI is commonly up to 66 MHz in modern PC platforms. SPI flash clock is board/firmware/SoC-specific. | Low-speed digital I/O, commonly 1.8 V/3.3 V depending implementation. Need boot-ROM/firmware access behavior, not just pins. |
| HD Audio / Azalia | `AZ_BITCLK`, `AZ_SYNC`, `AZ_SDIN*`, `AZ_SDOUT`, `AZ_RST_L` | Intel HD Audio uses a 24 MHz bit clock class for the link. | Digital codec link. Voltage domain is board/platform specific; `VDDIO_AUDIO` exists but public pinout does not define tolerance. |
| I2C / SMBus / GPIO / SGPIO | `SDA0/1`, `SCL0/1`, `AGPIO*`, `EGPIO*`, `SGPIO0_*` | I2C/SMBus usually 100 kHz/400 kHz class, sometimes faster; SGPIO is low-speed board management. | Open-drain/pull-up behavior and pull-up voltage must match board design. Do not assume 5 V tolerance. |
| Clocks / crystals | `X48M_X1/X2`, `48M_OSC`, `X32K_X1/X2`, `RTCCLK`, `GFX_CLK*`, `GPP_CLK*` | 48 MHz crystal/oscillator domain; 32.768 kHz RTC crystal; 100 MHz PCIe reference clocks. | Crystal pins are analog oscillator pins, not normal digital inputs. Layout and load capacitance matter. |
| Reset / power management | `PWR_GOOD`, `PWROK`, `RESET_L`, `RSMRST_L`, `SLP_S3_L`, `SLP_S5_L`, `SYS_RESET_L`, `PWR_BTN_L`, `WAKE_L` | Mostly static/low-frequency state signals; timing/sequencing is critical. | Must match ATX/ACPI/AM4 sequencing expectations. Exact thresholds and timing are not public in the pinout. |
| Thermal / sideband / debug | `PROCHOT_L`, `THERMTRIP_L`, `ALERT_L`, `SIC`, `SID`, JTAG | Low-speed sideband/JTAG; TCK frequency is implementation/test dependent. | Must implement thermal fail-safe behavior, SB-TSI/sideband behavior and JTAG/debug rules expected by board firmware/tools. |

## Minimum practical electrical target

A custom device intended to plug into an unmodified AM4 motherboard would need, at minimum:

1. Correct power sequencing and SVI/SVI2 negotiation for `VDDCR_CPU` and `VDDCR_SOC` before the board declares power-good.
2. Correct DC loading on all supply and sense pins, including low-impedance returns on every `VSS` and `*_ZVSS` pin.
3. DDR4 PHY support for two memory channels at the target board's supported memory speed, including training and ODT.
4. PCIe PHY support for the graphics, GPP and hub lanes at the generation required by the target board/chipset; Gen3 is the minimum realistic baseline, Gen4 is needed for full later-AM4 behavior.
5. Firmware-visible boot behavior compatible with AM4 platform firmware expectations: reset vector/boot ROM behavior, SPI/eSPI/LPC interactions, PSP/AGESA expectations or an intentional replacement firmware path.
6. Low-speed sideband behavior for reset, sleep, power-button, wake, thermal, fan, I2C/SMBus, GPIO, JTAG and SVI signals.

## Open items that cannot be closed from public pinouts

- Exact valid VID ranges and current limits for `VDDCR_CPU`, `VDDCR_SOC`, `VDDP` and S5 rails.
- VIH/VIL/VOH/VOL, termination, pull-up voltages and 5 V tolerance for every low-speed pin.
- PCIe/SATA/USB/DP transmitter/receiver masks, insertion-loss budgets, reference equalization and compliance channels for AM4 package routing.
- Exact power-up/down timing between all rails, clocks, resets and SVI traffic.
- Firmware/security/PSP/AGESA requirements for a non-AMD processor on a stock motherboard.

## Sources

- `AM4 Pin List.pdf` and `AM4 Pinout Diagram.pdf` for designators and package pin names.
- `Pin Description.pdf` for functional signal descriptions and public rail names.
- Micron DDR4 SDRAM datasheet excerpts for DDR4 VDD/VDDQ and VPP values.
- PCI-SIG public PCI Express materials for PCIe specification family context; PCIe Gen3/Gen4 rates are industry-standard 8.0/16.0 GT/s.
- USB-IF USB 3.2 public material for 5/10 Gb/s PHY-rate continuity and USB 3.2 multi-lane behavior.
- VESA DisplayPort public material for HBR3 8.1 Gb/s/lane and DP 1.3/1.4 bandwidth context.
- SATA-IO / Serial ATA Revision 3.0 public material for SATA 6 Gb/s.
- Intel LPC, eSPI and HD Audio public specifications for low-speed bus clock classes.
