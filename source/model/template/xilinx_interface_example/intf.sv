`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:     
// Design Name: 
// Module Name:    intf 
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

interface randomnum_intf # (parameter N = 4);
  logic request, ready;
  logic [N-1:0] value;
  
  modport randomnum_p (input request, output ready, value);
  modport controller_p (input value, ready, output request);
  
endinterface

interface display_intf;
  logic won, lost;
  logic [4:0] user_total, fpga_total;
  
  task digi_display (input won, lost, 
                     input [4:0] user_total, fpga_total,
                     output [7:0] left_half1, left_half0, right_half1, right_half0
                     );
  
    case(user_total)
     5'b00000:	{left_half1, left_half0} = {8'b00000011,8'b00000010};//00
  	 5'b00001:	{left_half1, left_half0} = {8'b00000011,8'b10011110};//01
  	 5'b00010:	{left_half1, left_half0} = {8'b00000011,8'b00100100};//02
  	 5'b00011:	{left_half1, left_half0} = {8'b00000011,8'b00001100};//03
  	 5'b00100:	{left_half1, left_half0} = {8'b00000011,8'b10011000};//04
  	 5'b00101:	{left_half1, left_half0} = {8'b00000011,8'b01001000};//05
  	 5'b00110:	{left_half1, left_half0} = {8'b00000011,8'b01000000};//06
  	 5'b00111:	{left_half1, left_half0} = {8'b00000011,8'b00011110};//07
  	 5'b01000:	{left_half1, left_half0} = {8'b00000011,8'b00000000};//08
  	 5'b01001:	{left_half1, left_half0} = {8'b00000011,8'b00001000};//09
  	 5'b01010:	{left_half1, left_half0} = {8'b10011111,8'b00000010};//10
  	 5'b01011:	{left_half1, left_half0} = {8'b10011111,8'b10011110};//11
  	 5'b01100:	{left_half1, left_half0} = {8'b10011111,8'b00100100};//12
  	 5'b01101:	{left_half1, left_half0} = {8'b10011111,8'b00001100};//13
  	 5'b01110:	{left_half1, left_half0} = {8'b10011111,8'b10011000};//14
  	 5'b01111:	{left_half1, left_half0} = {8'b10011111,8'b01001000};//15
  	 5'b10000:	{left_half1, left_half0} = {8'b10011111,8'b01000000};//16
  	 5'b10001:	{left_half1, left_half0} = {8'b10011111,8'b00011110};//17
  	 5'b10010:	{left_half1, left_half0} = {8'b10011111,8'b00000000};//18
  	 5'b10011:	{left_half1, left_half0} = {8'b10011111,8'b00001000};//19
  	 5'b10100:	{left_half1, left_half0} = {8'b00100101,8'b00000010};//20
  	 5'b10101:	{left_half1, left_half0} = {8'b00100101,8'b10011110};//21
  	 5'b10110:	{left_half1, left_half0} = {8'b00100101,8'b00100100};//22
  	 5'b10111:	{left_half1, left_half0} = {8'b00100101,8'b00001100};//23
  	 5'b11000:	{left_half1, left_half0} = {8'b00100101,8'b10011000};//24
  	 5'b11001:	{left_half1, left_half0} = {8'b00100101,8'b01001000};//25
  	 5'b11010:	{left_half1, left_half0} = {8'b00100101,8'b01000000};//26
  	 5'b11011:	{left_half1, left_half0} = {8'b00100101,8'b00011110};//27
  	 5'b11100:	{left_half1, left_half0} = {8'b00100101,8'b00000000};//28
  	 5'b11101:	{left_half1, left_half0} = {8'b00100101,8'b00001000};//29
  	 5'b11110:	{left_half1, left_half0} = {8'b00001101,8'b00000010};//30
  	 5'b11111:	{left_half1, left_half0} = {8'b00001101,8'b10011110};//31
    endcase
  	 

    if(won || lost)
    case(fpga_total)
     5'b00000:	{right_half1, right_half0} = {8'b00000011,8'b00000011};//00
  	 5'b00001:	{right_half1, right_half0} = {8'b00000011,8'b10011111};//01
  	 5'b00010:	{right_half1, right_half0} = {8'b00000011,8'b00100101};//02
  	 5'b00011:	{right_half1, right_half0} = {8'b00000011,8'b00001101};//03
  	 5'b00100:	{right_half1, right_half0} = {8'b00000011,8'b10011001};//04
  	 5'b00101:	{right_half1, right_half0} = {8'b00000011,8'b01001001};//05
  	 5'b00110:	{right_half1, right_half0} = {8'b00000011,8'b01000001};//06
  	 5'b00111:	{right_half1, right_half0} = {8'b00000011,8'b00011111};//07
  	 5'b01000:	{right_half1, right_half0} = {8'b00000011,8'b00000001};//08
  	 5'b01001:	{right_half1, right_half0} = {8'b00000011,8'b00001001};//09
  	 5'b01010:	{right_half1, right_half0} = {8'b10011111,8'b00000011};//10
  	 5'b01011:	{right_half1, right_half0} = {8'b10011111,8'b10011111};//11
  	 5'b01100:	{right_half1, right_half0} = {8'b10011111,8'b00100101};//12
  	 5'b01101:	{right_half1, right_half0} = {8'b10011111,8'b00001101};//13
  	 5'b01110:	{right_half1, right_half0} = {8'b10011111,8'b10011001};//14
  	 5'b01111:	{right_half1, right_half0} = {8'b10011111,8'b01001001};//15
  	 5'b10000:	{right_half1, right_half0} = {8'b10011111,8'b01000001};//16
  	 5'b10001:	{right_half1, right_half0} = {8'b10011111,8'b00011111};//17
  	 5'b10010:	{right_half1, right_half0} = {8'b10011111,8'b00000001};//18
  	 5'b10011:	{right_half1, right_half0} = {8'b10011111,8'b00001001};//19
  	 5'b10100:	{right_half1, right_half0} = {8'b00100101,8'b00000011};//20
  	 5'b10101:	{right_half1, right_half0} = {8'b00100101,8'b10011111};//21
  	 5'b10110:	{right_half1, right_half0} = {8'b00100101,8'b00100101};//22
  	 5'b10111:	{right_half1, right_half0} = {8'b00100101,8'b00001101};//23
  	 5'b11000:	{right_half1, right_half0} = {8'b00100101,8'b10011001};//24
  	 5'b11001:	{right_half1, right_half0} = {8'b00100101,8'b01001001};//25
  	 5'b11010:	{right_half1, right_half0} = {8'b00100101,8'b01000001};//26
  	 5'b11011:	{right_half1, right_half0} = {8'b00100101,8'b00011111};//27
  	 5'b11100:	{right_half1, right_half0} = {8'b00100101,8'b00000001};//28
  	 5'b11101:	{right_half1, right_half0} = {8'b00100101,8'b00001001};//29
  	 5'b11110:	{right_half1, right_half0} = {8'b00001101,8'b00000011};//30
  	 5'b11111:	{right_half1, right_half0} = {8'b00001101,8'b10011111};//31
    endcase
    else
      {right_half1, right_half0} = {8'b11111111,8'b11111111};
      
    endtask
  
endinterface