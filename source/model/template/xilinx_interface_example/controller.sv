`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:     
// Design Name: 
// Module Name:    controller 
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

module controller(
    input clk, rst,
    randomnum_intf.controller_p int2,
    input hit, stay,
    display_intf int1);


enum logic [2:0] {idle, userstage, fpgahit, fpgaopt, fpgastay, tiestate, wonstate, loststate} currentstate, nextstate;
logic		user, fpga;

assign	user = (currentstate == userstage);
assign	fpga = (currentstate == fpgahit) || (currentstate == fpgaopt);

logic [3:0]	adder;

always_ff @(posedge clk)
  if(rst)
    adder <= 4'd0;
  else if(int2.value == 4'd1)
    if((user && (int1.user_total > 5'd10)) ||
	    (fpga && (int1.fpga_total > 5'd10)))
	   adder <= 4'd1;
	  else
	   adder <= 4'd11;
    else
     adder <= int2.value;

logic		ready_d1,ready_d2;

always_ff @(posedge clk)
  if(rst)
    begin
	   ready_d1 <= 1'b0;
		 ready_d2 <= 1'b0;
	 end
  else
    begin
	   ready_d1 <= int2.ready;
		 ready_d2 <= ready_d1;
	 end
	 
always_ff @(posedge clk)
  if(rst)
    currentstate <= idle;
  else
    currentstate <= nextstate;


always_comb
  begin
    							nextstate <= idle;
    case(currentstate)
		idle:				if(hit)
						  		nextstate <= userstage;
								else
						  		nextstate <= idle;
						  
		userstage:	if(int1.user_total > 5'd21)
		              nextstate <= loststate;
								else if(stay)
						  		nextstate <= fpgahit;
								else
						  		nextstate <= userstage;
						  
		fpgahit:		
		              nextstate <= fpgaopt;
						  
		fpgaopt:		if(ready_d2 && (int1.fpga_total < 5'd17))
						  		nextstate <= fpgahit;
								else if(ready_d2 &&(int1.fpga_total >= 5'd17))
						  		nextstate <= fpgastay;
								else
						  		nextstate <= fpgaopt;
		
		fpgastay:		if(int1.fpga_total == int1.user_total)
		              nextstate <= tiestate;
								else if((int1.fpga_total > 5'd21) || (int1.user_total > int1.fpga_total))
						  		nextstate <= wonstate;
								else
						  		nextstate <= loststate;
						  
		tiestate:		if(hit)
						  		nextstate <= userstage;
								else
						  		nextstate <= tiestate;
						  
		wonstate:		if(hit)
		              nextstate <= userstage;
								else
						  		nextstate <= wonstate;
						  
		loststate:	if(hit)
		              nextstate <= userstage;
								else
						  		nextstate <= loststate;
						  
    endcase
  end

always_comb
  begin
    							{int2.request, int1.won, int1.lost} <= 3'b000;
    case(currentstate)
	   idle:			if(hit)
						  		{int2.request, int1.won, int1.lost} <= 3'b100;
								else
						  		{int2.request, int1.won, int1.lost} <= 3'b000;
						  
		userstage:	if(int1.user_total > 5'd21)
						  		{int2.request, int1.won, int1.lost} <= 3'b011;
								else begin
						  		{int1.won, int1.lost} <= 2'b00;
						  
						  	if(hit || stay)
						    	int2.request <= 1'b1;
						  	else
						    	int2.request <= 1'b0;
						end
						  
		fpgahit:		
		              {int2.request, int1.won, int1.lost} <= 3'b000;
						  
		fpgaopt:		if(ready_d2 && (int1.fpga_total < 5'd17))
						  		{int2.request, int1.won, int1.lost} <= 3'b100;
								else
						  		{int2.request, int1.won, int1.lost} <= 3'b000;
		
		fpgastay:		if(int1.fpga_total == int1.user_total)
		              {int2.request, int1.won, int1.lost} <= 3'b011;
								else if((int1.fpga_total > 5'd21) || (int1.user_total > int1.fpga_total))
						  		{int2.request, int1.won, int1.lost} <= 3'b010;
								else
						  		{int2.request, int1.won, int1.lost} <= 3'b001;
						  
		tiestate:		if(hit)
						  		{int2.request, int1.won, int1.lost} <= 3'b100;
								else
						  		{int2.request, int1.won, int1.lost} <= 3'b011;
						  
		wonstate:		if(hit)
		              {int2.request, int1.won, int1.lost} <= 3'b100;
								else
						  		{int2.request, int1.won, int1.lost} <= 3'b010;
						  
		loststate:	if(hit)
		              {int2.request, int1.won, int1.lost} <= 3'b100;
								else
						  		{int2.request, int1.won, int1.lost} <= 3'b001;
						  
    endcase	
  end


always_ff @(posedge clk)
  if(rst)
    int1.user_total <= 5'd0;
  else if(currentstate[2] && (currentstate[1:0] != 2'b00) && hit)
    int1.user_total <= 5'd0;
  else if(user && ready_d1)
    int1.user_total <= int1.user_total + adder;
  else 
    int1.user_total <= int1.user_total;

always_ff @(posedge clk)
  if(rst)
    int1.fpga_total <= 5'd0;
  else if(currentstate[2] && (currentstate[1:0] != 2'b00) && hit)
    int1.fpga_total <= 5'd0;
  else if(fpga && ready_d1)
    int1.fpga_total <= int1.fpga_total + adder;
  else
    int1.fpga_total <= int1.fpga_total; 
		
		

endmodule
