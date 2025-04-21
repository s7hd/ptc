class ptc_driver extends uvm_driver #(ptc_tx);
  `uvm_component_utils(ptc_driver)

  virtual ptc_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db #(virtual ptc_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Driver: No virtual interface assigned")
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      ptc_tx tx;
      seq_item_port.get_next_item(tx);

      @(posedge vif.clk);
      vif.ADR_I   <= tx.addr[14:0];
      vif.SEL_I   <= 4'b1111;
      vif.CYC_I   <= 1;
      vif.STB_I   <= 1;
      vif.WE_I    <= tx.write;

      if (tx.write) begin
        vif.DAT_I <= tx.data;
      end

      //wait for ACK_O from DUT
      wait (vif.ACK_O == 1);

      if (!tx.write) begin
        tx.data = vif.DAT_O;
      end

      //de-assert control signals
      @(posedge vif.clk);
      vif.CYC_I <= 0;
      vif.STB_I <= 0;
      vif.WE_I  <= 0;
      vif.DAT_I <= 32'b0;

      seq_item_port.item_done();
    end
  endtask
endclass
