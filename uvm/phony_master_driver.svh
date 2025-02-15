// Currently non Pipelined driver TODO PIPELINED DRIVER 
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "axi_master_if.svh" // interface added
`include "master_params.svh"
/*Driver for simple DUT not going to be like real one at all I think*/

class phony_master_driver extends uvm_driver;
    `uvm_component_utils(phony_master_driver)
    virtual axi_master_if.m_drv_cb vmif;

    function new(string name, uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual axi_master_if)::get(this,"","axi_master_if", vmif)) begin
            `uvm_fatal("MASTER Driver PHONY", "No virtual interface specified for this test instance");
        end
    endfunction : build_phase

    // task set_read_addr(master_seqit axi_m); 
    //     vmif.ARVALID <= 1'b1;
    //     vmif.ARREADY <= 1'b1; // should be correct but not actual DUT
    //     vmif.ARSIZE <= axi_m.BURST_size;
    //     vmif.ARBURST <= axi_m.BURST_type;
    //     vmif.ARCACHE <= axi_m.CACHE;
    //     vmif.ARPROT <= axi_m.PROT;
    //     vmif.ARID <= 0; // TODO NEED TO NOT MAKE THIS 0
    //     vmif.ARLEN <= axi_m.BURST_length;
    //     vmif.ARLOCK <= axi_m.LOCK;
    //     vmif.ARQOS <= 0; // TODO NEED TO NOT MAKE THIS 0
    //     vmif.ARREGION <= 0; // TODO NEED TO NOT MAKE THIS 0
    //     vmif.ARUSER <= 0; // TODO NEED TO NOT MAKE THIS 0
    // endtask

    // // PICK UP HERE
    // task set_write_addr(master_seqit axi_m); 
    //     vmif.AWVALID <= 1'b1;
    //     vmif.AWADDR <= axi_m.address;
    //     vmif.AWSIZE <= axi_m.BURST_size;
    //     vmif.AWBURST <= axi_m.BURST_type;
    //     vmif.AWCACHE <= axi_m.CACHE; 
    //     vmif.AWPROT <= 0; // TODO NEED TO NOT MAKE THIS 0
    //     vmif.AWID <= 0; // TODO NEED TO NOT MAKE THIS 0
    //     vmif.AWLEN <= axi_m.BURST_length;
    //     vmif.AWLOCK <= axi_m.LOCK;
    //     vmif.AWQOS <= 0; // TODO NEED TO NOT MAKE THIS 0
    //     vmif.AWREGION <= 0; // TODO NEED TO NOT MAKE THIS 0
    //     vmif.AWUSER <= 0; // TODO NEED TO NOT MAKE THIS 0
    // endtask


    // task set_write_data(master_seqit axi_m); 
    //     // TODO Figure out what to do with these signals
    //     vmif.WSTRB = 0;
    //     vmif.WUSER = 0;
    //     vmif.WLAST = 0;
    //     int idx = 0;

    //     repeat(axi_m.BURST_length) begin
    //         @(negedge vmif.ACLK);
    //         vmif.WVALID = 1; // set high at beginning
    //         while(!vmif.WREADY) begin
    //             @(posedge vmif.ACLK); // wait till valid go high
    //         end

    //         // NOTE can randomize when Valid goes high if need be 
    //         if(vmif.WREADY && vmif.WVALID) begin
    //             if(idx == axi_m.BURST_size - 1) begin
    //                 vmif.WLAST = 1;
    //             end
    //             vmif.WDATA[idx] = axi_m.data[idx];
    //             idx++;

    //             @(negedge vmif.ACLK);
    //             vmif.WVALID = 0; // set low
    //             if(vmif.WLAST = 1) vmif.WLAST = 0; // So I dont hold LAST high for too long
    //         end
    //     end
    // endtask

  

    task run_phase(uvm_phase phase);
        `uvm_info("PHONY DRIVER CLASS", "Run Phase", UVM_HIGH)
        forever begin
            seq_item_port.get_next_item(axi_m);

            // ADDRESS CHANNEL Being Driven
            // Write Address Channel
            if(axi_m.command == WRITE) begin
                vmif.AWVALID = 1'b1;
                while(!vmif.AWREADY) begin
                    @(posedge vmif.ACLK); // Pass time until slave is ready 
                end 
                if(vmif.AWVALID && vmif.AWREADY) begin
                    set_write_addr(axi_m); // sets interfacee
                end
            end
            
            // DATA CHANNEL Being Driven
            else if(axi_m.Channel == DATA) begin 
                // Write Channel
                if(axi_m.command == WRITE) begin
                    set_write_data(axi_m); // Send data
                end
            end
        end

        seq_item_port.item_done(); // item finishes 
    endtask

endclass //master_axi_pipeline_driver extends uvm_driver
