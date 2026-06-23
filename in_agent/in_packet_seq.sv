class in_packet_seq extends uvm_sequence#(in_transaction);
	`uvm_object_utils(in_packet_seq)

    rand in_packet pkt;
	
	function new(string name = "in_packet_seq");
		super.new(name);
        pkt = in_packet::type_id::create("pkt");
	endfunction

    virtual task send_byte(bit sw_en, bit [7:0] data);
        in_transaction tr;
        tr = in_transaction::type_id::create("tr");
        start_item(tr);
        tr.sw_enable_in = sw_en;
        tr.data_in  = data;
        finish_item(tr);
    endtask
	
	virtual task body();

        send_byte(1'b1, in_packet::SOF);
        send_byte(1'b1, pkt.da);
        send_byte(1'b1, pkt.sa);
        send_byte(1'b1, pkt.length);
        foreach (pkt.payload[i])
            send_byte(1'b1, pkt.payload[i]);
        send_byte(1'b1, pkt.parity);
        send_byte(1'b0, in_packet::EOF);

        `uvm_info(get_type_name(),$sformatf("Frame: %s", pkt.convert2string()), UVM_MEDIUM)
        
	endtask
endclass