 
class in_transaction extends uvm_sequence_item;
	`uvm_object_utils(in_transaction)
	
	rand bit sw_enable_in;
	rand bit [7:0] data_in;
	bit read_out;

	function new(string name = "in_transaction");
		super.new(name);
	endfunction
endclass