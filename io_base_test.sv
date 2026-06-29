import uvm_pkg::*;
`include "uvm_macros.svh"
import mem_pkg::*;
import in_pkg::*;
import out_pkg::*;
`include "environment.sv"

`ifndef IO_BASE_TEST
`define IO_BASE_TEST

class io_base_test extends uvm_test;
   `uvm_component_utils(io_base_test)
   environment env;
   function new(string name = "io_base_test", uvm_component parent = null);
      super.new(name, parent);
   endfunction
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = environment::type_id::create("env", this);
   endfunction
endclass

`endif