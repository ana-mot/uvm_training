interface mem_if (input logic clk), input logic rst_n;
	logic mem_sel_en;
	logic mem_wr_rd_s;
	logic [7:0] mem_addr;
	logic [7:0] mem_wr_data;
	logic [31:0] mem_rd_data;
	logic [3:0] mem_ack;
	
	//--clocking block pentru Driver--
    clocking drv_cb @(posedge clk);
        output mem_sel_en;
        output mem_wr_rd_s;
        output mem_addr;
        output mem_wr_data;

        input  mem_rd_data;
        input  mem_ack;
    endclocking

    //--clocking block pentru Monitor--
    clocking mon_cb @(posedge clk);
        input mem_sel_en;
        input mem_wr_rd_s;
        input mem_addr;
        input mem_wr_data;
        input mem_rd_data;
        input mem_ack;

    endclocking

    modport DRIVER (clocking drv_cb);

    modport MONITOR (clocking mon_cb);

    modport DUT (
        input clk,
        input rst_n,
        input mem_sel_en,
        input mem_wr_rd_s,
        input mem_addr,
        input mem_wr_data,
        output mem_rd_data,
        output mem_ack
    );

endinterface