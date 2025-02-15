// Generic sequencer
class master_sequencer extends uvm_sequencer #(master_seqit);
    `uvm_component_utils(master_sequencer) // regstering with factory 

    function new(input string name = "master_sequencer", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new
endclass 