`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:     
// Design Name: 
// Module Name:    randomnum 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
// This example contains five files:
//   top.sv : top level module
//   controller.sv: submodule
//   randomnum.sv: submodule
//   display.sv: submodule
//   intf.sv: include file
// This example mainly demonstrates the following SystemVerilog structures:
// 1. interfaces
// 2. modports
// 3. tasks in interfaces
// 4. parameterized interfaces
//
//////////////////////////////////////////////////////////////////////////////////
`include "intf.sv"

module randomnum(
    input clk, rst,
    randomnum_intf.randomnum_p int2);

logic [3:0]	cnt;

always_ff @(posedge clk)
  if(rst)
    cnt <= 4'd1;
  else if(cnt == 4'd11)
    cnt <= 4'd1;
  else
    cnt <= cnt + 1'd1;

always_ff @(posedge clk)
  if(rst)
    int2.value <= 4'd0;
  else if(int2.request)
    int2.value <= cnt;
  else
    int2.value <= int2.value;

always_ff @(posedge clk)
  if(rst)
    int2.ready <= 1'b0;
  else
    int2.ready <= int2.request;

endmodule
