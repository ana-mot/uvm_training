import uvm_pkg::*;
`include "uvm_macros.svh"
import mem_pkg::*;
<<<<<<< Updated upstream
=======
import in_pkg::*;
import out_pkg::*;
`include "scoreboard.sv"
>>>>>>> Stashed changes

`ifndef ENVIRONMENT
`define ENVIRONMENT

class environment extends uvm_env;

   `uvm_component_utils(environment)

   mem_agent mem_ag;
<<<<<<< Updated upstream
=======
   in_agent in_ag;
   out_agent out_ag [4];
   scoreboard sb;
>>>>>>> Stashed changes

   function new(string name = "environment", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mem_ag = mem_agent::type_id::create("mem_ag",this);
<<<<<<< Updated upstream
=======
      in_ag = in_agent::type_id::create("in_ag", this);
      sb = scoreboard::type_id::create("sb", this);

      foreach (out_ag[i]) begin
         out_ag[i] = out_agent::type_id::create($sformatf("out_ag_%0d", i), this);
         uvm_config_db#(int)::set(this, $sformatf("out_ag_%0d", i), "port_id", i);
      end
>>>>>>> Stashed changes

   endfunction

   virtual function void connect_phase (uvm_phase phase);
      super.connect_phase(phase);
      mem_ag.mon.mon_analysis_port.connect(sb.mem_imp);
      in_ag.mon.mon_analysis_port.connect(sb.in_imp);
      out_ag[0].mon.mon_analysis_port.connect(sb.out0_imp);
      out_ag[1].mon.mon_analysis_port.connect(sb.out1_imp);
      out_ag[2].mon.mon_analysis_port.connect(sb.out2_imp);
      out_ag[3].mon.mon_analysis_port.connect(sb.out3_imp);
   endfunction

endclass
`endif