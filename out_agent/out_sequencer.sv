class out_sequencer extends uvm_sequencer #(out_transaction);
	`uvm_component_utils(out_sequencer)
	
	function new(string name = "out_sequencer", uvm_component parent = null);
		super.new(name, parent);
	endfunction
endclass