class mem_driver extends uvm_driver#(mem_transaction);
	
	`uvm_component_utils(mem_driver)
	
	function new(string name = "mem_driver", uvm_component parent = null);
		super.new(name,parent);
	endfunction
	
	virtual mem_if vif;
	
	virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      if (! uvm_config_db #(virtual mem_if) :: get (this, "", "vif", vif)) begin
         `uvm_error ("NOVIF", {"virtual interface must be set for: ", get_full_name(), ".vif"})
      end
    endfunction
   
    task run_phase (uvm_phase phase);
      mem_transaction tr;
      super.run_phase (phase);

      forever begin
        seq_item_port.get_next_item (tr);
		 
		case(tr.op)
			mem_transaction::WRITE : drive_write(tr);

			mem_transaction::READ  : drive_read(tr);
		endcase
		
        seq_item_port.item_done();
      end
    endtask

    virtual task drive_write(mem_transaction tr);
		@(vif.drv_cb);
		vif.drv_cb.mem_sel_en <= 1'b1;
		vif.drv_cb.mem_wr_rd_s <= 1'b1;
		vif.drv_cb.mem_addr <= tr.addr;

		@(vif.drv_cb);
		vif.drv_cb.mem_wr_data <= tr.wr_data;
		
		wait(vif.drv_cb.mem_ack != 4'b0000);
		tr.ack <= vif.drv_cb.mem_ack;

		`uvm_info(get_type_name(), $sformatf("WRITE addr=%0h data=%0h ack=%0b", tr.addr, tr.wr_data, tr.ack), UVM_MEDIUM)

		@(vif.drv_cb);
		vif.drv_cb.mem_sel_en <= 0;
		vif.drv_cb.mem_wr_rd_s <= 0;
		vif.drv_cb.mem_addr <= 0;
		vif.drv_cb.mem_wr_data <= 0;
    endtask
  
    virtual task drive_read(mem_transaction tr);
		@(vif.drv_cb);
		vif.drv_cb.mem_sel_en <= 1'b1;
		vif.drv_cb.mem_wr_rd_s <= 1'b0;
		vif.drv_cb.mem_addr <= tr.addr;

		@(vif.drv_cb);
		wait(vif.drv_cb.mem_ack != 4'b0000);
		tr.ack <= vif.drv_cb.mem_ack;
	
		tr.rd_data <= vif.drv_cb.mem_rd_data;

		`uvm_info(get_type_name(), $sformatf("READ addr=%0h data=%0h ack=%0b", tr.addr, tr.rd_data, tr.ack), UVM_MEDIUM)

		@(vif.drv_cb);
		vif.drv_cb.mem_sel_en <= 0;
		vif.drv_cb.mem_wr_rd_s <= 0;
		vif.drv_cb.mem_addr <= 0;
	endtask

endclass