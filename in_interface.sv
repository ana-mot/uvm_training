interface in_if(input logic clk, input logic rst_n);
    logic sw_enable_in;
    logic [7:0] data_in;
    logic read_out;

    //--clocking block pentru Driver--
    clocking drv_cb @(posedge clk);
        output sw_enable_in;
        output data_in;
        input read_out;
    endclocking

    //--clocking block pentru Monitor--
    clocking mon_cb @(posedge clk);
        input sw_enable_in;
        input data_in;
        input read_out;
    endclocking

    modport DRIVER (clocking drv_cb);

    modport MONITOR (clocking mon_cb);

    modport DUT (
        input clk,
        input rst_n,
        input sw_enable_in,
        input data_in,
        output read_out
    );

    
endinterface