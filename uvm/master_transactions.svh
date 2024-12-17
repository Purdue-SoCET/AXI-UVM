`ifndef MASTER_TRANSACTIONS
`define MASTER_TRANSACTIONS
import uvm_pkg::*;
`include "uvm_macros.svh"
typedef enum bit[1:0] {READ, WRITE, READ_WRITE} TYPE_TRANS



class master_transaction #(parameter NUM_ID = NUM_ID, parameter NUM_USER = NUM_USER, parameter DATA_LEN = DAT_LEN) extends uvm_sequence_item;
    // Group: Variables

    rand TYPE_TRANS trans_t;
    /////////////// WRITE ADDR CHANNEL/////////////////
    // INPUTS
    rand bit AWREADY;
    // OUTPUTS
    bit AWVALID;
    bit [31:0] AWADDR;
    bit [2:0] AWSIZE;
    bit [1:0] AWBURST;
    bit [3:0] AWCACHE
    bit [2:0] AWPROT
    bit [NUM_ID - 1:0] AWID;
    bit [7:0] AWLEN;
    bit AWLOCK;
    bit [3:0] AWQOS;
    bit [3:0] AWREGION;
    bit [NUM_USER- 1:0] AWUSER; // Todo look into size


    /////////////// WRITE DATA CHANNEL/////////////////
    // INPUTS
    rand bit WREADY;
    // OUTPUTS
    bit WVALID;
    bit WLAST;
    bit [DATA_LEN- 1:0] WDATA;
    bit [x:0] WSTRB; // Todo figure out len
    bit [NUM_ID - 1: 0] WUSER; // Todo look into size

    /////////////// WRITE RESPONSE CHANNEL/////////////////
    // INPUTS
    rand bit BVALID;
    rand bit [1:0] BRESP;
    bit BID; // MAYBE NOT
    // OUTPUTS
    bit BREADY;
    bit BUSER; // Todo look into size

   /////////////// READ ADDR CHANNEL/////////////////
    // INPUTS
    rand bit ARVALID;
    // OUTPUTS
    bit ARREADY;
    bit [31:0] ARADDR;
    bit [2:0] ARSIZE;
    bit [1:0] ARBURST;
    bit [3:0] ARCACHE;
    bit [2:0] ARPROT;
    bit [NUM_ID - 1:0] ARID;
    bit [7:0] ARLEN;
    bit ARLOCK;
    bit [3:0] ARQOS;
    bit [3:0] ARREGION;
    bit [NUM_USER- 1:0] ARUSER; // Todo look into size

    /////////////// READ DATA CHANNEL/////////////////
    // INPUTS
    rand bit RVALID;
    rand bit RLAST;
    rand bit [DATA_LEN- 1:0] RDATA;
    rand bit [1:0] RRESP;
    rand bit [NUM_ID - 1:0] RID;
    rand bit [NUM_ID - 1: 0] RUSER; // Todo look into size
    // OUTPUTS
    bit RREADY;

`uvm_object_utils_begin(write_transction)
    `uvm_field_int(trans_t,UVM_NOCOMPARE)
    `uvm_field_int(AWREADY,UVM_NOCOMPARE)
    `uvm_field_int(AWADDR,UVM_DEFAULT)
    `uvm_field_int(AWSIZE,UVM_DEFAULT)
    `uvm_field_int(AWBURST,UVM_DEFAULT)
    `uvm_field_int(AWCACHE,UVM_DEFAULT)
    `uvm_field_int(AWPROT,UVM_DEFAULT)
    `uvm_field_int(AWID,UVM_DEFAULT)
    `uvm_field_int(AWLEN,UVM_DEFAULT)
    `uvm_field_int(AWLOCK,UVM_DEFAULT)
    `uvm_field_int(AWQOS,UVM_DEFAULT)
    `uvm_field_int(AWREGION,UVM_DEFAULT)
    `uvm_field_int(AWUSER,UVM_DEFAULT)

    `uvm_field_int(WREADY,UVM_NOCOMPARE)
    `uvm_field_int(WVALID,UVM_DEFAULT)
    `uvm_field_int(WLAST,UVM_DEFAULT)
    `uvm_field_int(WDATA,UVM_DEFAULT)
    `uvm_field_int(WSTRB,UVM_DEFAULT)
    `uvm_field_int(WUSER,UVM_DEFAULT)

    `uvm_field_int(BVALID,UVM_NOCOMPARE)
    `uvm_field_int(BRESP,UVM_NOCOMPARE)
    `uvm_field_int(BID,UVM_NOCOMPARE)
    `uvm_field_int(BUSER,UVM_DEFAULT)
    `uvm_field_int(BREADY,UVM_DEFAULT)
    `uvm_field_int(BUSER,UVM_DEFAULT)

    `uvm_field_int(ARVALID,UVM_NOCOMPARE)
    `uvm_field_int(ARADDR,UVM_DEFAULT)
    `uvm_field_int(ARSIZE,UVM_DEFAULT)
    `uvm_field_int(ARBURST,UVM_DEFAULT)
    `uvm_field_int(AWCACHE,UVM_DEFAULT)
    `uvm_field_int(ARPROT,UVM_DEFAULT)
    `uvm_field_int(ARID,UVM_DEFAULT)
    `uvm_field_int(ARCACHE,UVM_DEFAULT)
    `uvm_field_int(ARLEN,UVM_DEFAULT)
    `uvm_field_int(ARLOCK,UVM_DEFAULT)
    `uvm_field_int(ARQOS,UVM_DEFAULT)
    `uvm_field_int(ARREGION,UVM_DEFAULT)
    `uvm_field_int(ARUSER,UVM_DEFAULT)

    `uvm_field_int(RVALID,UVM_NOCOMPARE)
    `uvm_field_int(RLAST,UVM_NOCOMPARE)
    `uvm_field_int(RDATA,UVM_NOCOMPARE)
    `uvm_field_int(RRESP,UVM_NOCOMPARE)
    `uvm_field_int(RID,UVM_NOCOMPARE)
    `uvm_field_int(RUSER,UVM_NOCOMPARE)
    `uvm_field_int(RREADY,UVM_NOCOMPARE)
`uvm_object_utils_end

   //  Group: Constraints
   //todo come back and add some cant think of any right now

   

   //  Constructor: new
   function new(string name = "read_and_write_transction");
       super.new(name);
   endfunction: new

   //  Group: Functions

   function input_equal(transaction tx); // MAY HAVE TO CHANGE LATER 
       int result = 0;
       if(trans_t == READ) begin
            if((AWREADY == tx.AWREADY) && (WREADY == tx.WREADY) && 
            (BVALID == tx.BVALID) && (BRESP == tx.BRESP) && (BID == tx.BID)) result = 1;
       end

       else if(trans_t == WRITE) begin
            if((ARVALID == tx.ARVALID) && (RVALID == tx.RVALID) && 
            (RVALID == tx.RLAST) && (RDATA == tx.RDATA) &&
            (RRESP == tx.RRESP) && (RUSER = tx.RUSER)) result = 1;
       end

       else if(trans_t == READ_WRITE) begin
            if((AWREADY == tx.AWREADY) && (WREADY == tx.WREADY) && 
            (BVALID == tx.BVALID) && (BRESP == tx.BRESP) && (BID == tx.BID) &&
            (ARVALID == tx.ARVALID) && (RVALID == tx.RVALID) && 
            (RVALID == tx.RLAST) && (RDATA == tx.RDATA) &&
            (RRESP == tx.RRESP) && (RUSER = tx.RUSER)) result = 1;
       end
       
       return result;
   endfunction
endclass: 
























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
