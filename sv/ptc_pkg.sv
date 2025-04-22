package ptc_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  typedef uvm_config_db#(virtual ptc_if) ptc_vif_config;

  `include "../sv/ptc_transaction.sv"
   
   //master 
  `include "../sv/ptc_monitor.sv"
 `include "../sv/ptc_seqs.sv"
 `include "../sv/ptc_sequencer.sv"
  `include "../sv/ptc_driver.sv"
 `include "../sv/ptc_agent.sv"
 `include "../sv/ptc_env.sv"

endpackage : ptc_pkg
