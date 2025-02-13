// MASTER RST SEQUENCE

// --- UVM --- //
`include "uvm_macros.svh"
import uvm_pkg::*;
// --- Packages --- //
`include "master_params.svh"

//  Class: rst_sequence

class rst_sequence extends uvm_sequence;
    `uvm_object_utils(rst_sequence)
  
    master_transaction reset_seqit;

    //  Constructor: new
    function new(string name = "rst_sequence");
        super.new(name);
    endfunction: new

    task body
        `uvm_info("RESET_SEQ", "Inside body task", UVM_HIGH)

        // --- Randomize With Reset --- //
        reset_seqit = master_transactions::type_id::create("reset_seqit");
        start_item(reset_seqit);
        reset_seqit.randomize() with {nRST == 0;};
        finish_item(reset_seqit);
    endtask : body 
endclass: rst_sequence



//  Class: garbage_sequence

class garbage_sequence extends uvm_sequence;
    `uvm_object_utils(rst_sequence)
  
    master_transaction garbage_seqit;

    //  Constructor: new
    function new(string name = "garbage_sequence");
        super.new(name);
    endfunction: new

    task body
        `uvm_info("GARBAGE_SEQ", "Inside body task", UVM_HIGH)

        // --- Randomize With Reset --- //
        garbage_seqit = master_transactions::type_id::create("garbage_seqit");
        start_item(rgarbage_seqit);
        garbage_seqit.randomize() with {nRST == 1;};
        finish_item(garbage_seqit);
    endtask : body 

endclass: rst_sequence