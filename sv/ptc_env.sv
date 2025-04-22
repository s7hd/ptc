class ptc_env extends uvm_env;
  `uvm_component_utils(ptc_env)

  ptc_agent agent;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = ptc_agent::type_id::create("ptc_agent", this);
    
  endfunction
endclass
