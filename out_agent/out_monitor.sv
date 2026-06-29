class out_monitor extends uvm_monitor;
    `uvm_component_utils(out_monitor)

    virtual out_if vif;

    uvm_analysis_port #(out_transaction)  mon_analysis_port;

    function new (string name = "out_monitor", uvm_component parent= null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);

      mon_analysis_port = new ("mon_analysis_port", this);

      if (!uvm_config_db#(virtual out_if)::get(this, "", "out_vif", vif)) begin
         `uvm_error(get_type_name(), "DUT interface not found")
      end
   endfunction

   virtual task run_phase (uvm_phase phase);
        out_transaction tr;

        wait (vif.rst_n === 1'b1);

        forever begin
            @(vif.mon_cb);
            if ((vif.mon_cb.port_read == 1'b1) && (vif.mon_cb.port_ready == 1'b1)) begin
                tr = out_transaction::type_id::create("tr");
                tr.port_read = vif.mon_cb.port_read;
                tr.port_ready = vif.mon_cb.port_ready;
                tr.port_out = vif.mon_cb.port_out;
                mon_analysis_port.write(tr);
                
                `uvm_info(get_type_name(), $sformatf("MONITOR OUT read=%b ready=%b data=%08h", tr.port_read, tr.port_ready, tr.port_out), UVM_MEDIUM)
            end
        end
   endtask

endclass