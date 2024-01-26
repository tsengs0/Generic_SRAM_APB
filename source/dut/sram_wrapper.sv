// Latest revision: 18 October, 2023
// Developer: Bo-Yu Tseng
// Email: 
// Module name: sram_wrapper
// 
// # I/F
// 1) Output:
// 2) Input:
// 
// # Param
// 
// # Description
// A SRAM wrapper which complies with APB protocol for any R/W access
//
// # Dependencies
//  1) apb_sram_pkg.sv -> to define property of APB I/F and address mapping for SRAM
// 	2) apb_if.sv -> to declare the APB I/F
//
module sram_wrapper 
    import apb_sram_pkg::*;
(
    output apb_sram_pkg::apb_data_t rdata_o,
    apb_sram_if.slave apb_if_s0
);

// Internal siganls
logic [SRAM_READ_CYCLE-1:0] read_cycle;
logic [SRAM_WRITE_CYCLE-1:0] write_cycle;
logic access_en;
logic invalid_access; // R/W target outside the underlying memory region
apb_sram_pkg::apb_addr_t sram_addr;
logic sram_gclk; 
logic sram_we;
logic rstn;
apb_sram_pkg::apb_data_t sram_rdata;
apb_sram_pkg::apb_data_t sram_wdata;

// Basis of APB-protocol checker
assign access_en = apb_if_s0.PSEL && apb_if_s0.PENABLE; 
assign invalid_access = (apb_if_s0.PADDR > (PAGE_NUM-1)) ? 1'b1 : 1'b0;
assign sram_gclk = apb_if_s0.PCLK & apb_if_s0.PSEL;
assign rstn = apb_if_s0.PRESETn;

// Bridge between APB I/F and SRAM I/F
assign apb_if_s0.PRDATA = (!rstn) ? {DATA_WIDTH{1'b0}} : sram_rdata;
assign sram_wdata = apb_if_s0.PWDATA;
assign sram_addr  = apb_if_s0.PADDR;
assign sram_we    = apb_if_s0.PWRITE;

// Multi-cycle of R/W access
generate 
    if(SRAM_READ_CYCLE > 1) begin
        always @(posedge sram_gclk) begin
            if(!rstn) 
                read_cycle <= 1;
            else if(sram_we == 1'b0 && access_en == 1'b1) 
                read_cycle[SRAM_READ_CYCLE-1:0] <= {read_cycle[SRAM_READ_CYCLE-2:0], 1'b0};
            else 
                read_cycle <= 1;
        end
    end
    else 
        assign read_cycle[0] = access_en; // read latency: one clock cycle

    if(SRAM_WRITE_CYCLE > 1) begin
        always @(posedge sram_gclk) begin
            if(!rstn) 
                write_cycle <= 1;
            else if(sram_we == 1'b1 && access_en == 1'b1) 
                write_cycle[SRAM_WRITE_CYCLE-1:0] <= {write_cycle[SRAM_WRITE_CYCLE-2:0], 1'b0};
            else 
                write_cycle <= 1;
        end
    end
    else 
        assign write_cycle[0] = access_en; // write latency: one clock cycle
endgenerate
assign apb_if_s0.PREADY = read_cycle[SRAM_READ_CYCLE-1] | write_cycle[SRAM_WRITE_CYCLE-1];
assign apb_if_s0.PSLVERR = apb_if_s0.PREADY & invalid_access;

// Instantiation of single-port SRAM block
sram_1bankX1port #(
    .QUAN_SIZE(DATA_WIDTH),
    .PAGE_NUM(PAGE_NUM),
    .ADDR_BITWIDTH(ADDR_WIDTH)
) mem (
    .read_page_o   (sram_rdata),
    .write_data_i  (sram_wdata),
    .access_addr_i (sram_addr),
    .we_i          (sram_we),
    .sys_clk       (sram_gclk)
);
endmodule