// PIPELINED DRIVER 
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "axi_master_if.vh" // interface added
`include "master_params.svh"

/* Key Issues 
1. Need to Figure out how I am going to verfiy responses - Pending
    a. Only thing I can think of is randomize the response and throw some more
    constraints in the transaction file and from there in the monitor just check 
    what my tranaction is saying the outcome is which is probably what I will end up doing

2. Right now I am forcing tranactions to go in a specific order {addr,data,resp} -Pending
    a. I am limted because for right now I cant really check out of order
    b. Right now I am also basically saying there is one master and one slave
    c. out of order seems like a pain I think the way I would do it is have a stack
       in the scoreboard and wait for ID's to match 

3. QOS,PROT, REGION, ID have still not been taken into account yet I need to figure this out
    a. I do not think QOS and Region I can do since there is no interconnect
    b. ID is for Out of Order (OoO) which I hope to get to in the future 

*/
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
    task set_write_addr(master_transaction axi_m); 
        vmif.AWVALID = 1'b1;
        vmif.AWADDR = axi_m.m_address;
        vmif.AWSIZE = axi_m.m_BURST_size;
        vmif.AWBURST = axi_m.m_BURST_type;
        vmif.AWCACHE = axi_m.m_CACHE; 
        vmif.AWPROT = 0; // TODO NEED TO NOT MAKE THIS 0
        vmif.AWID = 0; // TODO NEED TO NOT MAKE THIS 0
        vmif.AWLEN = axi_m.m_length;
        vmif.AWLOCK = axi_m.m_LOCK;
        vmif.AWQOS = 0; // TODO NEED TO NOT MAKE THIS 0
        vmif.AWREGION = 0; // TODO NEED TO NOT MAKE THIS 0
        vmif.AWUSER = 0; // TODO NEED TO NOT MAKE THIS 0
    endtask


    task set_write_data(master_transaction axi_m); 
        // TODO Figure out what to do with these signals
        vmif.WSTRB = 0;
        vmif.WUSER = 0;
        vmif.WLAST = 0;
        int idx = 0;

        repeat(axi_m.m_BURST_size) begin
            @(negedge vmif.ACLK);
            vmif.WVALID = 1; // set high at beginning
            while(!vmif.WREADY) begin
                @(posedge vmif.ACLK); // wait till valid go high
            end

            // NOTE can randomize when Valid goes high if need be 
            if(vmif.WREADY && vmif.WVALID) begin
                if(idx == axi_m.m_BURST_size - 1) begin
                    vmif.WLAST = 1;
                end
                vmif.WDATA[idx] = axi_m.m_data[idx];
                idx++;

                @(negedge vmif.ACLK);
                vmif.WVALID = 0; // set low
            end
        end
        #1; // pass some time
        if(vmif.WLAST = 1) vmif.WLAST = 0; // So I dont hold LAST high for too long
    endtask

    task recieve_read_data(master_transaction axi_m); // TODO come back need to think how to check read data somehow
        vmif.RREADY = 1; // set high at beginning
        int idx = 0; 
        repeat(axi_m.m_BURST_size) begin
            while(!vmif.RVALID) begin
                @(posedge vmif.ACLK); // wait till valid go high
            end
            if(vmif.RREADY && vmif.RVALID) begin
                
            end
        end
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
            
            // DATA CHANNEL Being Driven
            else if(axi_m.Channel == DATA) begin
                
                // Write Channel
                if(axi_m.m_command == UVM_TLM_WRITE_COMMAND) begin
                    set_write_data(axi_m); // Send data
                end
            end
        end

        seq_item_port.item_done(); // item finishes 
    endtask

endclass //master_axi_pipeline_driver extends uvm_driver