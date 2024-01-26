// The seuqnece item consist of data fields required for generating the stmulus.
// In order to generate the stimulus, the sequence items are randomised in sequences.
// Therefore, data properties in sequence items should generally be declared as rand and 
// can have constraints defined.
import apb_sram_pkg::*;
class apb_sram_trans extends uvm_sequence_item;
`uvm_object_utils(apb_sram_trans)

// R/W transaction type
typedef enum {READ=0, WRITE=1} trans_type_e;
rand apb_addr_t addr;
rand apb_data_t data; // data for R/W operation
rand trans_type_e pwrite;
// Constraints for random verifcation over APB address and data
constraint addr_range {
    addr inside {
        [0:PAGE_NUM-1]
    };
}
constraint data_range {
    data >= 0;
    data < 256;
}

function new(string name="apb_sram_transaction");
    super.new(name);
endfunction

function string convert2string();
    return $sformatf("PWRITE=%0h, PADDR=%0h, PWDATA/PRDATA=%0h", pwrite, addr, data);
endfunction
endclass