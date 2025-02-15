`include "uvm_macros.svh"
import uvm_pkg::*;

`include "master_enviroment.svh"
`include "Sequences/master_rst_sequence.svh"
`include "axi_master_if.svh"

class master_test extends uvm_test;
    `uvm_component_utils(master_test)

    master_enviroment m_env;
    rst_sequence rst_seq;
    garbage_sequence garb_seq;
    virtual axi_master_if vmif;

    function new(string name = "master_test", uvm_component parent);
        super.new(name,parent);
    endfunction:new
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_env = master_enviroment::type_id::create("m_env");
        rst_seq = rst_sequence::type_id::create("rst_seq");
        garb_seq = garbage_sequence::type_id::create("garb_seq");

        // passing interface down
        if(!uvm_config_db#(virtual axi_master_if)::get(this,"*","vmif",vmif)) begin
            // check if interface is correctly set in testbench top level
            `uvm_fatal("TEST", "No virtual interface specified for this test instance")
        end

    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this, "Starting sequence");

        // TC 1 Reset
        repeat(1) begin
            garb_seq.start(m_env.m_agt.m_sqr); // send garbage sequence
            rst_seq.start(m_env.m_agt.m_sqr); // send reset sequence
        end
       
        // TC 2

        phase.drop_objection(this, "Finished sequence");

    endtask

endclass