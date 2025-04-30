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

class ptc_counter_Reset_test extends base_test;
  `uvm_component_utils(ptc_counter_Reset_test)

  function new(string name = "ptc_counter_Reset_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    // Set default sequence for PWM mode
    uvm_config_wrapper::set(this, "*.env.agent.sequencer.*", "default_sequence", ptc_counter_reset_seq::get_type());
    super.build_phase(phase);
  endfunction
endclass

class ptc_pwm_test extends base_test;
  `uvm_component_utils(ptc_pwm_test)

  function new(string name = "ptc_pwm_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    // Set default sequence for PWM mode
    uvm_config_wrapper::set(this, "*.env.agent.sequencer.*", "default_sequence", ptc_pwm_mode_seq::get_type());
    super.build_phase(phase);
  endfunction
endclass

class ptc_timer_counter extends base_test;
  `uvm_component_utils(ptc_timer_counter)

  function new(string name = "ptc_timer_counter", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    // Set default sequence for PWM mode
    uvm_config_wrapper::set(this, "*.env.agent.sequencer.*", "default_sequence", ptc_timer_counter_mode_seq::get_type());
    super.build_phase(phase);
  endfunction
endclass

class ptc_gate_feature extends base_test;
  `uvm_component_utils(ptc_gate_feature)

  function new(string name = "ptc_gate_feature_seq", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    // Set default sequence for PWM mode
    uvm_config_wrapper::set(this, "*.env.agent.sequencer.*", "default_sequence", ptc_gate_feature_seq::get_type());
    super.build_phase(phase);
  endfunction
endclass

class ptc_interrupt_feature extends base_test;
  `uvm_component_utils(ptc_interrupt_feature)

  function new(string name = "ptc_interrupt_feature", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    // Set default sequence for PWM mode
    uvm_config_wrapper::set(this, "*.env.agent.sequencer.*", "default_sequence", ptc_interrupt_feature_seq::get_type());
    super.build_phase(phase);
  endfunction
endclass

class ptc_capture_feature extends base_test;
  `uvm_component_utils(ptc_capture_feature)

  function new(string name = "ptc_capture_feature", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    // Set default sequence for PWM mode
    uvm_config_wrapper::set(this, "*.env.agent.sequencer.*", "default_sequence", ptc_capture_feature_seq::get_type());
    super.build_phase(phase);
  endfunction
endclass


