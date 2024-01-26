class sram_uvm_config extends uvm_object;
`uvm_object_utils(sram_uvm_config)

virtual apb_sram_if dut_vif;
uvm_active_passive_enum agent_type = UVM_ACTIVE;
function new(string name = "");
    super.new(name);
endfunction
endclass