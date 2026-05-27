 
class mem_transaction extends uvm_sequence_item;
	`uvm_object_utils(mem_transaction)
	
	typedef enum bit {READ  = 0, WRITE = 1} mem_op_t;
	rand mem_op_t op;
	rand bit [7:0] addr;
	rand bit [7:0] wr_data;
	bit [31:0] rd_data;
	bit [3:0] ack;

	constraint c_addr { addr inside {[0:3]}; }
	
	function new(string name = "mem_transaction");
		super.new(name);
	endfunction
endclass