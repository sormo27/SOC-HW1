`timescale 1ns / 1ps

module myip_v1_0 #(
  parameter integer C_S_AXI_DATA_WIDTH = 32,  // AXI ��Ƽe��
  parameter integer C_S_AXI_ADDR_WIDTH = 4    // AXI ��}�e��
)(
  // ----------------------------------------
  // 1) �ϥΪ̤��� (User ports)
  // ----------------------------------------
  input  wire               s00_axi_aclk,    // AXI ����
  input  wire               s00_axi_aresetn, // AXI ���m�A�C�q�즳��
  input  wire [7:0]         sw_i,            // �O�W���ʶ}�� SW[7:0]
  output wire [7:0]         led_o,           // �O�W LED[7:0]

  // ----------------------------------------
  // 2) AXI4-Lite �q�ݤ��� (Slave Interface)
  // ----------------------------------------
  input  wire [C_S_AXI_ADDR_WIDTH-1:0]  s00_axi_awaddr,  // �g��}
  input  wire                          s00_axi_awvalid, // �g��}����
  output wire                          s00_axi_awready, // �g��}�ǳƦn
  input  wire [C_S_AXI_DATA_WIDTH-1:0] s00_axi_wdata,    // �g���
  input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0] s00_axi_wstrb, // �g byte ���X
  input  wire                          s00_axi_wvalid,  // �g��Ʀ���
  output wire                          s00_axi_wready,  // �g��ƷǳƦn
  output wire [1:0]                    s00_axi_bresp,   // �g�^��
  output wire                          s00_axi_bvalid,  // �g�^������
  input  wire                          s00_axi_bready,  // �g�^���ǳƦn
  input  wire [C_S_AXI_ADDR_WIDTH-1:0] s00_axi_araddr,  // Ū��}
  input  wire                          s00_axi_arvalid, // Ū��}����
  output wire                          s00_axi_arready, // Ū��}�ǳƦn
  output wire [C_S_AXI_DATA_WIDTH-1:0] s00_axi_rdata,    // Ū���
  output wire [1:0]                    s00_axi_rresp,   // Ū�^��
  output wire                          s00_axi_rvalid,  // Ū��Ʀ���
  input  wire                          s00_axi_rready   // Ū��ƷǳƦn
);

  // ------------------------------------------------
  // �����H���GAXI Core ���ͪ� 8-bit Pattern
  // ------------------------------------------------
  wire [7:0] pattern8;

  // ------------------------------------------------
  // 1) ��ҤƯ� RTL �Ҳ� led_sw
  //    �\��G�N pattern8 �����X�ʦ� LED
  // ------------------------------------------------
  led_sw u_led_sw (
    .clk     (s00_axi_aclk),     // �ϥ� AXI ����
    .rst_n   (s00_axi_aresetn),  // �ϥ� AXI ���m�H��
    .pattern (pattern8),         // �� AXI Core �g�J�� Pattern[7:0]
    .led_out (led_o)             // ��X�ܪO�W LED
  );

  // ------------------------------------------------
  // 2) ��Ҥ� AXI4-Lite �q�ݮ֤�
  //    �\��G�޲z�|�� 32-bit �H�s���A�H�s�� 2 �� Pattern, �H�s�� 3 �� Status
  // ------------------------------------------------
  myip_v1_0_S00_AXI #(
    .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
  ) axi_inst (
    // �����P���m
    .S_AXI_ACLK    (s00_axi_aclk),
    .S_AXI_ARESETN (s00_axi_aresetn),

    // �g��}�q�D
    .S_AXI_AWADDR  (s00_axi_awaddr),
    .S_AXI_AWVALID (s00_axi_awvalid),
    .S_AXI_AWREADY (s00_axi_awready),

    // �g��Ƴq�D
    .S_AXI_WDATA   (s00_axi_wdata),
    .S_AXI_WSTRB   (s00_axi_wstrb),
    .S_AXI_WVALID  (s00_axi_wvalid),
    .S_AXI_WREADY  (s00_axi_wready),

    // �g�^���q�D
    .S_AXI_BRESP   (s00_axi_bresp),
    .S_AXI_BVALID  (s00_axi_bvalid),
    .S_AXI_BREADY  (s00_axi_bready),

    // Ū��}�q�D
    .S_AXI_ARADDR  (s00_axi_araddr),
    .S_AXI_ARVALID (s00_axi_arvalid),
    .S_AXI_ARREADY (s00_axi_arready),

    // Ū��Ƴq�D
    .S_AXI_RDATA   (s00_axi_rdata),
    .S_AXI_RRESP   (s00_axi_rresp),
    .S_AXI_RVALID  (s00_axi_rvalid),
    .S_AXI_RREADY  (s00_axi_rready),

    // User �ݤf
    .sw_in    (sw_i),       // �q�~�� SW Ū�����A
    .o_pattern(pattern8)   // ��X�C 8-bit �� led_sw
  );

endmodule


