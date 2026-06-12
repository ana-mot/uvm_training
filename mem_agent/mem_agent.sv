class mem_agent extends uvm_agent;
 `uvm_component_utils (mem_agent)

   mem_driver drv;
   mem_monitor mon;
   mem_sequencer seqr;

   virtual mem_if vif;

   function new (string name = "mem_agent", uvm_component parent=null);
      super.new (name, parent);
      is_active = UVM_ACTIVE;
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);

      if (get_is_active()) begin
         seqr = mem_sequencer::type_id::create ("seqr", this);
         drv = mem_driver::type_id::create ("drv", this);
      end
      mon = mem_monitor::type_id::create ("mon", this);

   endfunction

   virtual function void connect_phase (uvm_phase phase);
      super.connect_phase(phase);
      if (get_is_active())
        drv.seq_item_port.connect(seqr.seq_item_export);
   endfunction

endclass