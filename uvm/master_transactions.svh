`ifndef MASTER_TRANSACTIONS
`define MASTER_TRANSACTIONS
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "master_params.svh"


class master_transaction #(parameter NUM_ID = NUM_ID, parameter NUM_USER = NUM_USER, parameter DAT_LEN = DAT_LEN) extends uvm_tlm_generic_payload; 
    rand Channel Channel;
    rand logic [DAT_LEN - 1:0] m_data[]; // FLAG this field can be up to 1024 so I need to figure out how to test it maybe multiple diffrent tests
    rand bit nRST;
    rand bit m_ready;
    rand bit m_valid;
    rand bit [1:0] m_BURST;
    rand bit [3:0] m_CACHE;
    rand bit m_LOCK;
    rand bit [31:0] m_address;
    rand bit [1:0] m_BURST_type;
    rand bit [2:0] m_BURST_size;
    rand bit [2:0] m_streaming_width;
    rand bit [3:0] m_byte_enable_length;


`uvm_object_utils_begin(master_transaction)
    `uvm_field_array_int(m_data, UVM_NOCOMPARE)
    `uvm_field_int(Channel, UVM_NOCOMPARE)
    `uvm_field_int(nRST, UVM_NOCOMPARE)
    `uvm_field_int(ready, UVM_NOCOMPARE)
    `uvm_field_int(valid, UVM_NOCOMPARE)
    `uvm_field_int(m_BURST, UVM_NOCOMPARE)
    `uvm_field_int(m_CACHE, UVM_NOCOMPARE)
    `uvm_field_int(m_LOCK, UVM_NOCOMPARE)
    `uvm_field_int(m_address, UVM_NOCOMPARE)
    `uvm_field_int(m_BURST_type, UVM_NOCOMPARE)
    `uvm_field_int(m_BURST_size, UVM_NOCOMPARE)
    `uvm_field_int(m_streaming_width, UVM_NOCOMPARE)
    `uvm_field_int(m_byte_enable_length, UVM_NOCOMPARE)
`uvm_object_utils_end

    // Trying to keep track of what type of tranaction have been sent 
    static bit addr_type_sent = 0;
    static bit data_type_sent = 0;
    static bit response_type_sent = 0;

    constraint type_sent {
        if(!addr_type_sent) begin
            Channel != DATA;
            Channel != RESPONSE;
        end 

        if(!data_type_sent) begin
            Channel != RESPONSE;
            Channel != DATA;
        end

        if(response_type_sent) begin
            Channel == RESPONSE;
        end
    }
    constraint ready_valid {
        if(ready == 1) valid != 1;
        else if(valid == 1) ready != 1;

        if(Channel == ADDRESS || ((Channel == DATA) && m_command == UVM_TLM_WRITE_COMMAND)) begin
            ready != 1;
        end

        if(Channel == DATA && (m_command == UVM_TLM_READ_COMMAND)) begin
            valid != 1;
        end    
    }
    
    constraint bursts {
        if(m_BURST_type == WRAP)
            m_BURST_size inside {3'b001,3'b010,3'b011,3'b100};
    }

    constraint cache {
        m_CACHE inside {4'b0000, 4'b0001, 4'b0010, 4'b0011, 
        4'b0110, 4'b0111, 4'b1010, 4'b1011, 4'b1110, 4'b1111};
    }

    constraint channel_cons { // I think this maybe a redundant constraint
        Channel inside {ADDRESS, DATA};
    }

    constraint byte_enable {
        m_byte_enable == '1; // do not want to lose any bytes yet
        m_byte_enable_length == m_length; // Made them both equal to eachh other 
    }


    
    function new(string name = "master_transaction");
        super.new(name);
    endfunction: new
    
    function void update_state();
        if(Channel == ADDRESS) begin
            addr_type_sent = 1; // Mark addr type sent
            data_type_sent = 0;
            response_type_sent = 0;
        end

        else if(Channel == DATA) begin
            addr_type_sent = 0;
            data_type_sent = 1; // Mark data type sent
            response_type_sent = 0;
        end

        else if(Channel == RESPONSE) begin
            addr_type_sent = 0;
            data_type_sent = 0; 
            response_type_sent = 1; // Mark response type sent
        end

      endfunction
endclass






























// class master_transaction #(parameter NUM_ID = NUM_ID, parameter NUM_USER = NUM_USER, parameter DATA_LEN = DAT_LEN) extends uvm_sequence_item;
//     // Group: Variables

//     rand TYPE_TRANS trans_t;
//     /////////////// WRITE ADDR CHANNEL/////////////////
//     // INPUTS
//     rand bit AWREADY;
//     // OUTPUTS
//     bit AWVALID;
//     bit [31:0] AWADDR;
//     bit [2:0] AWSIZE;
//     bit [1:0] AWBURST;
//     bit [3:0] AWCACHE
//     bit [2:0] AWPROT
//     bit [NUM_ID - 1:0] AWID;
//     bit [7:0] AWLEN;
//     bit AWLOCK;
//     bit [3:0] AWQOS;
//     bit [3:0] AWREGION;
//     bit [NUM_USER- 1:0] AWUSER; // Todo look into size


//     /////////////// WRITE DATA CHANNEL/////////////////
//     // INPUTS
//     rand bit WREADY;
//     // OUTPUTS
//     bit WVALID;
//     bit WLAST;
//     bit [DATA_LEN- 1:0] WDATA;
//     bit [x:0] WSTRB; // Todo figure out len
//     bit [NUM_ID - 1: 0] WUSER; // Todo look into size

//     /////////////// WRITE RESPONSE CHANNEL/////////////////
//     // INPUTS
//     rand bit BVALID;
//     rand bit [1:0] BRESP;
//     bit BID; // MAYBE NOT
//     // OUTPUTS
//     bit BREADY;
//     bit BUSER; // Todo look into size

//    /////////////// READ ADDR CHANNEL/////////////////
//     // INPUTS
//     rand bit ARVALID;
//     // OUTPUTS
//     bit ARREADY;
//     bit [31:0] ARADDR;
//     bit [2:0] ARSIZE;
//     bit [1:0] ARBURST;
//     bit [3:0] ARCACHE;
//     bit [2:0] ARPROT;
//     bit [NUM_ID - 1:0] ARID;
//     bit [7:0] ARLEN;
//     bit ARLOCK;
//     bit [3:0] ARQOS;
//     bit [3:0] ARREGION;
//     bit [NUM_USER- 1:0] ARUSER; // Todo look into size

//     /////////////// READ DATA CHANNEL/////////////////
//     // INPUTS
//     rand bit RVALID;
//     rand bit RLAST;
//     rand bit [DATA_LEN- 1:0] RDATA;
//     rand bit [1:0] RRESP;
//     rand bit [NUM_ID - 1:0] RID;
//     rand bit [NUM_ID - 1: 0] RUSER; // Todo look into size
//     // OUTPUTS
//     bit RREADY;

// `uvm_object_utils_begin(write_transction)
//     `uvm_field_int(trans_t,UVM_NOCOMPARE)
//     `uvm_field_int(AWREADY,UVM_NOCOMPARE)
//     `uvm_field_int(AWADDR,UVM_DEFAULT)
//     `uvm_field_int(AWSIZE,UVM_DEFAULT)
//     `uvm_field_int(AWBURST,UVM_DEFAULT)
//     `uvm_field_int(AWCACHE,UVM_DEFAULT)
//     `uvm_field_int(AWPROT,UVM_DEFAULT)
//     `uvm_field_int(AWID,UVM_DEFAULT)
//     `uvm_field_int(AWLEN,UVM_DEFAULT)
//     `uvm_field_int(AWLOCK,UVM_DEFAULT)
//     `uvm_field_int(AWQOS,UVM_DEFAULT)
//     `uvm_field_int(AWREGION,UVM_DEFAULT)
//     `uvm_field_int(AWUSER,UVM_DEFAULT)

//     `uvm_field_int(WREADY,UVM_NOCOMPARE)
//     `uvm_field_int(WVALID,UVM_DEFAULT)
//     `uvm_field_int(WLAST,UVM_DEFAULT)
//     `uvm_field_int(WDATA,UVM_DEFAULT)
//     `uvm_field_int(WSTRB,UVM_DEFAULT)
//     `uvm_field_int(WUSER,UVM_DEFAULT)

//     `uvm_field_int(BVALID,UVM_NOCOMPARE)
//     `uvm_field_int(BRESP,UVM_NOCOMPARE)
//     `uvm_field_int(BID,UVM_NOCOMPARE)
//     `uvm_field_int(BUSER,UVM_DEFAULT)
//     `uvm_field_int(BREADY,UVM_DEFAULT)
//     `uvm_field_int(BUSER,UVM_DEFAULT)

//     `uvm_field_int(ARVALID,UVM_NOCOMPARE)
//     `uvm_field_int(ARADDR,UVM_DEFAULT)
//     `uvm_field_int(ARSIZE,UVM_DEFAULT)
//     `uvm_field_int(ARBURST,UVM_DEFAULT)
//     `uvm_field_int(AWCACHE,UVM_DEFAULT)
//     `uvm_field_int(ARPROT,UVM_DEFAULT)
//     `uvm_field_int(ARID,UVM_DEFAULT)
//     `uvm_field_int(ARCACHE,UVM_DEFAULT)
//     `uvm_field_int(ARLEN,UVM_DEFAULT)
//     `uvm_field_int(ARLOCK,UVM_DEFAULT)
//     `uvm_field_int(ARQOS,UVM_DEFAULT)
//     `uvm_field_int(ARREGION,UVM_DEFAULT)
//     `uvm_field_int(ARUSER,UVM_DEFAULT)

//     `uvm_field_int(RVALID,UVM_NOCOMPARE)
//     `uvm_field_int(RLAST,UVM_NOCOMPARE)
//     `uvm_field_int(RDATA,UVM_NOCOMPARE)
//     `uvm_field_int(RRESP,UVM_NOCOMPARE)
//     `uvm_field_int(RID,UVM_NOCOMPARE)
//     `uvm_field_int(RUSER,UVM_NOCOMPARE)
//     `uvm_field_int(RREADY,UVM_NOCOMPARE)
// `uvm_object_utils_end

//    //  Group: Constraints
//    //todo come back and add some cant think of any right now

   

//    //  Constructor: new
//    function new(string name = "read_and_write_transction");
//        super.new(name);
//    endfunction: new

//    //  Group: Functions

//    // todo probably do not need
// //    function input_equal(transaction tx); // MAY HAVE TO CHANGE LATER 
// //        int result = 0;
// //        if(trans_t == READ) begin
// //             if((AWREADY == tx.AWREADY) && (WREADY == tx.WREADY) && 
// //             (BVALID == tx.BVALID) && (BRESP == tx.BRESP) && (BID == tx.BID)) result = 1;
// //        end

// //        else if(trans_t == WRITE) begin
// //             if((ARVALID == tx.ARVALID) && (RVALID == tx.RVALID) && 
// //             (RVALID == tx.RLAST) && (RDATA == tx.RDATA) &&
// //             (RRESP == tx.RRESP) && (RUSER = tx.RUSER)) result = 1;
// //        end

// //        else if(trans_t == READ_WRITE) begin
// //             if((AWREADY == tx.AWREADY) && (WREADY == tx.WREADY) && 
// //             (BVALID == tx.BVALID) && (BRESP == tx.BRESP) && (BID == tx.BID) &&
// //             (ARVALID == tx.ARVALID) && (RVALID == tx.RVALID) && 
// //             (RVALID == tx.RLAST) && (RDATA == tx.RDATA) &&
// //             (RRESP == tx.RRESP) && (RUSER = tx.RUSER)) result = 1;
// //        end
       
// //        return result;
//    endfunction
// endclass: 
























//////////////////////////////////////////// DEAD CODE //////////////////////////////////////////////////////////////////////////

// class write_transction #(parameter NUM_ID = NUM_ID, parameter NUM_USER = NUM_USER, parameter DATA_LEN = DATA_LEN) extends uvm_sequence_item;
//     // Group: Variables
//    /////////////// WRITE ADDR CHANNEL/////////////////
//    // INPUTS
//    rand bit AWREADY;
//    // OUTPUTS
//    bit AWVALID;
//    bit [31:0] AWADDR;
//    bit [2:0] AWSIZE;
//    bit [1:0] AWBURST;
//    bit [3:0] AWCACHE
//    bit [2:0] AWPROT
//    bit [NUM_ID - 1:0] AWID; // COME BACK MAY JUST ASSIGN AWID = NUM_ID SAME FOR USER
//    bit [7:0] AWLEN;
//    bit AWLOCK;
//    bit [3:0] AWQOS;
//    bit [3:0] AWREGION;
//    bit [NUM_USER- 1:0] AWUSER; // Todo look into size


//    /////////////// WRITE DATA CHANNEL/////////////////
//    // INPUTS
//    rand bit WREADY;
//    // OUTPUTS
//    bit WVALID;
//    bit WLAST;
//    bit [DATA_LEN- 1:0] WDATA;
//    bit [x:0] WSTRB; // Todo figure out len
//    bit [NUM_ID - 1: 0] WUSER; // Todo look into size

//    /////////////// WRITE RESPONSE CHANNEL/////////////////
//    // INPUTS
//    rand bit BVALID;
//    rand bit [1:0] BRESP;
//    bit BID; // MAYBE NOT
//    // OUTPUTS
//    bit BREADY;
//    bit BUSER; // Todo look into size

//    `uvm_object_utils_begin(write_transction)
//        `uvm_field_int(AWREADY,UVM_NOCOMPARE)
//        `uvm_field_int(AWADDR,UVM_DEFAULT)
//        `uvm_field_int(AWSIZE,UVM_DEFAULT)
//        `uvm_field_int(AWBURST,UVM_DEFAULT)
//        `uvm_field_int(AWCACHE,UVM_DEFAULT)
//        `uvm_field_int(AWPROT,UVM_DEFAULT)
//        `uvm_field_int(AWID,UVM_DEFAULT)
//        `uvm_field_int(AWLEN,UVM_DEFAULT)
//        `uvm_field_int(AWLOCK,UVM_DEFAULT)
//        `uvm_field_int(AWQOS,UVM_DEFAULT)
//        `uvm_field_int(AWREGION,UVM_DEFAULT)
//        `uvm_field_int(AWUSER,UVM_DEFAULT)

//        `uvm_field_int(WREADY,UVM_NOCOMPARE)
//        `uvm_field_int(WVALID,UVM_DEFAULT)
//        `uvm_field_int(WLAST,UVM_DEFAULT)
//        `uvm_field_int(WDATA,UVM_DEFAULT)
//        `uvm_field_int(WSTRB,UVM_DEFAULT)
//        `uvm_field_int(WUSER,UVM_DEFAULT)

//        `uvm_field_int(BVALID,UVM_NOCOMPARE)
//        `uvm_field_int(BRESP,UVM_NOCOMPARE)
//        `uvm_field_int(BID,UVM_NOCOMPARE)
//        `uvm_field_int(BUSER,UVM_DEFAULT)
//        `uvm_field_int(BREADY,UVM_DEFAULT)
//        `uvm_field_int(BUSER,UVM_DEFAULT)
//    `uvm_object_utils_end

//    //  Group: Constraints
//    //todo come back and add some cant think of any right now

   

//    //  Constructor: new
//    function new(string name = "write_transction");
//        super.new(name);
//    endfunction: new

//    //  Group: Functions

//    function input_equal(transaction tx);
//        int result = 0;
//        if((AWREADY == tx.AWREADY) && (WREADY == tx.WREADY) && 
//        (BVALID == tx.BVALID) && (BRESP == tx.BRESP) && (BID == tx.BID)) result = 1;
//        return result;
//    endfunction
// endclass: 


// class read_transction #(parameter NUM_ID = NUM_ID, parameter NUM_USER = NUM_USER, parameter DATA_LEN = DAT_LEN) extends uvm_sequence_item;
//    // Group: Variables
//   /////////////// READ ADDR CHANNEL/////////////////
//    // INPUTS
//    rand bit ARVALID;
//    // OUTPUTS
//    bit ARREADY;
//    bit [31:0] ARADDR;
//    bit [2:0] ARSIZE;
//    bit [1:0] ARBURST;
//    bit [3:0] ARCACHE;
//    bit [2:0] ARPROT;
//    bit [NUM_ID - 1:0] ARID;
//    bit [7:0] ARLEN;
//    bit ARLOCK;
//    bit [3:0] ARQOS;
//    bit [3:0] ARREGION;
//    bit [NUM_USER- 1:0] ARUSER; // Todo look into size

//    /////////////// READ DATA CHANNEL/////////////////
//    // INPUTS
//    rand bit RVALID;
//    rand bit RLAST;
//    rand bit [DATA_LEN- 1:0] RDATA;
//    rand bit [1:0] RRESP;
//    rand bit [NUM_ID - 1:0] RID;
//    rand bit [NUM_ID - 1: 0] RUSER; // Todo look into size
//    // OUTPUTS
//    bit RREADY;

//   `uvm_object_utils_begin(write_transction)
//       `uvm_field_int(ARVALID,UVM_NOCOMPARE)
//       `uvm_field_int(ARADDR,UVM_DEFAULT)
//       `uvm_field_int(ARSIZE,UVM_DEFAULT)
//       `uvm_field_int(ARBURST,UVM_DEFAULT)
//       `uvm_field_int(AWCACHE,UVM_DEFAULT)
//       `uvm_field_int(ARPROT,UVM_DEFAULT)
//       `uvm_field_int(ARID,UVM_DEFAULT)
//       `uvm_field_int(ARCACHE,UVM_DEFAULT)
//       `uvm_field_int(ARLEN,UVM_DEFAULT)
//       `uvm_field_int(ARLOCK,UVM_DEFAULT)
//       `uvm_field_int(ARQOS,UVM_DEFAULT)
//       `uvm_field_int(ARREGION,UVM_DEFAULT)
//       `uvm_field_int(ARUSER,UVM_DEFAULT)

//       `uvm_field_int(RVALID,UVM_NOCOMPARE)
//       `uvm_field_int(RLAST,UVM_NOCOMPARE)
//       `uvm_field_int(RDATA,UVM_NOCOMPARE)
//       `uvm_field_int(RRESP,UVM_NOCOMPARE)
//       `uvm_field_int(RID,UVM_NOCOMPARE)
//       `uvm_field_int(RUSER,UVM_NOCOMPARE)
//       `uvm_field_int(RREADY,UVM_NOCOMPARE)
//   `uvm_object_utils_end

//   //  Group: Constraints
//   //todo come back and add some cant think of any right now

  

//   //  Constructor: new
//   function new(string name = "read_transction");
//       super.new(name);
//   endfunction: new

//   //  Group: Functions

//   function input_equal(transaction tx);
//       int result = 0;
//       if((ARVALID == tx.ARVALID) && (RVALID == tx.RVALID) && 
//       (RVALID == tx.RLAST) && (RDATA == tx.RDATA) &&
//       (RRESP == tx.RRESP) && (RUSER = tx.RUSER)) result = 1;
//       return result;
//   endfunction
// endclass: 
