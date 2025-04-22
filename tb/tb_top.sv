module tb_top;

  // UVM class library compiled in a package
  import uvm_pkg::*;
  `include "uvm_macros.svh"

typedef uvm_config_db#(virtual ptc_if) ptc_vif_config;

  import ptc_pkg::*;
  `include "ptc_tb.sv"
  `include "ptc_test_lib.sv"
  
  
  
  initial begin
    // Set ptc interface for monitor & driver
    ptc_vif_config::set(null,"*env.agent.*","vif",hw_top.in0);
    run_test("base_test");
  end

  initial begin 
    $dumpfile("wav.vcd");
    $dumpvars;

  end

 

endmodule