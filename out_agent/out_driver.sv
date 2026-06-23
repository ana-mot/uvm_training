class out_driver extends uvm_driver#(out_transaction);
	
	`uvm_component_utils(out_driver)
	
	function new(string name = "out_driver", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	virtual in_if vif;
	
	virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      if (! uvm_config_db #(virtual in_if) :: get (this, "", "vif", vif)) begin
         `uvm_error ("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
      end
    endfunction
   
    task run_phase (uvm_phase phase);
    	out_transaction tr;
      	super.run_phase (phase);

        vif.drv_cb.port_read <= 1'b0;
        wait (vif.rst_n == 1'b1);

	  	forever begin
            seq_item_port.get_next_item(tr);
            @(vif.drv_cb);
            vif.drv_cb.port_read <= tr.port_read;
            seq_item_port.item_done();

            `uvm_info(get_type_name(), $sformatf("DRIVER OUT port_read=%0b ready=%0b out=%0h", tr.port_read, vif.drv_cb.port_ready, vif.drv_cb.port_out), UVM_MEDIUM)
        end
    endtask

endclass