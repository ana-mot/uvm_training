class mem_monitor extends uvm_monitor;
    `uvm_component_utils(mem_monitor)

    virtual mem_if vif;

    uvm_analysis_port #(mem_transaction)  mon_analysis_port;

    bit [7:0] expected_mem [256];
    bit [7:0] actual_data;

    function new (string name = "mem_monitor", uvm_component parent= null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);

      mon_analysis_port = new ("mon_analysis_port", this);

      if (! uvm_config_db #(virtual mem_if) :: get (this, "", "vif", vif)) begin
         `uvm_error (get_type_name (), "DUT interface not found")
      end
   endfunction

   virtual task run_phase (uvm_phase phase);
        mem_transaction tr;

        forever begin
            @(posedge vif.mon_cb.mem_sel_en);
                tr = mem_transaction::type_id::create("tr", this);
                tr.addr = vif.mon_cb.mem_addr;

                //WRITE
                if(vif.mon_cb.mem_wr_rd_s) begin
                    tr.op = mem_transaction::WRITE;
                    tr.wr_data = vif.mon_cb.mem_wr_data;
                    wait(vif.mon_cb.mem_ack != 4'b0000);
                    tr.ack = vif.mon_cb.mem_ack;
                    expected_mem[tr.addr] = tr.wr_data;
                    `uvm_info(get_type_name(),$sformatf("MONITOR WRITE addr=%0h data=%0h ack=%0b", tr.addr, tr.wr_data, tr.ack), UVM_MEDIUM)

                end 
                //READ
                else begin
                    tr.op = mem_transaction::READ;
                    
                    wait(vif.mon_cb.mem_ack != 4'b0000);
                    tr.ack = vif.mon_cb.mem_ack;
                    tr.rd_data = vif.mon_cb.mem_rd_data;

                    /*case(tr.addr)
                        0: actual_data = tr.rd_data[7:0];
                        1: actual_data = tr.rd_data[15:8];
                        2: actual_data = tr.rd_data[23:16];
                        3: actual_data = tr.rd_data[31:24];
                        default: actual_data = 'x;
                    endcase*/

                    if(expected_mem[tr.addr] !== tr.rd_data[7:0]) begin
                        `uvm_error(get_type_name(),$sformatf("READ MISMATCH addr=0x%0h expected=0x%0h actual=0x%0h",tr.addr,expected_mem[tr.addr],tr.rd_data[7:0]))
                    end else begin
                        `uvm_info(get_type_name(),$sformatf("MONITOR READ addr=%0h data=%0h ack=%0b", tr.addr, tr.rd_data, tr.ack), UVM_MEDIUM)
                    end
                    
               end

                mon_analysis_port.write (tr);
        
      end
   endtask

endclass