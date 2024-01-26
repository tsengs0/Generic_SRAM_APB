import apb_sram_pkg::*;
class apb_sram_preload_seq extends uvm_sequence#(apb_sram_trans);
`uvm_object_utils(apb_sram_preload_seq)

apb_sram_trans trans;
function new(string name="apb_sram_preload_seq");
    super.new(name);
endfunction

virtual task body();
    for(int i=0; i<apb_sram_pkg::PAGE_NUM; i++) begin
        trans = apb_sram_trans::type_id::create("preload_trans");
        start_item(trans);
        trans.pwrite = apb_sram_trans::WRITE;
        trans.data = i;
        trans.addr = i;
        finish_item(trans);
    end
endtask
endclass