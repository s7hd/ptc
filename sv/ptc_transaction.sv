class ptc_transaction extends uvm_sequence_item;

  rand bit [31:0] addr;
  rand bit [31:0] data; //original field (still valid for basic use)
  rand bit write;  //write = 1, read = 0
  rand bit use_capt;  //if 1, pulse the ptc_capt signal
  rand bit use_ecgt;  //if 1, apply ptc_ecgt
  rand bit ecgt_val;  //value for ptc_ecgt (1 = high, 0 = low)
  rand bit [31:0] write_data;  //data sent to DUT (write operations)
  bit [31:0] read_data;   //data received from DUT (read operations)

  `uvm_object_utils(ptc_transaction)

  function new(string name = "ptc_transaction");
    super.new(name);
  endfunction

  function void do_print(uvm_printer printer);
    super.do_print(printer);
    `uvm_info("PTC_TX", $sformatf(
      "\nAddress     = 0x%0h\nWrite?      = %0b\nData        = 0x%0h\nUse Capt?   = %0b\nUse ECGT?   = %0b\nECGT Value  = %0b\nWrite Data  = 0x%0h\nRead Data   = 0x%0h",
      addr, write, data, use_capt, use_ecgt, ecgt_val, write_data, read_data
    ), UVM_LOW)
  endfunction

endclass
