class ptc_agent extends uvm_agent;

    `uvm_component_utils_begin(ptc_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_component_utils_end

  ptc_driver driver;
  ptc_monitor monitor;
  ptc_sequencer sequencer;
  virtual ptc_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
    if (is_active == UVM_ACTIVE) begin
    driver = ptc_driver::type_id::create("driver", this);
    sequencer = ptc_sequencer::type_id::create("sequencer", this);
    end 
     monitor = ptc_monitor::type_id::create("monitor", this);
  endfunction

  function void connect_phase(uvm_phase phase);
     if (is_active == UVM_ACTIVE) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
  end 
  endfunction
     virtual function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Running Simulation...", UVM_HIGH)
    endfunction

endclass
