class sram_seq_item extends uvm_sequence_item;
import apb_sram_pkg::*;

logic PRESETn;
logic PSEL;
logic PENABLE;
rand logic pwrite;
rand logic [ADDR_WIDTH-1:0] pwaddr;
rand logic [DATA_WIDTH-1:0] pwdata;

constraint addr_range { pwaddr inside {[0:PAGE_NUM]}; }
task reset_sys;
    this.preset <= 0;
    this.psel <= 0;
    this.penable <= 0;
    this.pwdata <= 0;
    this.pwaddr <= 0;
endtask

task read_data;
    this.preset <= 0;
    this.psel <= 1;
    this.penable <= 1;
    this.pwrite <= 0;
endtask

task write_data;
    this.preset <= 0;
    this.psel <= 1;
    this.penable <= 1;
    this.pwrite <= 1;
endtask
endclass