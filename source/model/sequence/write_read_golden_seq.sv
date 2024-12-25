// #Verification item: writing a self-checking sequence
// #Description:
//      A self-checking sequence is a sequence which causes some activity and then checks the results for proper behavior.
//      The simplest self-checking sequence issues a WRITE at an address, then a READ from the same address. Now the
//      data read is compared to the data written. In some ways the sequence becomes the GOLDEN model.
// # Ref: https://dvcon-proceedings.org/wp-content/uploads/fun-with-uvm-sequences--coding-and-debugging.pdf
import apb_sram_pkg::*;
class write_read_golden_seq extends uvm_sequence#(apb_sram_trans);
`uvm_object_utils(write_read_golden_seq)

apb_sram_trans trans;
function new(string name="write_read_golden_seq");
    super.new(name);
endfunction

virtual task body();
    for(int i=0; i<apb_sram_pkg::PAGE_NUM; i++) begin
        trans = new($sformatf("RW_Trans_%0d", i));
        start_item(trans);
        if(!trans.randomize())
            `uvm_fatal(get_type_name(), "Randomise FAILED")
        trans.pwrite=apb_sram_trans::WRITE;
        finish_item(trans);
    end

    for(int i=0; i<apb_sram_pkg::PAGE_NUM; i++) begin
        trans = new($sformatf("RW_Trans_%0d", i));
        start_item(trans);
        if(!trans.randomize())
            `uvm_fatal(get_type_name(), "Randomise FAILED")
        trans.pwrite=apb_sram_trans::READ;
        trans.data = 0;
        finish_item(trans);

        // Check
        if(trans.addr != trans.data) begin
            `uvm_info(
                get_type_name(), 
                $sformatf("Mismatch. Wrote %0d, Read %0d", trans.addr, trans.data),
                UVM_MEDIUM
            )
            `uvm_fatal(get_type_name(), "Compare FAILED")
        end
    end
endtask
endclass
