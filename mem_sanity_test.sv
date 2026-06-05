import uvm_pkg::*;
`include "uvm_macros.svh"
`include "mem_base_test.sv"

`ifndef MEM_SANITY_TEST
`define MEM_SANITY_TEST

class mem_sanity_test extends mem_base_test;
   `uvm_component_utils(mem_sanity_test)

   function new(string name = "mem_sanity_test",uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual task run_phase(uvm_phase phase);
         mem_write_seq wr_seq;
         mem_read_seq  rd_seq;
         super.run_phase(phase);

         phase.raise_objection(this);
        
         repeat (5) begin
            wr_seq = mem_write_seq::type_id::create("wr_seq");
            wr_seq.start(env.mem_ag.seqr);
         end

         #10;
         
         repeat (5) begin
            rd_seq = mem_read_seq::type_id::create("rd_seq");
            rd_seq.start(env.mem_ag.seqr);
         end

         #60;
         phase.drop_objection(this);
   endtask

endclass

`endif