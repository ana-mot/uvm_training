class mem_write_seq extends uvm_sequence#(mem_transaction);
	`uvm_object_utils(mem_write_seq)
	
	function new(string name = "mem_write_seq");
		super.new(name);
	endfunction
	
	virtual task body();
		mem_transaction tr;
		`uvm_do_with(tr, {tr.op == mem_transaction::WRITE;})
	endtask
endclass