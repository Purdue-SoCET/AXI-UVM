`include "uvm_macros.svh"
import uvm_pkg::*;

`include "axi_master_if.svh" // interface added
`include "master_seqit.svh"
// `include "master_driver.svh"


class phony_master_driver extends master_axi_pipeline_driver;
    `uvm_component_utils(phony_master_driver)
    virtual axi_master_if vmif;

    master_seqit pkt;

    function new(string name = "phony_master_driver", uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual axi_master_if)::get(this,"","axi_master_if", vmif)) begin
            `uvm_fatal("MASTER Driver", "No virtual interface specified for this test instance");
        end
    endfunction : build_phase

    task set_read_addr(master_seqit axi_m); 
// TODO may need to force some signals here
        // Master SIDE
        vmif.local_araddr <= axi_m.address;
        vmif.local_arlock <= axi_m.LOCK;
        vmif.local_arsize <= axi_m.BURST_size;
        vmif.local_arburst <= axi_m.BURST_type;
        vmif.local_arid <= 0;
        vmif.local_arlen <= axi_m.BURST_length;
    endtask

    // PICK UP HERE
    task set_write_addr(master_seqit axi_m); 
         // TODO may need to force some signals here
        vmif.local_awaddr <= axi_m.address;
        vmif.local_awlock <= axi_m.LOCK;
        vmif.local_awsize <= axi_m.BURST_size;
        vmif.local_awburst <= axi_m.BURST_type;
        vmif.local_awid <= 0;
        vmif.local_awlen <= axi_m.BURST_length;
    endtask


    task set_write_data(master_seqit axi_m); 
         // TODO may need to force some signals here
        vmif.local_wlast <= 0;
        vmif.local_wstrb <= 0;
        vmif.local_wdata <= axi_m.data[0];
    endtask

    
    task set_read_data_resp (master_seqit axi_m);
         // TODO may need to force some signals here
        vmif.RID <= 0;
        vmif.RDATA <= axi_m.data[0];
        vmif.RRESP <= axi_m.resp;
        vmif.RLAST <= 1; 
        vmif.RVALID <= 1;
        vmif.RUSER <= 0;
    endtask

    task set_write_reponse (master_seqit axi_m);
        vmif.BID <= 0;
        vmif.BRESP <= axi_m.resp;
        vmif.BVALID <= 1;
        vmif.BUSER <= 0;
    endtask
    

        task run_phase(uvm_phase phase);
            `uvm_info("DRIVER CLASS", "Run Phase", UVM_HIGH)
            
            forever begin
                
                pkt = master_seqit#(DATA_WIDTH)::type_id::create("pkt");

                seq_item_port.get_next_item(pkt);
                
                @(vmif.m_drv_cb); // TODO may not need will see
                vmif.nRST = pkt.nRST;
                // READ COMMAND
                if(pkt.command == READ) begin
                    if(pkt.Channel == ADDRESS) begin
                        set_read_addr(pkt);
                    end
                    else if (pkt.Channel == DATA || pkt.Channel == RESPONSE) begin
                        set_read_data_resp(pkt);
                    end
                end

                // WRITE COMMAND
                if(pkt.command == WRITE) begin
                    if(pkt.Channel == ADDRESS) begin
                        set_write_addr(pkt);
                    end
                    else if (pkt.Channel == DATA) begin
                        set_write_data(pkt);
                    end

                    else if (pkt.Channel == RESPONSE) begin
                        set_write_reponse(pkt);
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