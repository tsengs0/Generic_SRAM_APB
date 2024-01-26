`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:     
// Design Name: 
// Module Name:    top 
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

module top(clk, hit, stay, rst, ld, digi_an, digi_seg);
    input clk;
    input hit;
    input stay;
    input rst;
	  output [7:0] ld;
    output [3:0] digi_an;
    output [7:0] digi_seg;
    
    randomnum_intf #(.N(4)) int3();
    display_intf int4();


randomnum	randomnumber(clk, rst, int3);

controller	main_controller(clk, rst, int3, hit, stay, int4);

display	output_display(clk, rst, int4, ld, digi_an, digi_seg);
							
endmodule

