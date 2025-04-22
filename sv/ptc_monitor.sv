class ptc_monitor extends uvm_monitor;
  `uvm_component_utils(ptc_monitor)

  virtual ptc_if vif;

  uvm_analysis_port #(ptc_transaction) mon_ap;
   ptc_transaction tx;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    mon_ap = new("mon_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual ptc_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Monitor: No virtual interface assigned")
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.clk);
     
      tx = ptc_transaction::type_id::create("tx_mon");

      //output signals from DUT 
      tx.data[0] = vif.ptc_pwm;
      tx.data[1] = vif.ptc_oen;
      tx.data[2] = vif.inta_o;

      mon_ap.write(tx);

      `uvm_info("PTC_MON", $sformatf("MONITOR -- PWM: %b, OEN: %b, INTA_O: %b", 
                  vif.ptc_pwm, vif.ptc_oen, vif.inta_o), UVM_LOW)
    end
  endtask
endclass
