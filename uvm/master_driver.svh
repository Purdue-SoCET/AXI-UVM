// PIPELINED DRIVER 
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "axi_master_if.vh" // interface added
`include "master_params.svh"



class master_axi_pipeline_driver extends uvm_driver;
    `uvm_component_utils(master_axi_pipeline_driver)
    virtual axi_master_if.m_drv_cb vmif;

    function new(string name, uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual axi_master_if)::get(this,"","axi_master_if", vmif)) begin
            `uvm_fatal("MASTER Driver", "No virtual interface specified for this test instance");
        end
    endfunction : build_phase

    task set_read_addr(master_transaction axi_m); 
        vmif.ARVALID = 1'b1;
        vmif.ARSIZE = axi_m.m_BURST_size;
        vmif.ARBURST = axi_m.m_BURST_type;
        vmif.ARCACHE = axi_m.m_CACHE;
        vmif.ARPROT = 0; // TODO Need to not make this 0
        vmif.ARID = 0; // TODO NEED TO NOT MAKE THIS 0
        vmif.ARLEN = axi_m.m_length;
        vmif.ARLOCK = axi_m.m_LOCK;
        vmif.ARQOS = 0; // TODO NEED TO NOT MAKE THIS 0
        vmif.ARREGION = 0; // TODO NEED TO NOT MAKE THIS 0
        vmif.ARUSER = 0; // TODO NEED TO NOT MAKE THIS 0
    endtask

    // PICK UP HERE
    task set_write_addr(); 
        vmif.AWVALID =
        vmif.AWADDR 
        vmif.AWSIZE
        vmif.AWBURST
        vmif.AWCACHE 
        vmif.AWPROT
        vmif.AWID
        vmif.AWLEN
        vmif.AWLOCK
        vmif.AWQOS
        vmif.AWREGION
        vmif.AWUSER
    endtask


    task set_write_data(); 
        vmif.WVALID
        vmif.WLAST
        vmif.WDATA
        vmif.WSTRB
        vmif.WUSER
    endtask
    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(axi_m);

            // ADDRESS CHANNEL Being Driven
            if(axi_m.Channel == ADDRESS) begin
                // READ Address Channel
                if(axi_m.m_command == UVM_TLM_READ_COMMAND) begin
                    vmif.ARVALID = 1'b1;
                    while(!vmif.ARREADY) begin
                        @(posedge vmif.ACLK); // Pass time until slave is ready 
                    end 
                    if(vmif.ARVALID && vmif.ARREADY) begin
                        set_read_addr(axi_m); // sets interface
                    end
                end

                // Write Address Channel
                else if(axi_m.m_command == UVM_TLM_WRITE_COMMAND) begin
                    vmif.AWVALID = 1'b1;
                    while(!vmif.AWREADY) begin
                        @(posedge vmif.ACLK); // Pass time until slave is ready 
                    end 
                    if(vmif.AWVALID && vmif.AWREADY) begin
                        set_write_addr(axi_m); // sets interface
                    end
                end
            end 
        end


    endtask

endclass //master_axi_pipeline_driver extends uvm_driver