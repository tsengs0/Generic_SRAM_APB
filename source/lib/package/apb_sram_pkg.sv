package apb_sram_pkg;

//-----------------------------------------------
// SRAM property
parameter SRAM_WRITE_CYCLE = 1; // must be greater than or equal to 1
parameter SRAM_READ_CYCLE = 1; // must be greater than or equal to 1
parameter PAGE_NUM = 256;
//-----------------------------------------------
// APB I/F steup
parameter ADDR_WIDTH = $clog2(PAGE_NUM);
parameter DATA_WIDTH = 32;
typedef logic [ADDR_WIDTH-1:0] apb_addr_t;
typedef logic [DATA_WIDTH-1:0] apb_data_t;

// Memory mapping for SRAM
typedef enum apb_addr_t { // dummy setup as RFU
    REG_0 = 'h00, // Address of REG_0
    REG_1 = 'h04, // Address of REG_1
    REG_2 = 'h08, // Address of REG_2
    REG_3 = 'h0C  // Address of REG_3
} addr_map_e;
endpackage