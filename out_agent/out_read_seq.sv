class out_read_seq extends uvm_sequence #(out_transaction);
    `uvm_object_utils(out_read_seq)

    rand int unsigned n_bytes;
    constraint c_beats { n_bytes inside {[1:64]}; }

    function new(string name = "out_read_seq");
        super.new(name);
    endfunction

    virtual task body();
        out_transaction tr;
        repeat (n_bytes) begin
            tr = out_transaction::type_id::create("tr");
            start_item(tr);
            tr.port_read = 1'b1;
            finish_item(tr);
        end
        tr = out_transaction::type_id::create("tr");
        start_item(tr);
        tr.port_read = 1'b0;
        finish_item(tr);
    endtask
endclass