class apb_sram_test extends uvm_test;
`uvm_component_utils(apb_sram_test)

apb_sram_env env;
apb_sram_rw_seq apb_sram_seq_0;
apb_sram_preload_seq apb_sram_seq_1;
write_read_golden_seq apb_sram_seq_2;
virtual apb_sram_if vif;

function new(string name = "apb_sram_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

// To construct the  UVM Environment class using factory
// and get the virtual I/F handle from the UVM Test and then set it config_db
// for the UVM Environment
virtual function void build_phase(uvm_phase phase);
  env = apb_sram_env::type_id::create("env", this);
  if(!uvm_config_db#(virtual apb_sram_if)::get(this, "", "vif", vif))
    `uvm_fatal("build_phase", "No virtual I/F specified for this UVM Test instance")

  uvm_config_db#(virtual apb_sram_if)::set(this, "env", "vif", vif);
endfunction

virtual task run_phase(uvm_phase phase);
  apb_sram_seq_0 = apb_sram_rw_seq::type_id::create("apb_sram_seq_0");
  apb_sram_seq_1 = apb_sram_preload_seq::type_id::create("apb_sram_seq_1");
  apb_sram_seq_2 = write_read_golden_seq::type_id::create("apb_sram_seq_2");
  phase.raise_objection(this, "To start the main phase of UVM Test for APB-interfaced SRAM");
  $display("%t To start the sequence apb_sram_seq_0 in run_phase", $time);
  apb_sram_seq_1.start(env.agt.seqr);
  apb_sram_seq_0.start(env.agt.seqr);
  apb_sram_seq_2.start(env.agt.seqr);
  #100ns;
  phase.drop_objection(this, "Finished apb_sram_seq_0 in the main phase");
endtask
endclass