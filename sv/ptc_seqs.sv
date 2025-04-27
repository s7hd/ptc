// class ptc_base_seq extends uvm_sequence #(ptc_transaction);
//   `uvm_object_utils(ptc_base_seq)

//   //newline
//   localparam RPTC_CTRL_ADDR = 32'h4000_0000;
  
//   function new(string name = "ptc_base_seq");
//     super.new(name);
//   endfunction

//   task pre_body();
//     uvm_phase phase;
//     `ifdef UVM_VERSION_1_2
//       phase = get_starting_phase();
//     `else
//       phase = starting_phase;
//     `endif
//     if (phase != null) begin
//       phase.raise_objection(this, get_type_name());
//       `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
//     end
//   endtask

//   task post_body();
//     uvm_phase phase;
//     `ifdef UVM_VERSION_1_2
//       phase = get_starting_phase();
//     `else
//       phase = starting_phase;
//     `endif
//     if (phase != null) begin
//       phase.drop_objection(this, get_type_name());
//       `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
//     end
//   endtask
// endclass


// class ptc_counter_reset_seq extends ptc_base_seq;
//   `uvm_object_utils(ptc_counter_reset_seq)

//   function new(string name = "ptc_counter_reset_seq");
//     super.new(name);
//   endfunction

//   task body();
//     ptc_transaction tr;

//     // Step 1: Set CNTRRST (bit 7) = 1 to reset the counter
//     tr = ptc_transaction::type_id::create("set_cntrrst");
//     tr.addr  = RPTC_CTRL_ADDR;
//     tr.data  = 32'h00000080;  // CNTRRST = 1 (bit 7)
//     tr.write = 1;
//     start_item(tr); finish_item(tr);

//     // Step 2: Clear CNTRRST back to 0 to resume normal counter operation
//     tr = ptc_transaction::type_id::create("clear_cntrrst");
//     tr.addr  = RPTC_CTRL_ADDR;
//     tr.data  = 32'h00000000;  // CNTRRST = 0
//     tr.write = 1;
//     start_item(tr); finish_item(tr);

//     `uvm_info(get_type_name(), "Manual counter reset completed", UVM_MEDIUM)
//   endtask
// endclass

// // class ptc_pwm_mode_seq extends ptc_base_seq;
// //   `uvm_object_utils(ptc_pwm_mode_seq)

// //   function new(string name = "ptc_pwm_mode_seq");
// //     super.new(name);
// //   endfunction

// //   task body();
// //     ptc_transaction tr;
    
// //     // Set High and Low values
// //     tr = ptc_transaction::type_id::create("set_hrc");
// //     tr.addr = RPTC_HRC_ADDR;
// //     tr.data = 16'h000A; // Example High cycle
// //     start_item(tr); finish_item(tr);

// //     tr = ptc_transaction::type_id::create("set_lrc");
// //     tr.op_type = WRITE;
// //     tr.addr = RPTC_LRC_ADDR;
// //     tr.data = 16'h0005; // Example Low cycle
// //     start_item(tr); finish_item(tr);
// //   endtask
// // endclass

// ==================================================
// Base Sequence
// ==================================================
class ptc_base_seq extends uvm_sequence #(ptc_transaction);
  `uvm_object_utils(ptc_base_seq)

  // Newline
  localparam RPTC_CTRL_ADDR = 32'h4000_0000;
  localparam RPTC_CNTR_ADDR = 32'h4000_0000;
  localparam RPTC_HRC_ADDR  = 32'h4000_0004;
  localparam RPTC_LRC_ADDR  = 32'h4000_0008;

  function new(string name = "ptc_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask
endclass

// ==================================================
// Counter Reset Test
// ==================================================
class ptc_counter_reset_seq extends ptc_base_seq;
  `uvm_object_utils(ptc_counter_reset_seq)

  function new(string name = "ptc_counter_reset_seq");
    super.new(name);
  endfunction

  task body();
    ptc_transaction tr;

    // Step 1: Reset counter manually (CNTRRST = 1)
    tr = ptc_transaction::type_id::create("set_cntrrst");
    tr.addr  = RPTC_CTRL_ADDR;
    tr.data  = 32'h00000080;
    tr.write = 1;
    start_item(tr); finish_item(tr);

    // Step 2: Clear reset (CNTRRST = 0)
    tr = ptc_transaction::type_id::create("clear_cntrrst");
    tr.addr  = RPTC_CTRL_ADDR;
    tr.data  = 32'h00000000;
    tr.write = 1;
    start_item(tr); finish_item(tr);

    `uvm_info(get_type_name(), "Manual counter reset completed", UVM_MEDIUM)
  endtask
endclass

// ==================================================
// PWM Mode Test
// ==================================================
class ptc_pwm_mode_seq extends ptc_base_seq;
  `uvm_object_utils(ptc_pwm_mode_seq)

  function new(string name = "ptc_pwm_mode_seq");
    super.new(name);
  endfunction

  task body();
    ptc_transaction tr;

    // Set High Reference Value
    tr = ptc_transaction::type_id::create("set_hrc");
    tr.addr = RPTC_HRC_ADDR;
    tr.write = 1;
    tr.write_data = 32'd10;
    start_item(tr); finish_item(tr);

    // Set Low Reference Value
    tr = ptc_transaction::type_id::create("set_lrc");
    tr.addr = RPTC_LRC_ADDR;
    tr.write = 1;
    tr.write_data = 32'd20;
    start_item(tr); finish_item(tr);

    // Enable PWM Output Driver (OE=1), Continuous Mode (SINGLE=0), Enable (EN=1)
    tr = ptc_transaction::type_id::create("enable_pwm_output");
    tr.addr = RPTC_CTRL_ADDR;
    tr.write = 1;
    tr.write_data = 32'b00001001; // EN=1, OE=1, SINGLE=0
    start_item(tr); finish_item(tr);
  endtask
endclass

// ==================================================
// Timer/Counter Mode Test
// ==================================================
class ptc_timer_counter_mode_seq extends ptc_base_seq;
  `uvm_object_utils(ptc_timer_counter_mode_seq)

  function new(string name = "ptc_timer_counter_mode_seq");
    super.new(name);
  endfunction

  task body();
    ptc_transaction tr;

    // Set Limit Value
    tr = ptc_transaction::type_id::create("set_lrc_timer");
    tr.addr = RPTC_LRC_ADDR;
    tr.write = 1;
    tr.write_data = 32'd100;
    start_item(tr); finish_item(tr);

    // Enable Counter (EN=1)
    tr = ptc_transaction::type_id::create("enable_counter");
    tr.addr = RPTC_CTRL_ADDR;
    tr.write = 1;
    tr.write_data = 32'b00000001; // EN=1
    start_item(tr); finish_item(tr);
  endtask
endclass

// ==================================================
// Gate Feature Test
// ==================================================
class ptc_gate_feature_seq extends ptc_base_seq;
  `uvm_object_utils(ptc_gate_feature_seq)

  function new(string name = "ptc_gate_feature_seq");
    super.new(name);
  endfunction

  task body();
    ptc_transaction tr;

    // Gate High (external control)
    tr = ptc_transaction::type_id::create("gate_high");
    tr.use_ecgt = 1;
    tr.ecgt_val = 1;
    start_item(tr); finish_item(tr);

    #100ns;

    // Gate Low
    tr = ptc_transaction::type_id::create("gate_low");
    tr.use_ecgt = 1;
    tr.ecgt_val = 0;
    start_item(tr); finish_item(tr);
  endtask
endclass

// ==================================================
// Interrupt Feature Test
// ==================================================
class ptc_interrupt_feature_seq extends ptc_base_seq;
  `uvm_object_utils(ptc_interrupt_feature_seq)

  function new(string name = "ptc_interrupt_feature_seq");
    super.new(name);
  endfunction

  task body();
    ptc_transaction tr;

    // Enable interrupt generation (INTE=1) and counter (EN=1)
    tr = ptc_transaction::type_id::create("enable_interrupt");
    tr.addr = RPTC_CTRL_ADDR;
    tr.write = 1;
    tr.write_data = 32'b00100001;
    start_item(tr); finish_item(tr);

    // Set LRC value
    tr = ptc_transaction::type_id::create("set_lrc_interrupt");
    tr.addr = RPTC_LRC_ADDR;
    tr.write = 1;
    tr.write_data = 32'd50;
    start_item(tr); finish_item(tr);
  endtask
endclass

// ==================================================
// Capture Feature Test
// ==================================================
class ptc_capture_feature_seq extends ptc_base_seq;
  `uvm_object_utils(ptc_capture_feature_seq)

  function new(string name = "ptc_capture_feature_seq");
    super.new(name);
  endfunction

  task body();
    ptc_transaction tr;

    // Enable Capture (CAPTE=1) and Counter (EN=1)
    tr = ptc_transaction::type_id::create("enable_capture");
    tr.addr = RPTC_CTRL_ADDR;
    tr.write = 1;
    tr.write_data = 32'b10000001;
    start_item(tr); finish_item(tr);

    // Pulse capture input
    tr = ptc_transaction::type_id::create("pulse_capture");
    tr.use_capt = 1;
    start_item(tr); finish_item(tr);
  endtask
endclass



