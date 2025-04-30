class ptc_monitor extends uvm_monitor;
  `uvm_component_utils(ptc_monitor)

  virtual ptc_if vif;

  uvm_analysis_port #(ptc_transaction) mon_ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    mon_ap = new("mon_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual ptc_if)::get(this, "", "vif", vif))
      `uvm_fatal("PTC_MON", "Failed to get ptc_if")
  endfunction
ptc_transaction tr;
  task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.monitor_start); // Triggered by driver or testbench
       tr = ptc_transaction::type_id::create("mon_tr");
      tr.ecgt_val = vif.ptc_ecgt;
      tr.use_ecgt = 1;
       `uvm_info(get_type_name(), "moniter recived", UVM_LOW)
      // You can also add capturing current state of ptc_pwm, ptc_oen if useful
      mon_ap.write(tr);
            `uvm_info(get_type_name(), tr.sprint(), UVM_LOW)

    end
  endtask
endclass
