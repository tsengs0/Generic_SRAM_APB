class apb_sram_agent extends uvm_agent;
// Three essential components for APB SRAM Agent
uvm_sequencer#(apb_sram_trans) seqr; // A sequencer to generate transaction packet as class objects
                                    // and send them to the UVM Driver
apb_sram_driver drv;
apb_sram_monitor mon;
`uvm_component_utils_begin(apb_sram_agent)
    `uvm_field_object(seqr, UVM_ALL_ON)
    `uvm_field_object(drv, UVM_ALL_ON)
    `uvm_field_object(mon, UVM_ALL_ON)
`uvm_component_utils_end

virtual apb_sram_if vif;

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

// Build phase of agent - to construct sequencer, driver and monitor
// which get handle to virtual I/F from the corresponding UVM Environment (parent)
// and pass handle down to sequencer/driver/monitor
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr = uvm_sequencer#(apb_sram_trans)::type_id::create("seqr", this);
    drv = apb_sram_driver::type_id::create("drv", this);
    mon = apb_sram_monitor::type_id::create("mon", this);

    if(!uvm_config_db#(virtual apb_sram_if)::get(this, "", "vif", vif))
        `uvm_fatal("build phase", "No virtual I/F specified for this agent instance")
    uvm_config_db#(virtual apb_sram_if)::set(this, "seqr", "vif", vif);
    uvm_config_db#(virtual apb_sram_if)::set(this, "drv", "vif", vif);
    uvm_config_db#(virtual apb_sram_if)::set(this, "mon", "vif", vif);
endfunction

// To connect squencer to driver if the agent is active
virtual function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
    uvm_report_info("APB_AGENT", "connect_phase, Connected driver to sequencer");
endfunction
endclass