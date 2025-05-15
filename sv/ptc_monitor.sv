class ptc_monitor extends uvm_monitor;
  `uvm_component_utils(ptc_monitor)

  virtual ptc_if vif;

  // Time markers
  time t_rise, t_fall;

  // Computed values
  int hrc, lrc;

  uvm_analysis_port #(ptc_transaction) ptc_out;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ptc_out = new("ptc_out", this);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual ptc_if)::get(this, "", "vif", vif))
      `uvm_fatal("PTC_MON", "Failed to get ptc_if")
  endfunction

  ptc_transaction tr;

  task run_phase(uvm_phase phase);
    forever begin
      // Wait until enable signal is high
      @(posedge vif.ptc_oen);

      // Wait for rising edge of PWM
      @(posedge vif.ptc_pwm);
      t_rise = $time;

      // Wait for falling edge of PWM (end of HIGH pulse)
      @(negedge vif.ptc_pwm);
      t_fall = $time;

      lrc = (t_fall - t_rise) / 10; // HRC in clock cycles

      // Wait for next rising edge (end of LOW pulse)
      @(posedge vif.ptc_pwm);
      t_rise = $time;

      hrc = ((t_rise - t_fall) -1 ) / 10; // LRC in clock cycles

      // Create and populate transaction
      tr = ptc_transaction::type_id::create("tr", this);
      tr.lrc_counte = lrc + hrc ;
      tr.hrc_counte = hrc;

      `uvm_info("ptc_monitor", 
        $sformatf("PWM HIGH: %0d cycles, LOW: %0d cycles", hrc, lrc), UVM_LOW)

      `uvm_info(get_type_name(), "monitor received", UVM_LOW)
      `uvm_info(get_type_name(), tr.sprint(), UVM_LOW)

      ptc_out.write(tr);

      // Optional: loop again while enabled
    end
  endtask
endclass
