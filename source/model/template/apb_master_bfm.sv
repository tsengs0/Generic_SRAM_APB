interface apb_master_bfm #(
    DATA_WIDTH = 32,
    ADDR_WIDTH = 32
) (
    output logic [ADDR_WIDTH-1:0] PWADDR,
    output logic [DATA_WIDTH-1:0] PWDATA,
    output logic PSEL,
    output logic PENABLE,
    output logic PWRITE,

    input logic [DATA_WIDT-1:0] PRDATA,
    input logic PREADY
    input bit PCLK,
    input logic PRESETn
);

`include "uvm_macros.svh"
import uvm_pkg::*;

function void clear_reqPort;
    PSEL <= 0;
    PENABLE <= 0;
    PWADDR <= {DATA_WIDTH{1'bx}};
endfunction
  
task drive (apb_seq_item req);
  int psel_index;
  
  repeat(req.delay)
    @(posedge PCLK);
  psel_index = sel_lookup(req.addr);
  if(psel_index >= 0) begin
    PSEL[psel_index] <= 1;
    PADDR <= req.addr;
    PWDATA <= req.data;
    PWRITE <= req.we;
    @(posedge PCLK);
    PENABLE <= 1;
    while (!PREADY)
      @(posedge PCLK);
    if(PWRITE == 0) begin
      req.data = PRDATA;
      `uvm_info("APB_DRV_RUN:", $sformatf("Starting read transmission: addr %0h - WE %b - RDATA %0h", req.addr, req.we, req.data), UVM_LOW)
    end
    else begin
      `uvm_info("APB_DRV_RUN:", $sformatf("Starting write transmission: addr %0h - WE %b - WDATA %0h", req.we, req.we, req.data), UVM_LOW)
    end
  end
  else begin
    `uvm_error("RUN", $sformatf("Access to addr %0h out of APB address range", req.addr))
    req.error = 1;
  end
endtask : drive

// Looks up the address and returns PSEL line that should be activated
// If the address is invalid, a non positive integer is returned to indicate an error
function int sel_lookup(logic[31:0] address);
  for(int i = 0; i < m_cfg.no_select_lines; i++) begin
    if((address >= m_cfg.start_address[i]) && (address <= (m_cfg.start_address[i] + m_cfg.range[i]))) begin
      return i;
    end
  end
  return -1; // Error: Address not found
endfunction
endinterface