class in_packet extends uvm_sequence_item;
    `uvm_object_utils(in_packet)

    static const bit [7:0] SOF = 8'hFF;
    static const bit [7:0] EOF = 8'h55;

    rand bit [7:0] da;
    rand bit [7:0] sa;
    rand bit [7:0] length;
    rand bit [7:0] payload [];
    bit [7:0] parity;

    constraint c_length { length inside {[0:254]}; }
    constraint c_payload_size { payload.size() == length; }

    constraint c_da { da != SOF; da != EOF; }
    constraint c_sa { sa != SOF; sa != EOF; }
    constraint c_payload_vals {
        foreach (payload[i]) {
            payload[i] != SOF;
            payload[i] != EOF;
        }
    }

    function new(string name = "in_packet");
        super.new(name);
    endfunction

    function string convert2string();
        string s;
        s = $sformatf("DA=%0h SA=%0h LENGTH=%0d PARITY=%0h ", da, sa, length, parity);
        foreach (payload[i]) s = {s, $sformatf(" PAYLOAD= %02h", payload[i])};
        return s;
    endfunction
endclass