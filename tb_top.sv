`timescale 1ps/1ps

import uvm_pkg::*;
`include "uvm_macros.svh"

import mem_pkg::*;

`include "mem_base_test.sv"
`include "mem_sanity_test.sv"
module top;

    logic clk;
    logic rst_n;

    parameter NUM_OF_PORTS = 4;
    parameter FIFO_SIZE = 256;
    parameter WORD_WIDTH = 8;


    mem_if mem_if (.clk(clk), .rst_n(rst_n));
    in_if in_if(.clk(clk), .rst_n(rst_n));
    out_if out_if(.clk(clk), .rst_n(rst_n));

    switch_top #(.NUM_OF_PORTS(NUM_OF_PORTS),
                .FIFO_SIZE(FIFO_SIZE),
                .WORD_WIDTH(WORD_WIDTH)) 
    dut(
        .clk(clk), 
        .rst_n(rst_n),
        .data_in(in_if.data_in),
        .sw_enable_in(in_if.sw_enable_in),
        .port_read(out_if.port_read),
        .mem_sel_en(mem_if.mem_sel_en),
        .mem_wr_rd_s(mem_if.mem_wr_rd_s),
        .mem_addr(mem_if.mem_addr),
        .mem_wr_data(mem_if.mem_wr_data),
        .read_out(in_if.read_out),
        .port_out(out_if.port_out),
        .port_ready(out_if.port_ready),
        .mem_rd_data(mem_if.mem_rd_data),
        .mem_ack(mem_if.mem_ack)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        uvm_config_db #(virtual mem_if)::set(null, "*","vif",mem_if);
        run_test("mem_sanity_test");
    end
    
    
endmodule