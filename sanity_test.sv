import uvm_pkg::*;
`include "uvm_macros.svh"
import mem_pkg::*;
import in_pkg::*;
import out_pkg::*;
`include "environment.sv"
`ifndef FULL_SANITY_TEST
`define FULL_SANITY_TEST
class sanity_test extends uvm_test;
   `uvm_component_utils(sanity_test)

   environment env;

   function new(string name = "sanity_test", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = environment::type_id::create("env", this);
   endfunction

   virtual task run_phase(uvm_phase phase);
      mem_write_seq wr_seq;
      mem_read_seq  rd_seq;
      in_packet_seq pkt_seq;
      out_read_seq  out_seq;

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
      #20;

      pkt_seq = in_packet_seq::type_id::create("pkt_seq");
      if (!pkt_seq.pkt.randomize() with { da == 8'h00; length inside {[1:4]}; })
         `uvm_error(get_type_name(), "pkt randomize failed")
      pkt_seq.start(env.in_ag.seqr);
      #20;

      out_seq = out_read_seq::type_id::create("out_seq");
      out_seq.start(env.out_ag[0].seqr);

      #100;
      phase.drop_objection(this);
   endtask
endclass
`endif