class apb_sram_rw_seq extends uvm_sequence#(apb_sram_trans);
`uvm_object_utils(apb_sram_rw_seq)

apb_sram_trans rw_trans;

function new(string name = "apb_sram_rw_seq");
    super.new(name);
endfunction

virtual task body();
    // To create 10 random APB R/W transaction and
    // send them to the subsequent UVM Driver
    repeat(10) begin
        rw_trans = apb_sram_trans::type_id::create("rw_trans");
        start_item(rw_trans);
        assert(rw_trans.randomize());
        finish_item(rw_trans);
    end
endtask
endclass