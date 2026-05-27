class in_agent extends uvm_agent;
 `uvm_component_utils (in_agent)

   in_driver drv;
   in_monitor mon;
   in_sequencer seqr;

   virtual in_if vif;

   function new (string name = "in_agent", uvm_component parent=null);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);

      if (get_is_active()) begin
         seqr = in_sequencer::type_id::create ("seqr", this);
         drv = in_driver::type_id::create ("drv", this);
      end
      mon = in_monitor::type_id::create ("mon", this);

   endfunction

   virtual function void connect_phase (uvm_phase phase);
      super.connect_phase(phase);
      if (get_is_active())
        drv.seq_item_port.connect(seqr.seq_item_export);
   endfunction

endclass