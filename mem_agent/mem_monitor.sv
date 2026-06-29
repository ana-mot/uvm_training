class mem_monitor extends uvm_monitor;
    `uvm_component_utils(mem_monitor)

    virtual mem_if vif;

    uvm_analysis_port #(mem_transaction)  mon_analysis_port;

    bit [7:0] expected_mem [256];

    function new (string name = "mem_monitor", uvm_component parent= null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);

        mon_analysis_port = new ("mon_analysis_port", this);

        if (! uvm_config_db #(virtual mem_if)::get(this, "", "mem_vif", vif)) begin
            `uvm_error(get_type_name(), "DUT interface not found")
        end
   endfunction

   virtual task run_phase (uvm_phase phase);
        mem_transaction tr;
        bit [7:0] actual_data;
        wait(vif.rst_n == 1'b1);

        forever begin
            @(vif.mon_cb);
            if(vif.mon_cb.mem_sel_en) begin
                tr = mem_transaction::type_id::create("tr", this);
                tr.addr = vif.mon_cb.mem_addr;

                //WRITE
                if(vif.mon_cb.mem_wr_rd_s) begin
                    tr.op = mem_transaction::WRITE;
                    
                    wait(vif.mon_cb.mem_ack != 4'b0000);
                    tr.ack = vif.mon_cb.mem_ack;
                    tr.wr_data = vif.mon_cb.mem_wr_data;
                    expected_mem[tr.addr] = tr.wr_data;
                    `uvm_info(get_type_name(),$sformatf("MONITOR WRITE addr=%0h data=%0h ack=%0b", tr.addr, tr.wr_data, tr.ack), UVM_MEDIUM)

                end 
                //READ
                else begin
                    tr.op = mem_transaction::READ;
                    
                    wait(vif.mon_cb.mem_ack != 4'b0000);
                    tr.ack = vif.mon_cb.mem_ack;
                    tr.rd_data = vif.mon_cb.mem_rd_data;
                    `uvm_info(get_type_name(),$sformatf("MONITOR READ addr=%0h data=%0h ack=%0b", tr.addr, tr.rd_data, tr.ack), UVM_MEDIUM)

                    
               end

                mon_analysis_port.write (tr);
            end
      end
   endtask

endclass