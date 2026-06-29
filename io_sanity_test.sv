import uvm_pkg::*;
`include "uvm_macros.svh"
import mem_pkg::*;
import in_pkg::*;
import out_pkg::*;
`include "environment.sv"

`ifndef IO_SANITY_TEST
`define IO_SANITY_TEST

class io_sanity_test extends uvm_test;
   `uvm_component_utils(io_sanity_test)

   environment env;

   function new(string name = "io_sanity_test", uvm_component parent = null);
        super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = environment::type_id::create("env", this);
   endfunction

   virtual task run_phase(uvm_phase phase);
        in_packet_seq pkt_seq;
        out_read_seq rd_seq;

        super.run_phase(phase);
        phase.raise_objection(this);

        pkt_seq = in_packet_seq::type_id::create("pkt_seq");
        if (!pkt_seq.randomize() with {
                pkt.da     == 8'h00;
                pkt.length inside {[1:4]};})
            `uvm_error(get_type_name(), "in_packet_seq randomize failed")
        pkt_seq.start(env.in_ag.seqr);
        #20;

        rd_seq = out_read_seq::type_id::create("rd_seq");
        if (!rd_seq.randomize() with { n_bytes == 16; })
            `uvm_error(get_type_name(), "out_read_seq randomize failed")
        rd_seq.start(env.out_ag[0].seqr);

        #100;
        phase.drop_objection(this);
   endtask
endclass
`endif