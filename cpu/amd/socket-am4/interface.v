`default_nettype none

module am4_interface (
    /**
     * DDR4 channel A
     */
    inout wire [63:0] ddr_a_data, // DDR4 data bus
    inout wire [8:0] ddr_a_dm, // DDR4 data mask / DBI
    inout wire [8:0] ddr_a_dqs_h, // DDR4 differential data strobe high
    inout wire [8:0] ddr_a_dqs_l, // DDR4 differential data strobe low
    inout wire [7:0] ddr_a_check, // DDR4 ECC check bits
    output wire [13:0] ddr_a_add, // DDR4 address
    output wire ddr_a_add_17, // DDR4 address 17
    output wire [1:0] ddr_a_bank, // DDR4 bank address
    output wire [1:0] ddr_a_bg, // DDR4 bank group
    output wire ddr_a_act_l, // DDR4 activate command
    output wire ddr_a_alert_l, // DDR4 alert input/output, board-dependent
    output wire ddr_a_cas_l_add_15, // DDR4 CAS / address 15
    output wire ddr_a_ras_l_add_16, // DDR4 RAS / address 16
    output wire ddr_a_we_l_add_14, // DDR4 WE / address 14
    output wire ddr_a_reset_l, // DDR4 reset
    input wire ddr_a_event_l, // DDR4 thermal event
    output wire ddr_a_parout, // DDR4 command/address parity

    /**
     * DDR4 channel B
     */
    inout wire [63:0] ddr_b_data, // DDR4 data bus
    inout wire [8:0] ddr_b_dm, // DDR4 data mask / DBI
    inout wire [8:0] ddr_b_dqs_h, // DDR4 differential data strobe high
    inout wire [8:0] ddr_b_dqs_l, // DDR4 differential data strobe low
    inout wire [7:0] ddr_b_check, // DDR4 ECC check bits
    output wire [13:0] ddr_b_add, // DDR4 address
    output wire ddr_b_add_17, // DDR4 address 17
    output wire [1:0] ddr_b_bank, // DDR4 bank address
    output wire [1:0] ddr_b_bg, // DDR4 bank group
    output wire ddr_b_act_l, // DDR4 activate command
    output wire ddr_b_alert_l, // DDR4 alert input/output, board-dependent
    output wire ddr_b_cas_l_add_15, // DDR4 CAS / address 15
    output wire ddr_b_ras_l_add_16, // DDR4 RAS / address 16
    output wire ddr_b_we_l_add_14, // DDR4 WE / address 14
    output wire ddr_b_reset_l, // DDR4 reset
    input wire ddr_b_event_l, // DDR4 thermal event
    output wire ddr_b_parout, // DDR4 command/address parity

    /**
     * DDR4 DIMM control and memory clocks
     */
    output wire [1:0] ddr_a0_cke, // DDR4 DIMM clock enable
    output wire [1:0] ddr_a0_cs_l, // DDR4 DIMM chip select
    output wire [1:0] ddr_a0_odt, // DDR4 on-die termination enable
    output wire [1:0] ddr_a1_cke, // DDR4 DIMM clock enable
    output wire [1:0] ddr_a1_cs_l, // DDR4 DIMM chip select
    output wire [1:0] ddr_a1_odt, // DDR4 on-die termination enable
    output wire [1:0] ddr_b0_cke, // DDR4 DIMM clock enable
    output wire [1:0] ddr_b0_cs_l, // DDR4 DIMM chip select
    output wire [1:0] ddr_b0_odt, // DDR4 on-die termination enable
    output wire [1:0] ddr_b1_cke, // DDR4 DIMM clock enable
    output wire [1:0] ddr_b1_cs_l, // DDR4 DIMM chip select
    output wire [1:0] ddr_b1_odt, // DDR4 on-die termination enable
    output wire [3:0] ddr_a_clk_h, // DDR4 differential clock high
    output wire [3:0] ddr_a_clk_l, // DDR4 differential clock low
    output wire [3:0] ddr_b_clk_h, // DDR4 differential clock high
    output wire [3:0] ddr_b_clk_l, // DDR4 differential clock low

    /**
     * PCIe root complex (P_GFX, P_GPP, P_HUB)
     */
    input wire [15:0] p_gfx_rxp, // P_GFX PCIe receive P lanes
    input wire [15:0] p_gfx_rxn, // P_GFX PCIe receive N lanes
    output wire [15:0] p_gfx_txp, // P_GFX PCIe transmit P lanes
    output wire [15:0] p_gfx_txn, // P_GFX PCIe transmit N lanes
    input wire [3:0] p_gpp_rxp, // P_GPP PCIe receive P lanes
    input wire [3:0] p_gpp_rxn, // P_GPP PCIe receive N lanes
    output wire [3:0] p_gpp_txp, // P_GPP PCIe transmit P lanes
    output wire [3:0] p_gpp_txn, // P_GPP PCIe transmit N lanes
    input wire [3:0] p_hub_rxp, // P_HUB PCIe receive P lanes
    input wire [3:0] p_hub_rxn, // P_HUB PCIe receive N lanes
    output wire [3:0] p_hub_txp, // P_HUB PCIe transmit P lanes
    output wire [3:0] p_hub_txn, // P_HUB PCIe transmit N lanes
    output wire pcie_rst_l, // PCIe reset
    output wire gfx_clkp, // 100 MHz PCIe reference clock P
    output wire gfx_clkn, // 100 MHz PCIe reference clock N
    output wire gpp_clk0p, // 100 MHz PCIe reference clock P
    output wire gpp_clk0n, // 100 MHz PCIe reference clock N
    output wire gpp_clk1p, // 100 MHz PCIe reference clock P
    output wire gpp_clk1n, // 100 MHz PCIe reference clock N
    output wire gpp_clk2p, // 100 MHz PCIe reference clock P
    output wire gpp_clk2n, // 100 MHz PCIe reference clock N
    output wire gpp_clk3p, // 100 MHz PCIe reference clock P
    output wire gpp_clk3n, // 100 MHz PCIe reference clock N

    /**
     * SATA (alternate function on GPP lanes)
     */
    output wire [1:0] sata_txp, // SATA transmit P, alternate function on GPP lanes
    output wire [1:0] sata_txn, // SATA transmit N, alternate function on GPP lanes
    input wire [1:0] sata_rxp, // SATA receive P, alternate function on GPP lanes
    input wire [1:0] sata_rxn, // SATA receive N, alternate function on GPP lanes
    output wire sata_act_l, // SATA activity LED

    /**
     * DisplayPort and panel control
     */
    output wire [3:0] dp0_txp, // DisplayPort main-link transmit P
    output wire [3:0] dp0_txn, // DisplayPort main-link transmit N
    inout wire dp0_auxp, // DisplayPort AUX P
    inout wire dp0_auxn, // DisplayPort AUX N
    input wire dp0_hpd, // DisplayPort hot-plug detect
    output wire [3:0] dp1_txp, // DisplayPort main-link transmit P
    output wire [3:0] dp1_txn, // DisplayPort main-link transmit N
    inout wire dp1_auxp, // DisplayPort AUX P
    inout wire dp1_auxn, // DisplayPort AUX N
    input wire dp1_hpd, // DisplayPort hot-plug detect
    output wire [3:0] dp2_txp, // DisplayPort main-link transmit P
    output wire [3:0] dp2_txn, // DisplayPort main-link transmit N
    inout wire dp2_auxp, // DisplayPort AUX P
    inout wire dp2_auxn, // DisplayPort AUX N
    input wire dp2_hpd, // DisplayPort hot-plug detect
    output wire dp_blon, // Display backlight enable
    output wire dp_digon, // Display power enable
    output wire dp_vary_bl, // Display backlight brightness control
    output wire dp_stereosync, // StereoSync output

    /**
     * USB 2.0 / SuperSpeed host ports
     */
    inout wire usb_hsd0p, // USB 2.0 high-speed D+/D- pair
    inout wire usb_hsd0n, // USB 2.0 high-speed D+/D- pair
    input wire usb_ss_0rxp, // USB SuperSpeed receive P
    input wire usb_ss_0rxn, // USB SuperSpeed receive N
    output wire usb_ss_0txp, // USB SuperSpeed transmit P
    output wire usb_ss_0txn, // USB SuperSpeed transmit N
    input wire usb_oc0_l, // USB over-current input
    inout wire usb_hsd1p, // USB 2.0 high-speed D+/D- pair
    inout wire usb_hsd1n, // USB 2.0 high-speed D+/D- pair
    input wire usb_ss_1rxp, // USB SuperSpeed receive P
    input wire usb_ss_1rxn, // USB SuperSpeed receive N
    output wire usb_ss_1txp, // USB SuperSpeed transmit P
    output wire usb_ss_1txn, // USB SuperSpeed transmit N
    input wire usb_oc1_l, // USB over-current input
    inout wire usb_hsd2p, // USB 2.0 high-speed D+/D- pair
    inout wire usb_hsd2n, // USB 2.0 high-speed D+/D- pair
    input wire usb_ss_2rxp, // USB SuperSpeed receive P
    input wire usb_ss_2rxn, // USB SuperSpeed receive N
    output wire usb_ss_2txp, // USB SuperSpeed transmit P
    output wire usb_ss_2txn, // USB SuperSpeed transmit N
    input wire usb_oc2_l, // USB over-current input
    inout wire usb_hsd3p, // USB 2.0 high-speed D+/D- pair
    inout wire usb_hsd3n, // USB 2.0 high-speed D+/D- pair
    input wire usb_ss_3rxp, // USB SuperSpeed receive P
    input wire usb_ss_3rxn, // USB SuperSpeed receive N
    output wire usb_ss_3txp, // USB SuperSpeed transmit P
    output wire usb_ss_3txn, // USB SuperSpeed transmit N
    input wire usb_oc3_l, // USB over-current input

    /**
     * Firmware SPI, eSPI, and LPC
     */
    inout wire spi_clk, // SPI/eSPI/LPC related
    inout wire spi_cs1_l, // SPI/eSPI/LPC related
    inout wire spi_cs2_l, // SPI/eSPI/LPC related
    inout wire spi_tpm_cs_l, // SPI/eSPI/LPC related
    inout wire spi_do, // SPI/eSPI/LPC related
    inout wire spi_di, // SPI/eSPI/LPC related
    inout wire spi_wp_l, // SPI/eSPI/LPC related
    inout wire spi_hold_l, // SPI/eSPI/LPC related
    inout wire espi_alert_l, // SPI/eSPI/LPC related
    inout wire espi_reset_l, // SPI/eSPI/LPC related
    inout wire lpc_pme_l, // SPI/eSPI/LPC related
    inout wire lpc_rst_l, // SPI/eSPI/LPC related
    inout wire lpc_clkrun_l, // SPI/eSPI/LPC related
    inout wire lpc_pd_l, // SPI/eSPI/LPC related
    inout wire lframe_l, // SPI/eSPI/LPC related
    inout wire serirq, // SPI/eSPI/LPC related
    inout wire [3:0] lad, // LPC command/address/data
    output wire [1:0] lpcclk, // LPC clock
    input wire ldrq0_l, // LPC DMA/bus-master request

    /**
     * HD Audio and PC speaker
     */
    output wire az_rst_l, // HD Audio reset
    output wire az_sync, // HD Audio sync
    output wire az_sdout, // HD Audio serial data output
    input wire [2:0] az_sdin, // HD Audio serial data inputs
    output wire az_bitclk, // HD Audio bit clock
    output wire spkr, // PC speaker PWM

    /**
     * GPIO, SMBus/I2C, SGPIO, fan, and generic interrupts
     */
    inout wire [133:0] agpio, // Advanced GPIO aggregate; sparse actual pins only
    inout wire [133:0] egpio, // Enhanced GPIO aggregate; sparse actual pins only
    inout wire sda0, // SMBus/I2C data
    inout wire scl0, // SMBus/I2C clock
    inout wire sda1, // SMBus/I2C data
    inout wire scl1, // SMBus/I2C clock
    output wire sgpio0_clk, // SGPIO clock
    output wire sgpio0_load, // SGPIO load
    output wire sgpio0_dataout, // SGPIO data out
    input wire sgpio0_datain, // SGPIO data in
    input wire [1:0] genint_l, // Generic interrupts
    input wire fanin0, // Fan tachometer input
    output wire fanout0, // Fan PWM output

    /**
     * Crystals and clock outputs
     */
    inout wire x48m_x1, // Crystal pin
    inout wire x48m_x2, // Crystal pin
    inout wire x32k_x1, // Crystal pin
    inout wire x32k_x2, // Crystal pin
    output wire rtcclk, // RTC clock output
    output wire osc_48m, // 48 MHz oscillator output

    /**
     * Power management, reset, sleep, and buttons
     */
    input wire pwr_good, // Power good from board
    output wire pwrok, // Processor power OK
    inout wire reset_l, // Processor reset
    input wire rsmrst_l, // Resume reset
    input wire sys_reset_l, // System reset button
    input wire pwr_btn_l, // Power button
    output wire slp_s3_l, // S3 sleep-state control
    output wire slp_s5_l, // S5 sleep-state control
    input wire wake_l, // Wake input
    output wire blink, // S-state LED blink
    output wire s5_mux_ctrl, // S5 mux control

    /**
     * Serial VID, thermal, and sideband (SB-TSI)
     */
    output wire svc, // Serial VID clock
    inout wire svd, // Serial VID data
    input wire svt, // Serial VID telemetry
    output wire sic, // Sideband/SB-TSI clock
    inout wire sid, // Sideband/SB-TSI data
    input wire alert_l, // Programmable alert/SB-TSI interrupt
    input wire prochot_l, // Processor hot / throttle request
    inout wire thermtrip_l, // Thermal trip

    /**
     * JTAG, debug, and strap identifiers
     */
    input wire tck, // JTAG clock
    input wire tdi, // JTAG data in
    output wire tdo, // JTAG data out
    input wire tms, // JTAG mode select
    input wire trst_l, // JTAG reset
    input wire dbreq_l, // Debug request
    output wire dbrdy, // Debug ready
    output wire [1:0] coretype, // Core type indicators
    output wire am4r1 // Processor family revision identifier
);
endmodule
