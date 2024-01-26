class apb_sram_config extends uvm_object;
`uvm_object_utils(apb_sram_config)

// Active-type agent: 
//      a) instantiation of all three components, i.e. sequencer, driver, monitor
//      b) Data is enabled to be driven to DUT via driver
// Passive-type agent:
//      a) Only instantiation of monitor
//      b) Used for checking and coverage only
//      c) Useful when there is no data item to be driven to DUT
uvm_active_passive_enum agent_type = UVM_ACTIVE;

function new(string path = "apb_sram_config");
    super.new(path);
endfunction
endclass