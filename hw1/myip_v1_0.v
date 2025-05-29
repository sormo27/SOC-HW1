`timescale 1ns / 1ps

module myip_v1_0 #(
  parameter integer C_S_AXI_DATA_WIDTH = 32,  // AXI 資料寬度
  parameter integer C_S_AXI_ADDR_WIDTH = 4    // AXI 位址寬度
)(
  // ----------------------------------------
  // 1) 使用者介面 (User ports)
  // ----------------------------------------
  input  wire               s00_axi_aclk,    // AXI 時鐘
  input  wire               s00_axi_aresetn, // AXI 重置，低電位有效
  input  wire [7:0]         sw_i,            // 板上撥動開關 SW[7:0]
  output wire [7:0]         led_o,           // 板上 LED[7:0]

  // ----------------------------------------
  // 2) AXI4-Lite 從屬介面 (Slave Interface)
  // ----------------------------------------
  input  wire [C_S_AXI_ADDR_WIDTH-1:0]  s00_axi_awaddr,  // 寫位址
  input  wire                          s00_axi_awvalid, // 寫位址有效
  output wire                          s00_axi_awready, // 寫位址準備好
  input  wire [C_S_AXI_DATA_WIDTH-1:0] s00_axi_wdata,    // 寫資料
  input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0] s00_axi_wstrb, // 寫 byte 掩碼
  input  wire                          s00_axi_wvalid,  // 寫資料有效
  output wire                          s00_axi_wready,  // 寫資料準備好
  output wire [1:0]                    s00_axi_bresp,   // 寫回應
  output wire                          s00_axi_bvalid,  // 寫回應有效
  input  wire                          s00_axi_bready,  // 寫回應準備好
  input  wire [C_S_AXI_ADDR_WIDTH-1:0] s00_axi_araddr,  // 讀位址
  input  wire                          s00_axi_arvalid, // 讀位址有效
  output wire                          s00_axi_arready, // 讀位址準備好
  output wire [C_S_AXI_DATA_WIDTH-1:0] s00_axi_rdata,    // 讀資料
  output wire [1:0]                    s00_axi_rresp,   // 讀回應
  output wire                          s00_axi_rvalid,  // 讀資料有效
  input  wire                          s00_axi_rready   // 讀資料準備好
);

  // ------------------------------------------------
  // 內部信號：AXI Core 產生的 8-bit Pattern
  // ------------------------------------------------
  wire [7:0] pattern8;

  // ------------------------------------------------
  // 1) 實例化純 RTL 模組 led_sw
  //    功能：將 pattern8 直接驅動至 LED
  // ------------------------------------------------
  led_sw u_led_sw (
    .clk     (s00_axi_aclk),     // 使用 AXI 時鐘
    .rst_n   (s00_axi_aresetn),  // 使用 AXI 重置信號
    .pattern (pattern8),         // 由 AXI Core 寫入的 Pattern[7:0]
    .led_out (led_o)             // 輸出至板上 LED
  );

  // ------------------------------------------------
  // 2) 實例化 AXI4-Lite 從屬核心
  //    功能：管理四個 32-bit 寄存器，寄存器 2 為 Pattern, 寄存器 3 為 Status
  // ------------------------------------------------
  myip_v1_0_S00_AXI #(
    .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
  ) axi_inst (
    // 時鐘與重置
    .S_AXI_ACLK    (s00_axi_aclk),
    .S_AXI_ARESETN (s00_axi_aresetn),

    // 寫位址通道
    .S_AXI_AWADDR  (s00_axi_awaddr),
    .S_AXI_AWVALID (s00_axi_awvalid),
    .S_AXI_AWREADY (s00_axi_awready),

    // 寫資料通道
    .S_AXI_WDATA   (s00_axi_wdata),
    .S_AXI_WSTRB   (s00_axi_wstrb),
    .S_AXI_WVALID  (s00_axi_wvalid),
    .S_AXI_WREADY  (s00_axi_wready),

    // 寫回應通道
    .S_AXI_BRESP   (s00_axi_bresp),
    .S_AXI_BVALID  (s00_axi_bvalid),
    .S_AXI_BREADY  (s00_axi_bready),

    // 讀位址通道
    .S_AXI_ARADDR  (s00_axi_araddr),
    .S_AXI_ARVALID (s00_axi_arvalid),
    .S_AXI_ARREADY (s00_axi_arready),

    // 讀資料通道
    .S_AXI_RDATA   (s00_axi_rdata),
    .S_AXI_RRESP   (s00_axi_rresp),
    .S_AXI_RVALID  (s00_axi_rvalid),
    .S_AXI_RREADY  (s00_axi_rready),

    // User 端口
    .sw_in    (sw_i),       // 從外部 SW 讀取狀態
    .o_pattern(pattern8)   // 輸出低 8-bit 給 led_sw
  );

endmodule


