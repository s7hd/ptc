class ptc_driver extends uvm_driver #(ptc_transaction);
  `uvm_component_utils(ptc_driver)

  virtual ptc_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual ptc_if)::get(this, "", "vif", vif))
      `uvm_fatal("PTC_DRV", "Failed to get ptc_if")
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      ptc_transaction tr;
      seq_item_port.get_next_item(tr);

      // Apply ECGT value if required
      if (tr.use_ecgt) begin
        vif.ptc_ecgt <= tr.ecgt_val;
        `uvm_info("PTC_DRV", $sformatf("ECGT driven: %0b", tr.ecgt_val), UVM_LOW)
        #10ns;
      end

      // Pulse Capture signal if requested
      if (tr.use_capt) begin
        vif.ptc_capt <= 1;
        #5ns;
        vif.ptc_capt <= 0;
        `uvm_info("PTC_DRV", "Capture pulse applied", UVM_LOW)
      end

      seq_item_port.item_done();
    end
  endtask
endclass
