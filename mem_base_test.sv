import uvm_pkg::*;
`include "uvm_macros.svh"
`include "environment.sv"

`ifndef MEM_BASE_TEST
`define MEM_BASE_TEST

class mem_base_test extends uvm_test;

   `uvm_component_utils(mem_base_test)

   environment env;

   function new(string name = "mem_base_test",uvm_component parent = null);
      super.new(name, parent);
   endfunction


   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = environment::type_id::create("env", this);
   endfunction


endclass

`endif