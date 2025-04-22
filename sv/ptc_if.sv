interface ptc_if(input logic clk, input logic rst);
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // External PTC I/O Signals
  logic ptc_ecgt;  // External clock/gate input
  logic ptc_capt;  // Capture input
  logic ptc_pwm;   // PWM output
  logic ptc_oen;   // PWM output enable (3-state control)
  logic inta_o;    //// Interrupt output
  
  // WISHBONE host interface
  logic ADR_I;    //Address inputs
  logic SEL_I;    //Indicates valid bytes on data bus
  logic CYC_I;    //Indicates valid bus cycle (core select)
  logic STB_I;    //Indicates valid data transfer cycle
  logic WE_I;     //Write transaction when asserted high
  logic DAT_I;    //Data inputs
  logic DAT_O;    //Data outputs
  logic ACK_O;    //Acknowledgment output



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
