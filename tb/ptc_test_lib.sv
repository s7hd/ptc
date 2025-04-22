class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  ptc_tb tb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("PTC Test", "Constructor called!", UVM_LOW)
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("PTC Test", "Build Phase!", UVM_HIGH)

    tb = ptc_tb::type_id::create("tb", this);

    uvm_config_int::set(this, "*", "recording_detail", 1);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  virtual task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 400ns);
    `uvm_info("PTC Test", "Run Phase Started!", UVM_MEDIUM)
    #1us;
    `uvm_info("PTC Test", "Run Phase Ended!", UVM_MEDIUM)
  endtask

  function void check_phase(uvm_phase phase);
    check_config_usage();
  endfunction
endclass

class ptc_pwm_test extends base_test;
  `uvm_component_utils(ptc_pwm_test)

  function new(string name = "ptc_pwm_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    // Set default sequence for PWM mode
    uvm_config_wrapper::set(this, "tb.env.ptc_agent.sequencer", "default_sequence", ptc_base_seq::get_type());
    super.build_phase(phase);
  endfunction
endclass
