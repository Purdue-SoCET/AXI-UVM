// master_params.vh

// Parameters for the shift register module
`ifndef MASTER_PARAMS_VH
`define MASTER_PARAMS_VH

// Default parameters for shift register
parameter NUM_ID = 0;
parameter NUM_USER = 1; 
parameter DAT_LEN = 1; // TODO may not need since payload object exists 
parameter FIXED = 0;
parameter INCR = 1;
parameter WRAP = 2;

typedef enum bit[1:0] {READ, WRITE, READ_WRITE} TYPE_TRANS;
typedef enum bit [1:0] {ADDRESS, DATA, RESPONSE} Channel; // May have to add (response need to see DUT)
`endif // MASTER_PARAMS_VH