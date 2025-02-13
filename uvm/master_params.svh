// master_params.vh

// Parameters for the shift register module
`ifndef MASTER_PARAMS_VH
`define MASTER_PARAMS_VH

// Default parameters for shift register
parameter NUM_ID = 0;
parameter NUM_USER = 1; 
parameter DAT_LEN = 32; // TODO may not need since payload object exists 

// typedef enum bit[1:0] {READ, WRITE, READ_WRITE} TYPE_TRANS; // OLD I have a read and write in here for now
typedef enum bit {READ, WRITE} TYPE_TRANS; // 
typedef enum bit[1:0] {FIXED, INCR, WRAP} TYPE_BURST;
typedef enum bit [2:0] {ADDRESS, DATA, RESPONSE, RDONE,WDONE} TYPE_CHANNEL; // May have to add (response need to see DUT)
typedef enum bit [1:0] {OKAY, EXOKAY, SLVERR,DECERR} TYPE_RESP; 

`endif // MASTER_PARAMS_VH