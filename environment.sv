import uvm_pkg::*;
`include "uvm_macros.svh"
import mem_pkg::*;
import in_pkg::*;
import out_pkg::*;

`ifndef ENVIRONMENT
`define ENVIRONMENT
class environment extends uvm_env;

   `uvm_component_utils(environment)

   mem_agent mem_ag;
   in_agent in_ag;
   out_agent out_ag [4];

   function new(string name = "environment", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mem_ag = mem_agent::type_id::create("mem_ag",this);
      in_ag = in_agent::type_id::create("in_ag", this);

      foreach (out_ag[i]) begin
         out_ag[i] = out_agent::type_id::create($sformatf("out_ag_%0d", i), this);
      end

   endfunction

endclass
`endif