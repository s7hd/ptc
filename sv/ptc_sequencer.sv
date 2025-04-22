class ptc_sequencer extends uvm_sequencer #(ptc_transaction);

  `uvm_component_utils(ptc_sequencer)
    
    
    //declare all the seqer u plan to use
    // wb_master_sequencer wb_seqr;
    ptc_sequencer   ptc_seqr; 

  function new(string name = "ptc_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass