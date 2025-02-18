`include "uvm_macros.svh"
import uvm_pkg::*;

`include "master_enviroment.svh"
`include "Sequences/master_rst_sequence.svh"
`include "axi_master_if.svh"
`include "phony_master_driver.svh"
`include "phony_master_monitor.svh"

class master_test extends uvm_test;

    parameter PERIOD = 100;
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

        m_env = master_enviroment::type_id::create("m_env",this);
        rst_seq = rst_sequence::type_id::create("rst_seq"); 
        garb_seq = garbage_sequence::type_id::create("garb_seq");   
    
         // overiding driver to phoney driver for rst case
        set_type_override_by_type(master_axi_pipeline_driver::get_type(),phony_master_driver::get_type());

        
         // overiding monitor to phoney monitor for rst case
        set_type_override_by_type(master_monitor::get_type(),phony_master_monitor::get_type());

        
        // passing interface down
        if(!uvm_config_db#(virtual axi_master_if)::get(this,"*","axi_master_if",vmif)) begin
            // check if interface is correctly set in testbench top level
            `uvm_fatal("TEST", "No virtual interface specified for this test instance")
        end

        uvm_config_db#(virtual axi_master_if)::set(this,"env.agt*", "axi_master_if",vmif); 
    endfunction

    task run_phase(uvm_phase phase);


        phase.raise_objection(this, "Starting sequences");

        // if (!uvm_hdl_force("axi_master_duv_tb.axi_duv_master.awready_i", 1'b1))
		// 	`uvm_error ("TEST", $sformatf ("axi_master_duv_tb.axi_duv_master.awready_i"))
       
        // if (!uvm_hdl_force("axi_master_duv_tb.axi_duv_master.arready_i", 1'b1))
		// 	`uvm_error ("TEST", $sformatf ("axi_master_duv_tb.axi_duv_master.arready_i"))
       
        // if (!uvm_hdl_force("axi_master_duv_tb.axi_duv_master.wready_i", 1'b1))
		// 	`uvm_error ("TEST", $sformatf ("axi_master_duv_tb.axi_duv_master.wready_i"))
       
        // TC 1 Reset
        
        // garb_seq.start(m_env.m_agt.m_sqr); // send garbage sequence
        // rst_seq.start(m_env.m_agt.m_sqr); // send reset sequence
        repeat(100) begin
            repeat(8) begin
                garb_seq.start(m_env.m_agt.m_sqr); // send garbage sequence
            end
            // #(100ns);
            // rst_seq.print(); // print values 
            rst_seq.start(m_env.m_agt.m_sqr); // send reset sequence
        end
        #(100ns);

        // TC 2
        phase.drop_objection(this, "Finished sequences");

    endtask

endclass