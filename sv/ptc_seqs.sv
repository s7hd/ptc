class ptc_base_seq extends uvm_sequence #(ptc_transaction);
  `uvm_object_utils(ptc_base_seq)

  //newline
  localparam RPTC_CTRL_ADDR = 32'h4000_0000;
  
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


class ptc_counter_reset_seq extends ptc_base_seq;
  `uvm_object_utils(ptc_counter_reset_seq)

  function new(string name = "ptc_counter_reset_seq");
    super.new(name);
  endfunction

  task body();
    ptc_transaction tr;

    // Step 1: Set CNTRRST (bit 7) = 1 to reset the counter
    tr = ptc_transaction::type_id::create("set_cntrrst");
    tr.addr  = RPTC_CTRL_ADDR;
    tr.data  = 32'h00000080;  // CNTRRST = 1 (bit 7)
    tr.write = 1;
    start_item(tr); finish_item(tr);

    // Step 2: Clear CNTRRST back to 0 to resume normal counter operation
    tr = ptc_transaction::type_id::create("clear_cntrrst");
    tr.addr  = RPTC_CTRL_ADDR;
    tr.data  = 32'h00000000;  // CNTRRST = 0
    tr.write = 1;
    start_item(tr); finish_item(tr);

    `uvm_info(get_type_name(), "Manual counter reset completed", UVM_MEDIUM)
  endtask
endclass

// class ptc_pwm_mode_seq extends ptc_base_seq;
//   `uvm_object_utils(ptc_pwm_mode_seq)

//   function new(string name = "ptc_pwm_mode_seq");
//     super.new(name);
//   endfunction

//   task body();
//     ptc_transaction tr;
    
//     // Set High and Low values
//     tr = ptc_transaction::type_id::create("set_hrc");
//     tr.addr = RPTC_HRC_ADDR;
//     tr.data = 16'h000A; // Example High cycle
//     start_item(tr); finish_item(tr);

//     tr = ptc_transaction::type_id::create("set_lrc");
//     tr.op_type = WRITE;
//     tr.addr = RPTC_LRC_ADDR;
//     tr.data = 16'h0005; // Example Low cycle
//     start_item(tr); finish_item(tr);
//   endtask
// endclass



