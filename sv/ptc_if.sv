interface ptc_if(input logic clk, input logic rst);
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // External PTC I/O Signals
  logic ptc_ecgt;  // External clock/gate input
  logic ptc_capt;  // Capture input
  logic ptc_pwm;   // PWM output
  logic ptc_oen;   // PWM output enable (3-state control)


  bit monitor_start;

  // Reset sync task
  task reset_if();
    @(posedge rst);
    `uvm_info("PTC_IF", "Observed reset on PTC interface", UVM_MEDIUM)
    monitor_start = 0;
  endtask

  // Monitor trigger 
  task trigger_monitor();
    monitor_start = 1;
    #1 monitor_start = 0;
  endtask

endinterface : ptc_if
