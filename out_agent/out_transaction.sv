 
class out_transaction extends uvm_sequence_item;
	`uvm_object_utils(out_transaction)

	rand bit port_read;
	bit [7:0] port_out;
	bit port_ready;
	
	function new(string name = "out_transaction");
		super.new(name);
	endfunction
endclass