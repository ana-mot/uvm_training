import uvm_pkg::*;
`include "uvm_macros.svh"
import mem_pkg::*;

`ifndef ENVIRONMENT
`define ENVIRONMENT
class environment extends uvm_env;

   `uvm_component_utils(environment)

   mem_agent mem_ag;

   function new(string name = "environment", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mem_ag = mem_agent::type_id::create("mem_ag",this);

   endfunction

endclass
`endif