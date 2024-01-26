class apb_sram_env extends uvm_env;
`uvm_component_utils(apb_sram_env)

apb_sram_agent agt;
apb_sram_scoreboard scb;
apb_sram_subscriber coverage_collector; // Used as a coverage collector
virtual apb_sram_if vif;

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

// To construct UVM Agent and get virtual I/F handle from the UVM Test,
// and then to pass it down to the UVM Agent
virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = apb_sram_agent::type_id::create("agt", this);
    scb = apb_sram_scoreboard::type_id::create("scb", this);
    coverage_collector = apb_sram_subscriber::type_id::create("coverage_collector", this);
    if(!uvm_config_db#(virtual apb_sram_if)::get(this, "", "vif", vif))
        `uvm_fatal("build phase", "No virtual I/F specified for thie UVM Environment instance")

    uvm_config_db#(virtual apb_sram_if)::set(this, "agt", "vif", vif);
endfunction

virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.mon.analysis_port.connect(scb.mon_export); // To bind the uvm_analysis_port to uvm_analysis_imp
                                                   // from monitor and scoreboard, respectively
    agt.mon.analysis_port.connect(coverage_collector.analysis_export); // To bind the uvm_analysis_port to built-in uvm_analysis_imp
                                                                       // from monitor and subscriber, respectively
endfunction
endclass