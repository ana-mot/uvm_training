class mem_read_seq extends uvm_sequence#(mem_transaction);
	`uvm_object_utils(mem_read_seq)
	
	function new(string name = "mem_read_seq");
		super.new(name);
	endfunction
	
	virtual task body();
		mem_transaction tr;
		`uvm_do_with(tr, {tr.op == mem_transaction::READ;})
	endtask
endclass