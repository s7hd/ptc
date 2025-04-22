class ptc_agent extends uvm_agent;
  `uvm_component_utils(ptc_agent)

  ptc_sequencer seqr;
  ptc_driver    driv;
  ptc_monitor   mon;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr = ptc_sequencer::type_id::create("seqr", this);
    driv = ptc_driver::type_id::create("driv", this);
    mon  = ptc_monitor::type_id::create("mon", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    driv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass

