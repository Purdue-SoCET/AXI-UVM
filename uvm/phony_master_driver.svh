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
        vmif.AWREADY <= '0;
        vmif.WREADY <= '0;
        vmif.BVALID <= 0;
        vmif.BRESP <= '0;
        vmif.BID <= '1;
        vmif.BUSER <= '1;
        vmif.RREADY <= 1; 
        vmif.RDATA <= '1;
        vmif.RRESP <= '1;
        vmif.RID <= '1;
        vmif.RUSER <= '1;
        vmif.RVALID <= 0;//
        vmif.RLAST <= 0; //
        vmif.local_awid <= '1;
        vmif.local_awaddr <= '1;
        vmif.local_awlen <= '1;
        vmif.local_awsize <= '1;
        vmif.local_awburst <= '1;
        vmif.local_awlock <= '1;
        vmif.local_wdata <= '1;
        vmif.local_wstrb <= '1;
        vmif.local_wlast <= '1;
        vmif.local_awvalid_i <= 0;
// TODO may need to force some signals here
        // Master SIDE
        vmif.local_araddr <= axi_m.address;
        vmif.local_arlock <= axi_m.LOCK;
        vmif.local_arsize <= axi_m.BURST_size;
        vmif.local_arburst <= axi_m.BURST_type;
        vmif.local_arid <= 0;
        vmif.local_arlen <= axi_m.BURST_length;
        vmif.ARREADY <= 1; // setting slave to be ready 
        
        // wait then set ready to low
        @(vmif.m_drv_cb); // progress time
        vmif.ARREADY <= 0; // setting slave to be ready;
        // @(vmif.m_drv_cb); // progress time
    endtask

    // PICK UP HERE
    task set_write_addr(master_seqit axi_m);
        vmif.WREADY <='0;
        vmif.BVALID <= 0;
        vmif.BRESP <= '0;
        vmif.BID <= '1;
        vmif.BUSER <= '1;
        vmif.ARREADY <= 1;  
        vmif.RREADY <= 1; 
        vmif.RDATA <= '1;
        vmif.RRESP <= '1;
        vmif.RID <= '1;
        vmif.RUSER <= '1;
        vmif.RVALID <= 0;//
        vmif.RLAST <= 0; //
        vmif.local_wdata <= '1;
        vmif.local_wstrb <= '1;
        vmif.local_wlast <= '1;
        vmif.local_awvalid_i <= 0;
        vmif.local_arid <= '1;
        vmif.local_araddr <= '1;
        vmif.local_arlen <= '1;
        vmif.local_arsize <= '1;
        vmif.local_arburst <= '1;
        vmif.local_arlock <= '1;
         // TODO may need to force some signals here
        vmif.local_awaddr <= axi_m.address;
        vmif.local_awlock <= axi_m.LOCK;
        vmif.local_awsize <= axi_m.BURST_size;
        vmif.local_awburst <= axi_m.BURST_type;
        vmif.local_awid <= 0;
        vmif.local_awlen <= axi_m.BURST_length;
        vmif.local_awvalid_i <= 1;
        vmif.AWREADY <= 1; // setting slave to be ready;
        // @(vmif.m_drv_cb); // progress time
        @(vmif.m_drv_cb); // progress time
        vmif.AWREADY <= 0;
        vmif.local_awvalid_i <= 0; // TODO CHANGE BACK TO INTERNAL INPUT
        // @(vmif.m_drv_cb); // progress time
    endtask


    task set_write_data(master_seqit axi_m); 
        vmif.AWREADY <= '0;
        vmif.BVALID <= 0;
        vmif.BRESP <= '0;
        vmif.BID <= '1;
        vmif.BUSER <= '1;
        vmif.ARREADY <= 1;  
        vmif.RREADY <= 1; 
        vmif.RDATA <= '1;
        vmif.RRESP <= '1;
        vmif.RID <= '1;
        vmif.RUSER <= '1;
        vmif.RVALID <= 0;//
        vmif.RLAST <= 0; //
        vmif.local_awid <= '1;
        vmif.local_awaddr <= '1;
        vmif.local_awlen <= '1;
        vmif.local_awsize <= '1;
        vmif.local_awburst <= '1;
        vmif.local_awlock <= '1;
        vmif.local_awvalid_i <= 0;
        vmif.local_arid <= '1;
        vmif.local_araddr <= '1;
        vmif.local_arlen <= '1;
        vmif.local_arsize <= '1;
        vmif.local_arburst <= '1;
        vmif.local_arlock <= '1;
         // TODO may need to force some signals here
        vmif.WREADY <= '1;
        vmif.local_wlast <= 1;
        vmif.local_wstrb <= 0;
        vmif.local_wdata <= axi_m.data;
        @(vmif.m_drv_cb); // progress time
        vmif.WREADY <= '0;
        // @(vmif.m_drv_cb); // progress time
    endtask

    
    task set_read_data_resp (master_seqit axi_m);
        vmif.AWREADY <= '0;
        vmif.WREADY <= '0;
        vmif.BVALID <= 0;
        vmif.BRESP <= '0;
        vmif.BID <= '1;
        vmif.BUSER <= '1;
        vmif.ARREADY <= 1;  
        vmif.local_awid <= '1;
        vmif.local_awaddr <= '1;
        vmif.local_awlen <= '1;
        vmif.local_awsize <= '1;
        vmif.local_awburst <= '1;
        vmif.local_awlock <= '1;
        vmif.local_wdata <= '1;
        vmif.local_wstrb <= '1;
        vmif.local_wlast <= '1;
        vmif.local_awvalid_i <= 0;
        vmif.local_arid <= '1;
        vmif.local_araddr <= '1;
        vmif.local_arlen <= '1;
        vmif.local_arsize <= '1;
        vmif.local_arburst <= '1;
        vmif.local_arlock <= '1;
         // TODO may need to force some signals here
        vmif.RID <= 0;
        vmif.RDATA <= axi_m.data;
        vmif.RRESP <= axi_m.resp;
        vmif.RLAST <= 1; 
        vmif.RVALID <= 1;
        vmif.RUSER <= axi_m.user;
        @(vmif.m_drv_cb); // progress time
        vmif.RLAST <= 0; 
        vmif.RVALID <= 0;
        // @(vmif.m_drv_cb); // progress time
    endtask

    task set_write_reponse (master_seqit axi_m);
        vmif.AWREADY <= '0;
        vmif.WREADY <= '0;
        vmif.ARREADY <= 1;  
        vmif.RREADY <= 1; 
        vmif.RDATA <= '1;
        vmif.RRESP <= '1;
        vmif.RID <= '1;
        vmif.RUSER <= '1;
        vmif.RVALID <= 0;//
        vmif.RLAST <= 0; //
        vmif.local_awid <= '1;
        vmif.local_awaddr <= '1;
        vmif.local_awlen <= '1;
        vmif.local_awsize <= '1;
        vmif.local_awburst <= '1;
        vmif.local_awlock <= '1;
        vmif.local_wdata <= '1;
        vmif.local_wstrb <= '1;
        vmif.local_wlast <= '1;
        vmif.local_awvalid_i <= 0;
        vmif.local_arid <= '1;
        vmif.local_araddr <= '1;
        vmif.local_arlen <= '1;
        vmif.local_arsize <= '1;
        vmif.local_arburst <= '1;
        vmif.local_arlock <= '1;

        vmif.BID <= 0;
        vmif.BRESP <= axi_m.resp;
        vmif.BVALID <= 1;
        vmif.BUSER <= axi_m.user;

        @(vmif.m_drv_cb); // progress time
        vmif.BVALID <= 0;
        // @(vmif.m_drv_cb); // progress time
    endtask
    

    task intial_inputs();
        vmif.AWREADY <= '0;
        vmif.WREADY <= '0;
        vmif.BVALID <= 0;
        vmif.BRESP <= '0;
        vmif.BID <= '1;
        vmif.BUSER <= '1;
        vmif.ARREADY <= 1;  
        vmif.RREADY <= 1; 
        vmif.RDATA <= '1;
        vmif.RRESP <= '1;
        vmif.RID <= '1;
        vmif.RUSER <= '1;
        vmif.RVALID <= 0;//
        vmif.RLAST <= 0; //
        vmif.local_awid <= '1;
        vmif.local_awaddr <= '1;
        vmif.local_awlen <= '1;
        vmif.local_awsize <= '1;
        vmif.local_awburst <= '1;
        vmif.local_awlock <= '1;
        vmif.local_wdata <= '1;
        vmif.local_wstrb <= '1;
        vmif.local_wlast <= '1;
        vmif.local_awvalid_i <= 0;
        vmif.local_arid <= '1;
        vmif.local_araddr <= '1;
        vmif.local_arlen <= '1;
        vmif.local_arsize <= '1;
        vmif.local_arburst <= '1;
        vmif.local_arlock <= '1;
        // @(vmif.m_drv_cb); // progress time
    endtask

        task run_phase(uvm_phase phase);
            `uvm_info("DRIVER CLASS", "Run Phase", UVM_HIGH)
            // dut_rst();
            // intial_inputs();
            forever begin
                pkt = master_seqit#(DATA_WIDTH)::type_id::create("pkt");

                seq_item_port.get_next_item(pkt);
                // intial_inputs(pkt); // intialize inputs
                
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
                seq_item_port.item_done(); // item finishes 
            end
    endtask

    task dut_rst();
        vmif.nRST = 0;
        @(vmif.m_drv_cb); // TODO may not need will see
        // @(vmif.m_drv_cb); // TODO may not need will see
        vmif.nRST = 1;
        @(vmif.m_drv_cb); // TODO may not need will see
    endtask //

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

