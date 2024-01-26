`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:     
// Design Name: 
// Module Name:    display 
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

module display(
    input clk, rst,
    display_intf int1, 
	  output [7:0] ld,
    output [3:0] digi_an,
    output [7:0] digi_seg);

logic [7:0] ld_tmp;
logic [7:0]	ld;

assign	ld_tmp[7] = int1.won && !int1.lost;
assign	ld_tmp[6] = int1.won && !int1.lost;
assign	ld_tmp[5] = int1.won && !int1.lost;
assign	ld_tmp[4] = int1.won && !int1.lost;
assign	ld_tmp[3] = int1.won;
assign	ld_tmp[2] = int1.won;
assign	ld_tmp[1] = int1.won;
assign	ld_tmp[0] = int1.won || int1.lost;

always_ff @(posedge clk)
  if(rst)
    ld <= 8'd0;
  else
    ld <= ld_tmp;

logic [3:0]	digi_an;
logic [7:0]	digi_seg;

logic [7:0]	left_half1, left_half0, right_half1, right_half0;

always_comb
int1.digi_display(int1.won, int1.lost, int1.user_total, int1.fpga_total, left_half1, left_half0, right_half1, right_half0);  //task call


logic [1:0]	cnt;

always_ff @(posedge clk)
  if(rst)
    cnt <= 2'b00;
  else
    cnt <= cnt + 1'b1;
	 
always_ff @(posedge clk)
  if(rst)
    digi_an <= 4'b1111;
  else
    case(cnt)
	     2'b00:	digi_an <= 4'b0111;
		 2'b01:	digi_an <= 4'b1011;
		 2'b10:	digi_an <= 4'b1101;
		 2'b11:	digi_an <= 4'b1110;
	 endcase

always_ff @(posedge clk)
  if(rst)
    digi_seg <= 8'b11111111;
  else
    case(cnt)
	     2'b00:	digi_seg <= left_half1;
		 2'b01:	digi_seg <= left_half0;
		 2'b10:	digi_seg <= right_half1;
		 2'b11:	digi_seg <= right_half0;
   endcase
  

endmodule
