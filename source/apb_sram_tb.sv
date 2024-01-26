module apb_sram_tb;
`include "uvm_macros.svh"
import uvm_pkg::*;
import apb_sram_pkg::*;
`include "apb_sram_model.svh"

apb_sram_if dut_if();
apb_sram_pkg::apb_data_t rdata_probe;
sram_wrapper dut (
    .rdata_o  (rdata_probe),
    .apb_if_s0 (dut_if)
);

initial begin
    #0 dut_if.PCLK = 1'b0;
    forever #10 dut_if.PCLK = ~dut_if.PCLK;
end

initial begin
    #0 dut_if.PRESETn = 1'b0;
    repeat (1) @(posedge dut_if.PCLK);
    dut_if.PRESETn = 1'b1;
end

initial begin
    // To pass this physical interface to test top 
    // which will further pass it down to env->agent->drv/sqr/mon
    uvm_config_db #(virtual apb_sram_if)::set(null, "*", "vif", dut_if);
    run_test("apb_sram_test");
end

initial begin
    $dumpfile("apb_sram_tb.vcd");
    $dumpvars(10, dut);
end
endmodule