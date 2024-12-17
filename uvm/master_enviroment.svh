import uvm_pkg::*;
`include "uvm_macros.svh"
// TODO include score board and agent

class master_enviroment extends uvm_enviroment;
    `uvm_component_utils(master_enviroment)
    function new(string name, uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

    // TODO FILL SHOULD BE EASY
endclass //master_enviroment extends uvm_enviroment