class sram_driver extends uvm_driver #(sram_seq_item);
`uvm_component_utils(sram_driver)

virtual apb_sram_if dut_if;
sram_seq_item apb_write;
//sram_uvm_config sram_cfg; // Data member

function new(string name="sram_driver", uvm_component parent=null);
    super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    apb_write = sram_seq_item::type_id::create("apb_write");

    if(!uvm_config_db #(virtual apb_sram_if)::get(this, "", "dut_if", dut_if))
        ``uvm_fatal(get_type_name(), "Unable to access to the APB-SRAM I/F")
endfunction

virtual task run_phase(uvm_phase phase);
    forever begin
        apb_write.reset_sys; // to reset the status of APB-master I/F
        
        // Method to block until a REQ sequence_item is available in the sequencer
        seq_item_port.get_next_item(apb_write);
        apb_write.


        // Non-blocking method which completes the driver-sequencer handshake
        seq_item_port.item_done();
    end
endtask
endclass