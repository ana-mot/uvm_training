class in_driver extends uvm_driver#(in_transaction);
	
	`uvm_component_utils(in_driver)
	
	function new(string name = "in_driver", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	virtual in_if vif;
	
	virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      if (!uvm_config_db#(virtual in_if)::get(this, "", "in_vif", vif)) begin
        `uvm_error("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
      end
    endfunction
   
    task run_phase (uvm_phase phase);
    	in_transaction tr;
      	super.run_phase (phase);

        vif.drv_cb.sw_enable_in <= 0;
        vif.drv_cb.data_in <= 0;

        wait (vif.rst_n ==1'b1);

	  	forever begin
            seq_item_port.get_next_item(tr);
            @(vif.drv_cb);
            vif.drv_cb.sw_enable_in <= tr.sw_enable_in;
            vif.drv_cb.data_in <= tr.data_in;
            seq_item_port.item_done();

            `uvm_info(get_type_name(), $sformatf("DRIVER IN sw_en=%0b data=%02h", tr.sw_enable_in, tr.data_in), UVM_MEDIUM)
      end
    endtask

endclass