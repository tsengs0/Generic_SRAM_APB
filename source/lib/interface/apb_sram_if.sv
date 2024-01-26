interface apb_sram_if;
import apb_sram_pkg::*;

// APB request (master to slave)
apb_sram_pkg::apb_addr_t PADDR;
logic PSEL;
logic PENABLE;
logic PWRITE;
apb_sram_pkg::apb_data_t PWDATA;
// APB response (slave to master)
logic PREADY;
logic PSLVERR;
apb_sram_pkg::apb_data_t PRDATA;
// Clock and reset
bit PCLK;
logic PRESETn; // active LOW

// To specify the direction of each port from a master side
modport master (
    output PADDR,
           PSEL,
           PENABLE,
           PWRITE,
           PWDATA,
    input PREADY,
          PSLVERR,
          PRDATA,
          PCLK,
          PRESETn
);

// To specify the direction of each port from a slave side
modport slave (
    input PADDR,
          PSEL,
          PENABLE,
          PWRITE,
          PWDATA,
          PCLK,
          PRESETn,
    output PREADY,
           PSLVERR,
           PRDATA
);

// SVA 
// PSEL should never be either "X" or "Z"
property psel_valid;
    @(posedge PCLK) disable iff(PRESETn == 1'b0)
        !$isunknown(PSEL);
endproperty: psel_valid
PSEL_CHECK: assert property(psel_valid);
COVER_PSEL: cover property(psel_valid);
endinterface