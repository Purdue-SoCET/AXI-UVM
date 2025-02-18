// MASTER RST SEQUENCE

// --- UVM --- //
`include "uvm_macros.svh"
import uvm_pkg::*;

// --- Params/other includes --- //
`include "../master_params.svh"
`include "../master_seqit.svh"

//  Class: rst_sequence

class rst_sequence extends uvm_sequence;
    `uvm_object_utils(rst_sequence)
  
    master_seqit reset_seqit;

    //  Constructor: new
    function new(string name = "rst_sequence");
        super.new(name);
    endfunction: new

    task body;
        `uvm_info("RESET_SEQ", "Inside body task", UVM_HIGH)

        // --- Randomize With Reset --- //
        reset_seqit = master_seqit#(DATA_WIDTH)::type_id::create("reset_seqit");
        start_item(reset_seqit);
        reset_seqit.randomize() with {
            nRST == 0;
            // BURST_length == 0;
            // BURST_type == 0;
            // BURST_size == 0;
            // Channel == ADDRESS;
            // command == WRITE;
        };
        // reset_seqit.update_state(); // updates state
        finish_item(reset_seqit);
    endtask : body 
endclass: rst_sequence



//  Class: garbage_sequence

class garbage_sequence extends uvm_sequence;
    `uvm_object_utils(garbage_sequence)
  
    master_seqit garbage_seqit;

    //  Constructor: new
    function new(string name = "garbage_sequence");
        super.new(name);
    endfunction: new

    task body;
        `uvm_info("GARBAGE_SEQ", "Inside body task", UVM_HIGH)

        // --- Randomize With Reset --- //
        // TODO Channel DATA NOT BEING DRIVEN CORRECT LOOK INTO
        garbage_seqit = master_seqit#(DATA_WIDTH)::type_id::create("garbage_seqit");
        start_item(garbage_seqit);
        garbage_seqit.randomize() with {
            nRST == 1;
            // BURST_length == 0;
            // BURST_type == 0;
            // BURST_size == 0;
            // Channel == ADDRESS;
            // command == WRITE;
        };
        // garbage_seqit.update_state(); // updates state
        finish_item(garbage_seqit);
    endtask : body 

endclass: garbage_sequence