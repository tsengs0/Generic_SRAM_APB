// The major purpose of a driver is to receive the data container from sequence (via interface)
// and input to DUT.
class apb_sram_driver extends uvm_driver #(apb_sram_trans);
`uvm_component_utils(apb_sram_driver);

virtual apb_sram_if vif;
apb_sram_trans trans_1;

function new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // To get the I/F handle using get config_db
    if(!uvm_config_db#(virtual apb_sram_if)::get(this, "", "vif", vif))
        `uvm_error("build_phase", "driver virtual interface failed")

    trans_1 = apb_sram_trans::type_id::create("trans_1");
endfunction

virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    this.vif.PSEL <= 1'b0;
    this.vif.PENABLE <= 1'b0;

    forever begin
        //@(posedge this.vif.PCLK);

        // This method blocks until a REQ sequence_item is available in the sequencer
        seq_item_port.get_next_item(trans_1);

        // Driving signals to the I/F
        @(posedge this.vif.PCLK);
        uvm_report_info( "apb_sram_driver", $sformatf("Got transaction: %s", trans_1.convert2string()) );

        // To decode the APB command and call either read or write function
        case(trans_1.pwrite)
            apb_sram_trans::READ:  drive_read(trans_1.addr, trans_1.data);
            apb_sram_trans::WRITE: drive_write(trans_1.addr, trans_1.data);
        endcase

        // The non-blocking method which completes the driver-sequencer handshake
        seq_item_port.item_done();
    end
endtask

virtual protected task drive_read(input apb_addr_t raddr, output apb_data_t dout);
    this.vif.PADDR <= raddr;
    this.vif.PWRITE <= 1'b0;
    this.vif.PSEL <= 1'b1;
    @(posedge this.vif.PCLK);
    this.vif.PENABLE <= 1'b1;
    @(posedge this.vif.PCLK);
    dout = this.vif.PRDATA; // Although the read data loaded on PRDATA bus 
                                  // within the same clock cycle of PENABLE assertion
    this.vif.PSEL <= 1'b0;
    this.vif.PENABLE <= 1'b0;
    //uvm_report_info( "apb_sram_driver", $sformatf("APB read (through the task driver.drive_write) finished: %s", trans_1.convert2string()) );
endtask

virtual protected task drive_write(input apb_addr_t waddr, input apb_data_t din);
    this.vif.PADDR <= waddr;
    this.vif.PWDATA <= din;
    this.vif.PWRITE <= 1'b1;
    this.vif.PSEL <= 1'b1;
//    uvm_report_info( "apb_sram_driver", $sformatf("Control phase (1) of APB write (through the task driver.drive_write): %s", trans_1.convert2string()) );
    @(posedge this.vif.PCLK);
    this.vif.PENABLE <= 1'b1;
//    uvm_report_info( "apb_sram_driver", $sformatf("Control phase (2) of APB write (through the task driver.drive_write): %s", trans_1.convert2string()) );
    @(posedge this.vif.PCLK);
    this.vif.PSEL <= 1'b0;
    this.vif.PENABLE <= 1'b0;
//    uvm_report_info( "apb_sram_driver", $sformatf("APB write (through the task driver.drive_write) finished: %s", trans_1.convert2string()) );
endtask
endclass