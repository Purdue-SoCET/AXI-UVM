import uvm_pkg::*;
`include "uvm_macros.svh"
`include "master_driver.svh"
`include "master_monitor.svh"
`include "master_sequence.svh"


class master_agent extends uvm_agent;
    `uvm_component_utils(master_agent)
    function new(string name, uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

    // TODO FILL SHOULD BE EASY
endclass //master_agent extends uvm_agent