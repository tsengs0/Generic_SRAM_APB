import apb_sram_pkg::*;
class apb_sram_scoreboard extends uvm_scoreboard;
`uvm_component_utils(apb_sram_scoreboard)

// To receive the transaction packet from uvm_analysis_port of UVM Monitor
uvm_analysis_imp#(apb_sram_trans, apb_sram_scoreboard) mon_export;

apb_sram_trans export_queue[$];
apb_sram_pkg::apb_data_t [apb_sram_pkg::DATA_WIDTH-1:0] sc_mem [0:apb_sram_pkg::PAGE_NUM];
function new(string name, uvm_component parent);
    super.new(name, parent);
    mon_export = new("mon_export", this);
endfunction

virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    foreach(sc_mem[i]) sc_mem[i] = i;
endfunction

// Write task - to receive the transaction packet from monitor and push into queue
virtual function void write(apb_sram_trans trans_1);
//    tr.print();
    export_queue.push_back(trans_1);
endfunction

virtual task run_phase(uvm_phase phase);
    apb_sram_trans export_pkt;

    forever begin
        wait(export_queue.size() > 0);
        export_pkt = export_queue.pop_front();

        if(export_pkt.pwrite == apb_sram_trans::WRITE) begin
            sc_mem[export_pkt.addr] = export_pkt.data;
            `uvm_info("APB_SCOREBOARD", $sformatf("------ :: WRITE DATA\t::------"), UVM_LOW)
            `uvm_info("", $sformatf("Addr: %0h", export_pkt.addr), UVM_LOW)
            `uvm_info("", $sformatf("Data: %0h", export_pkt.data), UVM_LOW)
        end else if(export_pkt.pwrite == apb_sram_trans::READ) begin
            if(sc_mem[export_pkt.addr] == export_pkt.data) begin
                `uvm_info("APB SCOREBOARD", $sformatf("------ :: READ DATA Matched :: ------"), UVM_LOW)
                `uvm_info("", $sformatf("Addr: %0h", export_pkt.addr), UVM_LOW)
                `uvm_info(
                    "",
                    $sformatf("Expected data: %0h, Actual data: %0h",
                                sc_mem[export_pkt.addr], export_pkt.data
                    ),
                    UVM_LOW
                )
            end else begin
                `uvm_info("APB SCOREBOARD", $sformatf("------ :: READ DATA Mismatched :: ------"), UVM_LOW)
                `uvm_info("", $sformatf("Addr: %0h", export_pkt.addr), UVM_LOW)
                `uvm_info(
                    "",
                    $sformatf("Expected data: %0h, Actual data: %0h",
                                sc_mem[export_pkt.addr], export_pkt.data
                    ),
                    UVM_LOW
                )                
            end
        end
    end
endtask
endclass