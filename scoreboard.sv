import uvm_pkg::*;
`include "uvm_macros.svh"
import mem_pkg::*;
import in_pkg::*;
import out_pkg::*;

`ifndef SCOREBOARD
`define SCOREBOARD

`uvm_analysis_imp_decl(_mem)
`uvm_analysis_imp_decl(_in)
`uvm_analysis_imp_decl(_out0)
`uvm_analysis_imp_decl(_out1)
`uvm_analysis_imp_decl(_out2)
`uvm_analysis_imp_decl(_out3)

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    function new(string name = "scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    uvm_analysis_imp_mem #(mem_transaction, scoreboard) mem_imp;
    uvm_analysis_imp_in #(in_transaction, scoreboard) in_imp;
    uvm_analysis_imp_out0 #(out_transaction, scoreboard) out0_imp;
    uvm_analysis_imp_out1 #(out_transaction, scoreboard) out1_imp;
    uvm_analysis_imp_out2 #(out_transaction, scoreboard) out2_imp;
    uvm_analysis_imp_out3 #(out_transaction, scoreboard) out3_imp;

    bit [7:0] port_addr [4];

    bit [7:0] in_bytes [$];
    bit in_collecting;

    bit [7:0] out_bytes [4][$];

    int reg_checks, reg_pass;
    int parity_checks, parity_pass;
    int routing_checks, routing_pass;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mem_imp = new("mem_imp", this);
        in_imp = new("in_imp", this);
        out0_imp = new("out0_imp", this);
        out1_imp = new("out1_imp", this);
        out2_imp = new("out2_imp", this);
        out3_imp = new("out3_imp", this);
    endfunction

    //---------------------------------------------------
    // de la mem_agent
    virtual function void write_mem(mem_transaction tr);
        if (tr.op == mem_transaction::WRITE) begin
            if (tr.addr < 4) begin
                port_addr[tr.addr] = tr.wr_data;
                `uvm_info(get_type_name(), $sformatf("REG WRITE: port %0d addr <= %02h", tr.addr, tr.wr_data), UVM_MEDIUM)
            end
        end
        else begin
            bit [7:0] actual;
            actual = tr.rd_data[tr.addr*8 +: 8];
            if (tr.addr < 4) begin
                if (actual !== port_addr[tr.addr]) begin
                    `uvm_error(get_type_name(), $sformatf("REG READ MISMATCH: addr=%0d expected=%02h actual=%02h", tr.addr, port_addr[tr.addr], actual))
                end else begin
                    `uvm_info(get_type_name(),$sformatf("REG READ OK: addr=%0d data=%02h", tr.addr, actual), UVM_MEDIUM)
                end
            end
        end
    endfunction

    //---------------------------------------------------
    // de la in_agent
     virtual function void write_in(in_transaction tr);
        // start de frame SOF cu enable HIGH
        if (tr.sw_enable_in == 1'b1 && tr.data_in == in_packet::SOF) begin
            in_bytes.delete();
            in_collecting = 1;
            in_bytes.push_back(tr.data_in);
        end
        else if (in_collecting && tr.sw_enable_in == 1'b1) begin
            in_bytes.push_back(tr.data_in);
            // frame complet = SOF+DA+SA+LEN + LEN payload + PARITY = 5 + LEN octeti
            // byte-ul LEN e pe pozitia 3
            if (in_bytes.size() >= 4 && in_bytes.size() == (5 + in_bytes[3])) begin
                in_collecting = 0;
                check_packet();
            end
        end
    endfunction

    virtual function void check_packet();
        in_packet pkt;
        int n = in_bytes.size();
        bit matched = 0;
        bit [7:0] expected_parity;

        // reasambleaza SOF DA SA LEN payload PARITY
        pkt = in_packet::type_id::create("pkt");
        pkt.da = in_bytes[1];
        pkt.sa = in_bytes[2];
        pkt.length = in_bytes[3];
        pkt.parity = in_bytes[n-1];
        pkt.payload = new[n - 5];
        foreach (pkt.payload[i])
            pkt.payload[i] = in_bytes[4 + i];

        // verificare paritate
        expected_parity = pkt.da ^ pkt.sa ^ pkt.length;
        foreach (pkt.payload[i]) expected_parity ^= pkt.payload[i];
        parity_checks++;
        if (expected_parity !== pkt.parity) begin
            `uvm_error(get_type_name(), $sformatf("PARITY MISMATCH: DA=%02h computed=%02h received=%02h", pkt.da, expected_parity, pkt.parity))
        end
        else begin
            parity_pass++;
            `uvm_info(get_type_name(), $sformatf("PARITY OK: DA=%02h parity=%02h", pkt.da, pkt.parity), UVM_MEDIUM)
        end

        // verificare rutare DA, port cu aceeasi adresa
        foreach (port_addr[i]) begin
            if (port_addr[i] == pkt.da) begin
                matched = 1;
                routing_checks++;
                routing_pass++;
                `uvm_info(get_type_name(), $sformatf("ROUTING OK: DA=%02h -> port %0d (%s)", pkt.da, i, pkt.convert2string()), UVM_MEDIUM)
            end
        end
        if (!matched) begin
            routing_checks++;
            `uvm_info(get_type_name(), $sformatf("ROUTING: DA=%02h no port configured", pkt.da), UVM_MEDIUM)
        end
    endfunction

    //---------------------------------------------------
    // de la out_agent
    virtual function void write_out0(out_transaction tr);
        collect_out(0, tr); 
    endfunction

    virtual function void write_out1(out_transaction tr);
        collect_out(1, tr);
    endfunction

    virtual function void write_out2(out_transaction tr);
        collect_out(2, tr);
    endfunction

    virtual function void write_out3(out_transaction tr);
        collect_out(3, tr);
    endfunction

    virtual function void collect_out(int port, out_transaction tr);
        out_bytes[port].push_back(tr.port_out);
        `uvm_info(get_type_name(), $sformatf("OUT port %0d: byte=%02h (queue size=%0d)", port, tr.port_out, out_bytes[port].size()), UVM_MEDIUM)
    endfunction

   
endclass
`endif