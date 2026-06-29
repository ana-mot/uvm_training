import uvm_pkg::*;
`include "uvm_macros.svh"
import mem_pkg::*;
import in_pkg::*;
import out_pkg::*;
`include "environment.sv"

`ifndef BASE_TEST
`define BASE_TEST

class base_test extends uvm_test;
   `uvm_component_utils(base_test)

   environment env;

   function new(string name = "base_test", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = environment::type_id::create("env", this);
   endfunction

   virtual task configure_ports(bit [7:0] addr [4]);
      mem_write_seq wr;
      foreach (addr[i]) begin
         wr = mem_write_seq::type_id::create($sformatf("cfg_wr_%0d", i));
         // mem_write_seq randomizeaza intern; pentru adrese deterministe
         // vezi nota de mai jos despre o secventa dirijata
      end
   endtask


   virtual task send_packet(bit [7:0] da, bit [7:0] sa, bit [7:0] payload []);
      in_packet_seq pkt;
      pkt = in_packet_seq::type_id::create("pkt");
      pkt.pkt.da = da;
      pkt.pkt.sa = sa;
      pkt.pkt.length = payload.size();
      pkt.pkt.payload = payload;
      pkt.start(env.in_ag.seqr);
   endtask

   // citeste de pe un port
   virtual task read_port(int port);
      out_read_seq rd;
      rd = out_read_seq::type_id::create("rd");
      rd.start(env.out_ag[port].seqr);
   endtask

   virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);
   endtask
endclass
`endif