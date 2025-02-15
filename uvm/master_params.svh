// master_params.vh

// Parameters for the shift register module
`ifndef MASTER_PARAMS_VH
`define MASTER_PARAMS_VH

// Default parameters for shift register
parameter NUM_ID = 0;
parameter NUM_USER = 1; 

parameter ADDR_WIDTH = 32;  // Address bus width
parameter DATA_WIDTH = 32;  // Data bus width
parameter ID_WIDTH   = 4;   // ID supported = 2^ID_WIDTH
parameter LEN_WIDTH  = 8;   // Numbers of bits for capturing ARLEN/AWLEN
parameter AWUSER_WIDTH            = 32; // Size of AWUser field
parameter WUSER_WIDTH             = 32; // Size of WUser field
parameter BUSER_WIDTH             = 32; // Size of BUser field
parameter ARUSER_WIDTH            = 32; // Size of ARUser field
parameter RUSER_WIDTH             = 32; // Size of RUser field
parameter QOS_WIDTH               = 4;  // Size of QOS field
parameter REGION_WIDTH            = 4;  // Size of Region field

parameter MAX_OUTSTANDING_RD_REQ  = 4;  // Maximum pending read request before read 
parameter MAX_OUTSTANDING_WR_REQ  = 4;  // Maximum pending write request before write 
parameter MAX_OUTSTANDING_WR_RESP = 4;  // Maximum write response (BRESP) pending after
parameter MAX_WAIT_CYCLES         = 16; // Maximum number of cycles before READY goes 
parameter INTERLEAVE_ON        = 1;    // Maximum IDs supported for interleaving
parameter STRB_WIDTH = DATA_WIDTH/8;

//const for number of bits
parameter bit_1   = 1;
parameter bit_2   = 2;
parameter bit_4   = 4;
parameter bit_8   = 8;
parameter bit_16  = 16;
parameter bit_32  = 32;
parameter bit_64  = 64;
parameter bit_128 = 128;


// typedef enum bit[1:0] {READ, WRITE, READ_WRITE} TYPE_TRANS; // OLD I have a read and write in here for now
typedef enum bit {READ, WRITE} TYPE_TRANS; // 
typedef enum bit[1:0] {FIXED, INCR, WRAP} TYPE_BURST;
typedef enum bit [2:0] {ADDRESS, DATA, RESPONSE, RDONE,WDONE} TYPE_CHANNEL; // May have to add (response need to see DUT)
typedef enum bit [1:0] {OKAY, EXOKAY, SLVERR,DECERR} TYPE_RESP; 

`endif // MASTER_PARAMS_VH