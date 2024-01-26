/*
two column banks inside one memory cell
two/one interleaving banks inside one memory cell

Total amount of compression pattens in one column bank: ${2^{2W-1}} \over {2^{W-1}} = 2^W$.
Size of one compression pattern: W bits.
____________________________________________________________________________________________________________________________________
| Type ID | Bank interleaving | W [bit] | Configuration                 | memory bit | Preload cycle [cc] | LUTRAM | Logic LUT | FF |
|_________|___________________|_________|_______________________________|____________|____________________|________|___________|____|
| 1       | single bank       | 3       | 16 pages x 3 bits             | 48         | 16                 | 2      | 1         | 3  |                 
|------------------------------------------------------------------------------------------------------------------|-----------|----|
| 2       | two bank          | 3       | (8 pages x 3 bits) x 2 banks  | 48         | 8                  | 3      | 3         | 12 |                 
|------------------------------------------------------------------------------------------------------------------|-----------|----|
| 3       | single bank       | 4       | 32 pages x 4 bits             | 128        | 32                 | 2      | 1         | 4  |                 
|------------------------------------------------------------------------------------------------------------------------------|----|
| 4       | two bank          | 4       | (16 pages x 4 bits) x 2 banks | 128        | 16                 | 4      | 3         | 16 |                 
|_________|___________________|_________|_______________________________|____________|____________________|________|___________|____|
*/
module sram_area_eval (
output wire [3-1:0] read_page_u0,
input wire [3-1:0] write_data_u0,
input wire [4-1:0] access_addr_u0,
input wire we_u0,
input wire sys_clk_u0,

output wire [(3*2)-1:0] read_page_u1,
output wire [3-1:0] read_word_u1,
input wire [(3*2)-1:0] write_data_u1,
input wire [3-1:0] access_addr_u1,
input wire [0:0] read_strobe_u1,
input wire we_u1,
input wire sys_clk_u1,

output wire [4-1:0] read_page_u2,
input wire [4-1:0] write_data_u2,
input wire [5-1:0] access_addr_u2,
input wire we_u2,
input wire sys_clk_u2,

output wire [(4*2)-1:0] read_page_u3,
output wire [4-1:0] read_word_u3,
input wire [(4*2)-1:0] write_data_u3,
input wire [4-1:0] access_addr_u3,
input wire [0:0] read_strobe_u3,
input wire we_u3,
input wire sys_clk_u3,
//---------------------------------------
output wire [3-1:0] read_page_u4,
input wire [3-1:0] write_data_u4,
input wire [4-1:0] write_addr_u4,
input wire [4-1:0] read_addr_u4,
input wire we_u4,
input wire write_clk_u4,
input wire read_clk_u4,

output wire [(3*2)-1:0] read_page_u5,
output wire [3-1:0] read_word_u5,
input wire [(3*2)-1:0] write_data_u5,
input wire [3-1:0] write_addr_u5,
input wire [3-1:0] read_addr_u5,
input wire [0:0] read_strobe_u5,
input wire we_u5,
input wire write_clk_u5,
input wire read_clk_u5,

output wire [4-1:0] read_page_u6,
input wire [4-1:0] write_data_u6,
input wire [5-1:0] write_addr_u6,
input wire [5-1:0] read_addr_u6,
input wire we_u6,
input wire write_clk_u6,
input wire read_clk_u6,

output wire [(4*2)-1:0] read_page_u7,
output wire [4-1:0] read_word_u7,
input wire [(4*2)-1:0] write_data_u7,
input wire [4-1:0] write_addr_u7,
input wire [4-1:0] read_addr_u7,
input wire [0:0] read_strobe_u7,
input wire we_u7,
input wire write_clk_u7,
input wire read_clk_u7
);
//---------------------------------------------
// Instantiation of single-port RAM
//---------------------------------------------
sram_1bankX1port #(
    .QUAN_SIZE(3),
    .PAGE_NUM(16),
    .ADDR_BITWIDTH(4)
) lutMem_1bankX1port_3b (
    .read_page_o   (read_page_u0),
    .write_data_i  (write_data_u0),
    .access_addr_i (access_addr_u0),
    .we_i          (we_u0),
    .sys_clk       (sys_clk_u0)
);
//-----------------------------------
sram_2bankX1port #(
    .QUAN_SIZE(3),
    .PAGE_NUM(8),
    .BANK_INTERLEAVE(2),
    .ADDR_BITWIDTH(3)
) lutMem_2bankX1port_3b (
    .read_page_o   (read_page_u1),
    .read_word_o   (read_word_u1),
    .write_data_i  (write_data_u1),
    .access_addr_i (access_addr_u1),
    .read_strobe_i (read_strobe_u1),
    .we_i          (we_u1),
    .sys_clk       (sys_clk_u1)
);
//-----------------------------------
sram_1bankX1port #(
    .QUAN_SIZE(4),
    .PAGE_NUM(32),
    .ADDR_BITWIDTH(5)
) lutMem_1bankX1port_4b (
    .read_page_o   (read_page_u2),
    .write_data_i  (write_data_u2),
    .access_addr_i (access_addr_u2),
    .we_i          (we_u2),
    .sys_clk       (sys_clk_u2)
);
//-----------------------------------
sram_2bankX1port #(
    .QUAN_SIZE(4),
    .PAGE_NUM(16),
    .BANK_INTERLEAVE(2),
    .ADDR_BITWIDTH(4)
) lutMem_2bankX1port_4b (
    .read_page_o   (read_page_u3),
    .read_word_o   (read_word_u3),
    .write_data_i  (write_data_u3),
    .access_addr_i (access_addr_u3),
    .read_strobe_i (read_strobe_u3),
    .we_i          (we_u3),
    .sys_clk       (sys_clk_u3)
);

//---------------------------------------------
// Instantiation of pseudo/simple dual-port RAM
//---------------------------------------------
sram_1bank_sdp #(
    .QUAN_SIZE(3),
    .PAGE_NUM(16),
    .ADDR_BITWIDTH(4)
) lutMem_1bank_sdp_3b (
    .read_page_o   (read_page_u4),
    .write_data_i  (write_data_u4),
    .write_addr_i (write_addr_u4),
    .read_addr_i (read_addr_u4),
    .we_i          (we_u4),
    .write_clk       (write_clk_u4),
    .read_clk       (read_clk_u4)
);
//-----------------------------------
sram_2bank_sdp #(
    .QUAN_SIZE(3),
    .PAGE_NUM(8),
    .BANK_INTERLEAVE(2),
    .ADDR_BITWIDTH(3)
) lutMem_2bank_sdp_3b (
    .read_page_o   (read_page_u5),
    .read_word_o   (read_word_u5),
    .write_data_i  (write_data_u5),
    .write_addr_i (write_addr_u5),
    .read_addr_i (read_addr_u5),
    .read_strobe_i (read_strobe_u5),
    .we_i          (we_u5),
    .write_clk       (write_clk_u5),
    .read_clk       (read_clk_u5)
);
//-----------------------------------
sram_1bank_sdp #(
    .QUAN_SIZE(4),
    .PAGE_NUM(32),
    .ADDR_BITWIDTH(5)
) lutMem_1bank_sdp_4b (
    .read_page_o   (read_page_u6),
    .write_data_i  (write_data_u6),
    .write_addr_i (write_addr_u6),
    .read_addr_i (read_addr_u6),
    .we_i          (we_u6),
    .write_clk       (write_clk_u6),
    .read_clk       (read_clk_u6)
);
//-----------------------------------
sram_2bank_sdp #(
    .QUAN_SIZE(4),
    .PAGE_NUM(16),
    .BANK_INTERLEAVE(2),
    .ADDR_BITWIDTH(4)
) lutMem_2bank_sdp_4b (
    .read_page_o   (read_page_u7),
    .read_word_o   (read_word_u7),
    .write_data_i  (write_data_u7),
    .write_addr_i (write_addr_u7),
    .read_addr_i (read_addr_u7),
    .read_strobe_i (read_strobe_u7),
    .we_i          (we_u7),
    .write_clk       (write_clk_u7),
    .read_clk       (read_clk_u7)
);
endmodule

// Synchronous write and read
module sram_1bankX1port #(
	parameter QUAN_SIZE = 3,
    parameter PAGE_NUM = 16,
	parameter ADDR_BITWIDTH = 4
) (
    output wire [QUAN_SIZE-1:0] read_page_o,
 
    input wire [QUAN_SIZE-1:0] write_data_i,
    input wire [ADDR_BITWIDTH-1:0] access_addr_i,
    input wire we_i,
    input wire sys_clk
);

(* ram_style = "distributed" *) reg [QUAN_SIZE-1:0] mem [0:PAGE_NUM-1];
reg [QUAN_SIZE-1:0] mem_out;
always @(posedge sys_clk) begin
    if(we_i == 1'b1)
        mem[access_addr_i] <= write_data_i[QUAN_SIZE-1:0];
    else 
        mem_out[QUAN_SIZE-1:0] <= mem[access_addr_i];
end
assign read_page_o[QUAN_SIZE-1:0] = mem_out[QUAN_SIZE-1:0];
endmodule

// Synchronous write and asynchronous read
module rdAsync_sram_1bankX1port #(
	parameter QUAN_SIZE = 3,
    parameter PAGE_NUM = 16,
	parameter ADDR_BITWIDTH = 4
) (
    output wire [QUAN_SIZE-1:0] read_page_o,
 
    input wire [QUAN_SIZE-1:0] write_data_i,
    input wire [ADDR_BITWIDTH-1:0] access_addr_i,
    input wire we_i,
    input wire sys_clk
);

(* ram_style = "distributed" *) reg [QUAN_SIZE-1:0] mem [0:PAGE_NUM-1];

always @(posedge sys_clk) begin
    if(we_i == 1'b1)
        mem[access_addr_i] <= write_data_i[QUAN_SIZE-1:0];
end

assign read_page_o[QUAN_SIZE-1:0] = mem[access_addr_i];
endmodule
//--------------------------------------------------------------------------------------------------------------------
// Asynchronous single-port RAM
// synchronous write and asynchronous read
// Xilinx LUTRAM inferrable by setting the parameter as "XILINX_LUTRAM_INFER=1"
module sram_async_1bankX1port_3b #(
	parameter QUAN_SIZE = 3,
    parameter PAGE_NUM = 32,
	parameter ADDR_BITWIDTH = 5,
    parameter XILINX_LUTRAM_INFER = 1
) (
    output wire [QUAN_SIZE-1:0] read_page_o,

    input wire [ADDR_BITWIDTH-1:0] read_addr_i,
    input wire [ADDR_BITWIDTH-1:0] write_data_i,
    input wire [QUAN_SIZE-1:0] write_addr_i,
    input wire we_i,
    input wire write_clk
);

generate
    // The following construction is only for Xilinx FPGA-specific optimality
    if(XILINX_LUTRAM_INFER==1) begin
        (* ram_style="distributed" *) reg [1:0] lut_page_bitData_port0_0 [0:PAGE_NUM-1];
        (* ram_style="distributed" *) reg [0:0] lut_page_bitData_port0_1 [0:PAGE_NUM-1];
        assign read_page_o = {lut_page_bitData_port0_0[ read_addr_i[ADDR_BITWIDTH-1:0] ][1:0], lut_page_bitData_port0_1[ read_addr_i[ADDR_BITWIDTH-1:0] ][0:0]};
        always @(posedge write_clk) begin
         if(we_i == 1'b1)	begin 
             lut_page_bitData_port0_0[ write_data_i[ADDR_BITWIDTH-1:0] ][1:0] <= write_data_i[2:1];
             lut_page_bitData_port0_1[ write_data_i[ADDR_BITWIDTH-1:0] ][0:0] <= write_data_i[0:0];
         end
        end
    end
endgenerate
endmodule

module sram_2bankX1port #(
	parameter QUAN_SIZE = 3,
    parameter PAGE_NUM = 16,
    parameter BANK_INTERLEAVE = 2,
	parameter ADDR_BITWIDTH = 4
) (
    output wire [(QUAN_SIZE*BANK_INTERLEAVE)-1:0] read_page_o,
    output wire [QUAN_SIZE-1:0] read_word_o,
 
    input wire [(QUAN_SIZE*BANK_INTERLEAVE)-1:0] write_data_i,
    input wire [ADDR_BITWIDTH-1:0] access_addr_i,
    input wire [0:0] read_strobe_i,
    input wire we_i,
    input wire sys_clk
);

localparam PAGE_SIZE = (QUAN_SIZE*BANK_INTERLEAVE);
(* ram_style = "distributed" *) reg [PAGE_SIZE-1:0] mem [0:PAGE_NUM-1];
reg [PAGE_SIZE-1:0] mem_out;
always @(posedge sys_clk) begin
    if(we_i == 1'b1)
        mem[access_addr_i] <= write_data_i[PAGE_SIZE-1:0];
    else 
        mem_out[PAGE_SIZE-1:0] <= mem[access_addr_i];
end

assign read_word_o[QUAN_SIZE-1:0] = (read_strobe_i[0]==1'b0) ? mem_out[PAGE_SIZE-1:QUAN_SIZE] : mem_out[QUAN_SIZE-1:0];
assign read_page_o[PAGE_SIZE-1:0] = mem_out[PAGE_SIZE-1:0];
endmodule
//--------------------------------------------------------------------------------------------------------------------
// Pseudo/Simple dual-port RAM
module sram_1bank_sdp #(
	parameter QUAN_SIZE = 3,
    parameter PAGE_NUM = 16,
	parameter ADDR_BITWIDTH = 4
) (
    output wire [QUAN_SIZE-1:0] read_page_o,
 
    input wire [QUAN_SIZE-1:0] write_data_i,
    input wire [ADDR_BITWIDTH-1:0] write_addr_i,
    input wire [ADDR_BITWIDTH-1:0] read_addr_i,
    input wire we_i,
    input wire read_clk,
    input wire write_clk
);

(* ram_style = "distributed" *) reg [QUAN_SIZE-1:0] mem [0:PAGE_NUM-1];
wire [QUAN_SIZE-1:0] mem_out;
always @(posedge write_clk) begin
    if(we_i == 1'b1)
        mem[write_addr_i] <= write_data_i[QUAN_SIZE-1:0]; 
end
assign mem_out[QUAN_SIZE-1:0] = mem[read_addr_i];
assign read_page_o[QUAN_SIZE-1:0] = mem_out[QUAN_SIZE-1:0];
endmodule

module sram_2bank_sdp #(
	parameter QUAN_SIZE = 3,
    parameter PAGE_NUM = 16,
    parameter BANK_INTERLEAVE = 2,
	parameter ADDR_BITWIDTH = 4
) (
    output wire [(QUAN_SIZE*BANK_INTERLEAVE)-1:0] read_page_o,
    output wire [QUAN_SIZE-1:0] read_word_o,
 
    input wire [(QUAN_SIZE*BANK_INTERLEAVE)-1:0] write_data_i,
    input wire [ADDR_BITWIDTH-1:0] write_addr_i,
    input wire [ADDR_BITWIDTH-1:0] read_addr_i,
    input wire [0:0] read_strobe_i,
    input wire we_i,
    input wire read_clk,
    input wire write_clk
);

localparam PAGE_SIZE = (QUAN_SIZE*BANK_INTERLEAVE);
(* ram_style = "distributed" *) reg [PAGE_SIZE-1:0] mem [0:PAGE_NUM-1];
wire [PAGE_SIZE-1:0] mem_out;
always @(posedge write_clk) begin
    if(we_i == 1'b1)
        mem[write_addr_i] <= write_data_i[PAGE_SIZE-1:0];
end

assign mem_out[PAGE_SIZE-1:0] = mem[read_addr_i];
assign read_word_o[QUAN_SIZE-1:0] = (read_strobe_i[0]==1'b0) ? mem_out[PAGE_SIZE-1:QUAN_SIZE] : mem_out[QUAN_SIZE-1:0];
assign read_page_o[PAGE_SIZE-1:0] = mem_out[PAGE_SIZE-1:0];
endmodule