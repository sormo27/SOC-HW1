`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/05/29 17:51:20
// Design Name: 
// Module Name: led_sw
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module led_sw(
    input  wire        clk,       // AXI clock
    input  wire        rst_n,     // AXI resetn (active-low)
    input  wire [7:0]  pattern,   // 由 AXI core 寄存器寫入
    output reg  [7:0]  led_out    // 連到板上 LED0~LED7
    );

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      led_out <= 8'b0;
    else
      led_out <= pattern;
  end

endmodule
