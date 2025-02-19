// Currently non Pipelined driver TODO PIPELINED DRIVER 
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "axi_master_if.svh" // interface added
`include "master_seqit.svh"

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
 
// TODO LOOOK INTO CLOCKING BLOCKS TODO

/* TODO
1. Need to make this a pipelined driver so it can send transactions without waiting for other
   transactions to complete
*/

class master_axi_pipeline_driver extends uvm_driver #(master_seqit);
    `uvm_component_utils(master_axi_pipeline_driver)
    virtual axi_master_if vmif;

    master_seqit pkt;

    function new(string name = "master_axi_pipeline_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual axi_master_if)::get(this,"","axi_master_if", vmif)) begin
            `uvm_fatal("MASTER Driver", "No virtual interface specified for this test instance");
        end
    endfunction : build_phase

    task set_read_addr(master_seqit axi_m); 
        vmif.ARVALID <= 1'b1;
        vmif.ARREADY <= 1'b1; // should be correct but not actual DUT
        vmif.ARSIZE <= axi_m.BURST_size;
        vmif.ARBURST <= axi_m.BURST_type;
        vmif.ARCACHE <= axi_m.CACHE;
        vmif.ARPROT <= axi_m.prot;
        vmif.ARID <= 0; // TODO NEED TO NOT MAKE THIS 0
        vmif.ARLEN <= axi_m.BURST_length;
        vmif.ARLOCK <= axi_m.LOCK;
        vmif.ARQOS <= 0; // TODO NEED TO NOT MAKE THIS 0
        vmif.ARREGION <= 0; // TODO NEED TO NOT MAKE THIS 0
        vmif.ARUSER <= 0; // TODO NEED TO NOT MAKE THIS 0
    endtask

    // PICK UP HERE
    task set_write_addr(master_seqit axi_m); 
        vmif.AWVALID <= 1'b1;
        vmif.AWADDR <= axi_m.address;
        vmif.AWSIZE <= axi_m.BURST_size;
        vmif.AWBURST <= axi_m.BURST_type;
        vmif.AWCACHE <= axi_m.CACHE; 
        vmif.AWPROT <= 0; // TODO NEED TO NOT MAKE THIS 0
        vmif.AWID <= 0; // TODO NEED TO NOT MAKE THIS 0
        vmif.AWLEN <= axi_m.BURST_length;
        vmif.AWLOCK <= axi_m.LOCK;
        vmif.AWQOS <= 0; // TODO NEED TO NOT MAKE THIS 0
        vmif.AWREGION <= 0; // TODO NEED TO NOT MAKE THIS 0
        vmif.AWUSER <= 0; // TODO NEED TO NOT MAKE THIS 0
    endtask


    task set_write_data(master_seqit axi_m); 
        // TODO Figure out what to do with these signals
        vmif.WSTRB <= 0;
        vmif.WUSER <= 0;
        vmif.WLAST <= 0;
        

        for (int idx = 0; idx < axi_m.BURST_length + 1; idx++) begin

            @(vmif.m_drv_cb);
            vmif.WVALID = 1; // set high at beginning
            while(!vmif.WREADY) begin
                @(vmif.m_drv_cb); // wait till valid go high
            end

            // NOTE can randomize when Valid goes high if need be 
            if(vmif.WREADY && vmif.WVALID) begin
                if(idx == axi_m.BURST_size) begin
                    vmif.WLAST = 1;
                end
                vmif.WDATA[idx] = axi_m.data[idx];
                idx++;

                @(vmif.m_drv_cb);
                vmif.WVALID = 0; // set low
                    if(vmif.WLAST == 1) vmif.WLAST = 0; // So I dont hold LAST high for too long
                end
            end
        
        endtask

    

        task run_phase(uvm_phase phase);
            `uvm_info("DRIVER CLASS", "Run Phase", UVM_LOW)
            
            forever begin
                pkt = master_seqit#(DATA_WIDTH)::type_id::create("pkt");

                seq_item_port.get_next_item(pkt);

                // ADDRESS CHANNEL Being Driven
                if(pkt.Channel == ADDRESS) begin
                    // READ Address Channel
                    if(pkt.command == READ) begin
                        vmif.ARVALID <= 1'b1;
                        while(!vmif.ARREADY) begin
                            @(vmif.m_drv_cb); // Pass time until slave is ready 
                        end 
                        if(vmif.ARVALID && vmif.ARREADY) begin
                            set_read_addr(pkt); // sets interfacee
                            seq_item_port.item_done(); // item finishes 
                        end
                    end

                    // Write Address Channel
                    else if(pkt.command == WRITE) begin
                        vmif.AWVALID <= 1'b1;
                        while(!vmif.AWREADY) begin
                            @(vmif.m_drv_cb); // Pass time until slave is ready 
                        end 
                        if(vmif.AWVALID && vmif.AWREADY) begin
                            set_write_addr(pkt); // sets interfacee
                            seq_item_port.item_done(); // item finishes 
                        end
                    end
                end
                
                // DATA CHANNEL Being Driven
                else if(pkt.Channel == DATA) begin 
                    // Write Channel
                    if(pkt.command == WRITE) begin
                        set_write_data(pkt); // Send data
                        seq_item_port.item_done(); // item finishes 
                    end
                end
            end

            seq_item_port.item_done(); // item finishes 
    endtask

endclass //master_axi_pipeline_driver extends uvm_driver






















  // TODO THINK IT WILL BE IN MONITOR 
    // task recieve_read_data(master_seqit axi_m); // TODO come back need to think how to check read data somehow
    //     vmif.RREADY = 1; // set high at beginning
    //     int idx = 0; 
    //     repeat(axi_m.BURST_size) begin
    //         while(!vmif.RVALID) begin
    //             @(posedge vmif.ACLK); // wait till valid go high
    //         end
    //         if(vmif.RREADY && vmif.RVALID) begin
                
    //         end
    //     end
    // endtask