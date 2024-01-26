class apb_sram_monitor extends uvm_monitor;
`uvm_component_utils(apb_sram_monitor)

virtual apb_sram_if vif;

// Parameterised to APB R/W transaction
// Monitor writes transaction objects to theis port once detected on I/F
uvm_analysis_port#(apb_sram_trans) analysis_port;

function new(string name, uvm_component parent);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
endfunction

// Build Phase - to get handle to virtual I/F from agent/config_db
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_sram_if)::get(this, "", "vif", vif)) 
        `uvm_error("build_phase", "No virtual I/F specified for this monitor instance")
endfunction

virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
        apb_sram_trans trans_1;
        @(posedge this.vif.PCLK);
        //while(
        //    this.vif.PSEL !== 1'b1 || // As long as no incoming R/W transaction
        //    this.vif.PENABLE !== 1'b0 // As long as R/W transaction is stil ongoing
        //);
        wait(this.vif.PREADY == 1'b1); // Until the latest R/W transaction is completed
        
        // To create a transaction object
        trans_1 = apb_sram_trans::type_id::create("trans_1", this);
        // To populate fields based on values seen on I/F
        trans_1.pwrite = (this.vif.PWRITE == 1'b1) ? apb_sram_trans::WRITE : apb_sram_trans::READ;
        trans_1.addr = this.vif.PADDR;

        @(posedge this.vif.PCLK);
        if(this.vif.PENABLE !==1'b1)
            `uvm_error("APB", "APB protocol violation: SETUP cycle not compliant with ENABLE cycle");

        if(trans_1.pwrite == apb_sram_trans::READ) trans_1.data = this.vif.PRDATA;
        else if(trans_1.pwrite == apb_sram_trans::WRITE) trans_1.data = this.vif.PWDATA;
        
        uvm_report_info( "APB Monitor", $sformatf("Got the transaction %s", trans_1.convert2string()) );
    
        // To send the sampled transaction packet (seq. item) to the scoreboard
        // through the analysis port, "analysis_port"
        analysis_port.write(trans_1);
    end
endtask
endclass