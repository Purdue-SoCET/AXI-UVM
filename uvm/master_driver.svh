// PIPELINED DRIVER 
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "axi_master_if.vh" // interface added


class master_axi_pipeline_driver extends uvm_driver;
    `uvm_component_utils(master_axi_pipeline_driver)
    function new(string name, uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

endclass //master_axi_pipeline_driver extends uvm_driver