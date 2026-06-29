class out_agent extends uvm_agent;
 `uvm_component_utils (out_agent)

   out_driver drv;
   out_monitor mon;
   out_sequencer seqr;

   virtual out_if vif;

   int port_id = 0;

   function new (string name = "out_agent", uvm_component parent=null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);

      uvm_config_db#(int)::get(this, "", "port_id", port_id);

      if (get_is_active()) begin
         seqr = out_sequencer::type_id::create ("seqr", this);
         drv = out_driver::type_id::create ("drv", this);
      end
      mon = out_monitor::type_id::create ("mon", this);

   endfunction

   virtual function void connect_phase (uvm_phase phase);
      super.connect_phase(phase);
      if (get_is_active())
        drv.seq_item_port.connect(seqr.seq_item_export);
   endfunction

endclass