import uvm_pkg::*;
`include "uvm_macros.svh"
`include "master_seqits.svh"
`include "master_params.svh"

//////////////////////// SEQUENCER////////////////////////////////////////

class master_sequence extends uvm_sequence #(master_seqit);
    `uvm_object_utils(master_sequence);
    
    function new(string name = "master_sequence");
        super.new(name);
    endfunction: new

    master_seqit axi_m; // the transaction

    task AXI_MASTER_write(input master_seqit axi_m);
        assert(axi_m.randomize with {axi_m.m_valid = 1, set_write(axi_m)});
        axi_m.update_state(); // updates state
        else `uvm_fatal("re_trans sequence", "Not able to randomize");
        start_item(axi_m);
        finish_item(axi_m);
    endtask

    task AXI_MASTER_read(input master_seqit axi_m);
        assert(axi_m.randomize with {axi_m.m_ready = 1, set_read(axi_m)});
        axi_m.update_state(); // updates state
        else `uvm_fatal("re_trans sequence", "Not able to randomize");
        start_item(axi_m);
        finish_item(axi_m);
    endtask

    task body;
        axi_m = master_seqit#(DATA_WIDTH):: type_id::create("req_item"); // Building  
        // TODO ADD ALL TESTS
    endtask 

endclass
/////////////////// BASE SEQUENCE/////////////////////////////
class master_base_sequence extends uvm_sequence #(master_seqit);
    `uvm_object_utils(master_base_sequence);

    function new(string name = "master_base_sequence");
        super.new(name);
    endfunction: new

    task body(); 
    endtask

    task AXI_rewr_send;
        input logic randomize;
        input logic ARVALID;
        input logic RVALID;
        input logic RLAST;
        input logic RDATA;
        input logic [1:0] RRESP;
        input logic [1:0] USER;
        input logic ID;
        input logic AWREADY;
        input logic WREADY;
        input logic BVALID;
        input logic [1:0] BRESP;
        begin
            master_seqit rewr_trans;
            rewr_trans = master_seqit::type_id::create(NUM_ID,NUM_USER,DATA_LEN)::type_id::create("rewr_trans"); // building with factory 
            start_item(re_trans);
            if(randomize) begin
                if(!rewr_trans.randomize()) begin
                    `uvm_fatal("re_trans sequence", "Not able to randomize")
                end
            end
            else begin 
                if(rewr_trans.trans_t == READ) begin
                    rewr_trans.ARVALID = ARVALID;
                    rewr_trans.RVALID = RVALID;
                    rewr_trans.RLAST = RLAST;
                    rewr_trans.RDATA = RDATA;
                    rewr_trans.RRESP = RDATA;
                end
                else if(rewr_trans.trans_t == WRITE) begin
                    wr_trans.AWREADY = AWREADY;
                    wr_trans.WREADY = WREADY;
                    wr_trans.BVALID = BVALID;
                    wr_trans.BRESP = BRESP;
                end
                else begin
                    rewr_trans.ARVALID = ARVALID;
                    rewr_trans.RVALID = RVALID;
                    rewr_trans.RLAST = RLAST;
                    rewr_trans.RDATA = RDATA;
                    rewr_trans.RRESP = RDATA;
                    rewr_trans.AWREADY = AWREADY;
                    rewr_trans.WREADY = WREADY;
                    rewr_trans.BVALID = BVALID;
                    rewr_trans.BRESP = BRESP;
                end
            end
            rewr_trans.RUSER = USER;
            rewr_trans.RID = ID;
            rewr_trans.AWID = ID;
            rewr_trans.BID = ID;
            finish_item(wr_trans);
        end
    endtask

    
endclass: master_sequence

///////////////////////////// axi_write_sequence ////////////////////////////////////////
class axi_write_sequence extends master_base_sequence
    `uvm_object_utils(axi_write_sequence);

    function new(string name = "axi_write_sequence");
        super.new(name);
    endfunction: new

    task AXI_rewr_send;
        input logic randomize;
        input logic ARVALID;
        input logic RVALID;
        input logic RLAST;
        input logic RDATA;
        input logic [1:0] RRESP;
        input logic [1:0] USER;
        input logic ID;
        input logic AWREADY;
        input logic WREADY;
        input logic BVALID;
        input logic [1:0] BRESP;
        begin
            master_seqit rewr_trans;
            rewr_trans = master_seqit::type_id::create(NUM_ID,NUM_USER,DATA_LEN)::type_id::create("rewr_trans"); // building with factory 
            rewr_trans.trans_t = WRITE; // force set WRITE transaction
            start_item(re_trans);
            if(randomize) begin
                if(!rewr_trans.randomize()) begin
                    `uvm_fatal("re_trans sequence", "Not able to randomize")
                end
            end
            else begin 
                if(rewr_trans.trans_t == READ) begin
                    rewr_trans.ARVALID = ARVALID;
                    rewr_trans.RVALID = RVALID;
                    rewr_trans.RLAST = RLAST;
                    rewr_trans.RDATA = RDATA;
                    rewr_trans.RRESP = RDATA;
                end
                else if(rewr_trans.trans_t == WRITE) begin
                    wr_trans.AWREADY = AWREADY;
                    wr_trans.WREADY = WREADY;
                    wr_trans.BVALID = BVALID;
                    wr_trans.BRESP = BRESP;
                end
                else begin
                    rewr_trans.ARVALID = ARVALID;
                    rewr_trans.RVALID = RVALID;
                    rewr_trans.RLAST = RLAST;
                    rewr_trans.RDATA = RDATA;
                    rewr_trans.RRESP = RDATA;
                    rewr_trans.AWREADY = AWREADY;
                    rewr_trans.WREADY = WREADY;
                    rewr_trans.BVALID = BVALID;
                    rewr_trans.BRESP = BRESP;
                end
            end
            rewr_trans.RUSER = USER;
            rewr_trans.RID = ID;
            rewr_trans.AWID = ID;
            rewr_trans.BID = ID;
            finish_item(wr_trans);
        end
    endtask

    task body(); 
        AXI_rewr_send(1,0,0,0,0,0,0,0,0,0,0,0); // send read and write transaction
        #10;
        // TODO add more test cases
    endtask
endclass

///////////////////////////// axi_read_sequence ////////////////////////////////////////
class axi_read_sequence extends master_base_sequence
    `uvm_object_utils(axi_read_sequence);

    task AXI_rewr_send;
        input logic randomize;
        input logic ARVALID;
        input logic RVALID;
        input logic RLAST;
        input logic RDATA;
        input logic [1:0] RRESP;
        input logic [1:0] USER;
        input logic ID;
        input logic AWREADY;
        input logic WREADY;
        input logic BVALID;
        input logic [1:0] BRESP;
        begin
            master_seqit rewr_trans;
            rewr_trans = master_seqit::type_id::create(NUM_ID,NUM_USER,DATA_LEN)::type_id::create("rewr_trans"); // building with factory 
            rewr_trans.trans_t = READ; // force set READ transaction
            start_item(re_trans);
            if(randomize) begin
                if(!rewr_trans.randomize()) begin
                    `uvm_fatal("re_trans sequence", "Not able to randomize")
                end
            end
            else begin 
                if(rewr_trans.trans_t == READ) begin
                    rewr_trans.ARVALID = ARVALID;
                    rewr_trans.RVALID = RVALID;
                    rewr_trans.RLAST = RLAST;
                    rewr_trans.RDATA = RDATA;
                    rewr_trans.RRESP = RDATA;
                end
                else if(rewr_trans.trans_t == WRITE) begin
                    wr_trans.AWREADY = AWREADY;
                    wr_trans.WREADY = WREADY;
                    wr_trans.BVALID = BVALID;
                    wr_trans.BRESP = BRESP;
                end
                else begin
                    rewr_trans.ARVALID = ARVALID;
                    rewr_trans.RVALID = RVALID;
                    rewr_trans.RLAST = RLAST;
                    rewr_trans.RDATA = RDATA;
                    rewr_trans.RRESP = RDATA;
                    rewr_trans.AWREADY = AWREADY;
                    rewr_trans.WREADY = WREADY;
                    rewr_trans.BVALID = BVALID;
                    rewr_trans.BRESP = BRESP;
                end
            end
            rewr_trans.RUSER = USER;
            rewr_trans.RID = ID;
            rewr_trans.AWID = ID;
            rewr_trans.BID = ID;
            finish_item(wr_trans);
        end
    endtask

    function new(string name = "axi_read_sequence");
        super.new(name);
    endfunction: new

    task body(); 
        AXI_read_send(1,0,0,0,0,0,0,0); // send write_transction
        #10;
        // TODO add more test cases
    endtask
endclass

// //////////////////////// axi_read_and_write_sequence ////////////////////////////////////////
// class axi_read_and_write_sequence extends master_base_sequence
//     `uvm_object_utils(axi_read_and_write_sequence);

//     function new(string name = "axi_read_and_write_sequence");
//         super.new(name);
//     endfunction: new

//     task body(); 
//         AXI_rewr_send(1,0,0,0,0,0,0,0,0,0,0,0); // send read and write transaction
//         #10;
//         // TODO add more test cases
//     endtask
// endclass













// task AXI_write_send; // TODO NEED TO LOOK INTO BUS MODEL SIDE
//     input logic randomize;
//     input logic AWREADY;
//     input logic WREADY;
//     input logic BVALID;
//     input logic [1:0] BRESP;
//     input logic ID;
//     begin
//         write_transaction wr_trans;
//         wr_trans = write_transaction::type_id::create(NUM_ID,NUM_USER,DATA_LEN)::type_id::create("wr_trans"); // building with factory 
//         start_item(wr_trans);
//         if(randomize) begin
//             if(!wr_trans.randomize()) begin
//                 `uvm_fatal("wr_trans sequence", "Not able to randomize")
//             end
//         end
//         else begin
//             wr_trans.AWREADY = AWREADY;
//             wr_trans.WREADY = WREADY;
//             wr_trans.BVALID = BVALID;
//             wr_trans.BRESP = BRESP;
//         end
//         wr_trans.AWID = ID;
//         wr_trans.BID = ID;
//         finish_item(wr_trans);
//     end
// endtask

// task AXI_read_send;
//     input logic randomize;
//     input logic ARVALID;
//     input logic RVALID;
//     input logic RLAST;
//     input logic RDATA;
//     input logic [1:0] RRESP;
//     input logic [1:0] USER;
//     input logic ID;
//     begin
//         read_transaction re_trans;
//         re_trans = write_transaction::type_id::create(NUM_ID,NUM_USER,DATA_LEN)::type_id::create("re_trans"); // building with factory 
//         start_item(re_trans);
//         if(randomize) begin
//             if(!re_trans.randomize()) begin
//                 `uvm_fatal("re_trans sequence", "Not able to randomize")
//             end
//         end
//         else begin 
//             re_trans.ARVALID = ARVALID;
//             re_trans.RVALID = RVALID;
//             re_trans.RLAST = RLAST;
//             re_trans.RDATA = RDATA;
//             re_trans.RRESP = RDATA;
//         end
//         re_trans.RUSER = USER;
//         re_trans.RID = ID;
//         finish_item(wr_trans);
//     end
// endtask

// task AXI_rewr_send;
//     input logic randomize;
//     input logic ARVALID;
//     input logic RVALID;
//     input logic RLAST;
//     input logic RDATA;
//     input logic [1:0] RRESP;
//     input logic [1:0] USER;
//     input logic ID;
//     input logic AWREADY;
//     input logic WREADY;
//     input logic BVALID;
//     input logic [1:0] BRESP;
//     begin
//         read_and_write_transaction rewr_trans;
//         rewr_trans = write_transaction::type_id::create(NUM_ID,NUM_USER,DATA_LEN)::type_id::create("rewr_trans"); // building with factory 
//         start_item(re_trans);
//         if(randomize) begin
//             if(!rewr_trans.randomize()) begin
//                 `uvm_fatal("re_trans sequence", "Not able to randomize")
//             end
//         end
//         else begin 
//             rewr_trans.ARVALID = ARVALID;
//             rewr_trans.RVALID = RVALID;
//             rewr_trans.RLAST = RLAST;
//             rewr_trans.RDATA = RDATA;
//             rewr_trans.RRESP = RDATA;
//             rewr_trans.AWREADY = AWREADY;
//             rewr_trans.WREADY = WREADY;
//             rewr_trans.BVALID = BVALID;
//             rewr_trans.BRESP = BRESP;
//         end
//         rewr_trans.RUSER = USER;
//         rewr_trans.RID = ID;
//         rewr_trans.AWID = ID;
//         rewr_trans.BID = ID;
//         finish_item(wr_trans);
//     end
// endtask