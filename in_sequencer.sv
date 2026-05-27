class in_sequencer extends uvm_sequencer #(in_transaction);
	`uvm_component_utils(in_sequencer)
	
	function new(string name = "in_sequencer", uvm_component parent = null);
		super.new(name, parent);
	endfunction
endclass