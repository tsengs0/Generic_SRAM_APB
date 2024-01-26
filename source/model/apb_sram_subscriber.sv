import apb_sram_pkg::*;
class apb_sram_subscriber extends uvm_subscriber#(apb_sram_trans);
`uvm_component_utils(apb_sram_subscriber)

apb_sram_pkg::apb_addr_t addr;
apb_sram_pkg::apb_data_t data;

covergroup cover_bus;
    coverpoint addr {
        bins a[16] = {[0:apb_sram_pkg::PAGE_NUM-1]};
    }
    coverpoint data {
        bins d[16] = {[0:apb_sram_pkg::PAGE_NUM-1]};
    }
endgroup

function new(string name, uvm_component parent);
    super.new(name, parent);
    cover_bus = new;
endfunction

virtual function void write(apb_sram_trans t);
    `uvm_info("APB_SUBSCRIBER", $sformatf("Subscriber received tx %s", t.convert2string()), UVM_NONE)
    addr = t.addr;
    data = t.data;
    cover_bus.sample();
endfunction
endclass