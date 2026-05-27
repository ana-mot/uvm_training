interface out_if(input logic clk, input logic rst_n);
    logic port_read;
    logic [7:0] port_out;
    logic port_ready;

    //--clocking block pentru Driver--
    clocking drv_cb @(posedge clk);
        output port_read;
        input port_out;
        input port_ready;
    endclocking

    //--clocking block pentru Monitor--
    clocking mon_cb @(posedge clk);
        input port_read;
        input port_out;
        input port_ready;
    endclocking

    modport DRIVER (clocking drv_cb);

    modport MONITOR (clocking mon_cb);

    modport DUT (
        input clk,
        input rst_n,
        input port_read,
        output port_out,
        output port_ready
    );

    
endinterface