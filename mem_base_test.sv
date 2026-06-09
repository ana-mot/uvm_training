import uvm_pkg::*;
`include "uvm_macros.svh"
`include "environment.sv"

`ifndef MEM_BASE_TEST
`define MEM_BASE_TEST

class mem_base_test extends uvm_test;

   `uvm_component_utils(mem_base_test)

   environment env;
   virtual mem_if vif;

   function new(string name = "mem_base_test",uvm_component parent = null);
      super.new(name, parent);
   endfunction


   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = environment::type_id::create("env", this);
       if(!uvm_config_db#(virtual mem_if)::get(this, "", "vif", vif))
         `uvm_fatal("NOVIF", "no mem_if")
   endfunction

   /*virtual task reset_dut();
      vif.rst_n <= 0;
      repeat(5) @(posedge vif.clk);
      vif.rst_n <= 1;
      repeat(2) @(posedge vif.clk);

   endtask

   virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      reset_dut();
      phase.drop_objection(this);
   endtask*/


endclass

`endif