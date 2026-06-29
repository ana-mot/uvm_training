class in_monitor extends uvm_monitor;
    `uvm_component_utils(in_monitor)

    virtual in_if vif;

    uvm_analysis_port #(in_transaction)  mon_analysis_port;

    function new (string name = "in_monitor", uvm_component parent= null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);

      mon_analysis_port = new ("mon_analysis_port", this);

      if (!uvm_config_db#(virtual in_if)::get(this, "", "in_vif", vif)) begin
         `uvm_error(get_type_name(), "DUT interface not found")
      end
   endfunction

   virtual task run_phase (uvm_phase phase);
        in_transaction tr;

        wait (vif.rst_n == 1'b1);

        forever begin
            @(vif.mon_cb);
            if (vif.mon_cb.sw_enable_in == 1'b1) begin
               tr = in_transaction::type_id::create("tr");
               tr.sw_enable_in = vif.mon_cb.sw_enable_in;
               tr.data_in  = vif.mon_cb.data_in;
               mon_analysis_port.write(tr);

               `uvm_info(get_type_name(), $sformatf("MONITOR IN sw_en=%0b data=%02h", tr.sw_enable_in, tr.data_in), UVM_MEDIUM)
            end
      end
   endtask

endclass
class in_monitor extends uvm_monitor;
    `uvm_component_utils(in_monitor)

    virtual in_if vif;

    uvm_analysis_port #(in_transaction)  mon_analysis_port;

    function new (string name = "in_monitor", uvm_component parent= null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);

      mon_analysis_port = new ("mon_analysis_port", this);

      if (! uvm_config_db #(virtual in_if) :: get (this, "", "vif", vif)) begin
         `uvm_error (get_type_name (), "DUT interface not found")
      end
   endfunction

   virtual task run_phase (uvm_phase phase);
        in_transaction tr;

        wait (vif.rst_n == 1'b1);

        forever begin
            @(vif.mon_cb);
            if (vif.mon_cb.sw_enable_in == 1'b1) begin
               tr = in_transaction::type_id::create("tr");
               tr.sw_enable_in = vif.mon_cb.sw_enable_in;
               tr.data_in  = vif.mon_cb.data_in;
               mon_analysis_port.write(tr);

               `uvm_info(get_type_name(), $sformatf("MONITOR IN sw_en=%0b data=%02h", tr.sw_enable_in, tr.data_in), UVM_MEDIUM)
            end
      end
   endtask

endclass