import uvm_pkg::*;
`include "uvm_macros.svh"
`include "axi_master_if.svh" // interface added
`include "master_seqit.svh"

class master_monitor extends uvm_monitor;
    `uvm_component_utils(master_monitor)

    virtual axi_master_if vmif;

    // Commented out because I do not think I need this since I can not really predict
    // uvm_analysis_port#(master_seqit) axi_ap; // Result from DUT to Predictor

    uvm_analysis_port#(master_seqit) result_ap; // Result from DUT to COMP
    master_seqit item; // Previous transaction

    function new(string name, uvm_component parent = null);
        super.new(name,parent);
        result_ap = new("result_ap",this);
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); 
        // get interface from upper level
        if(!uvm_config_db#(virtual axi_master_if)::get(this,"","axi_master_if",vmif)) begin
            `uvm_fatal("Monitor", "No virtual interface specified for the monitor instance")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        `uvm_info("MONITOR CLASS", "Run Phase", UVM_HIGH)
        forever begin
            item = master_seqit#(DATA_WIDTH)::type_id::create("item");

            item.nRST = vmif.nRST;
            @(vmif.m_drv_cb);

            // if Read addr
            if(vmif.ARVALID & vmif.ARREADY) begin              
                // inputs (TECHNICALLY OUTS ALSO NEED TO LOOK INTO)
                item.address <= vmif.ARADDR;
                item.command <= READ;
                item.data <= '0; // no data on the read addr channel
                item.BURST_length <= vmif.ARLEN;
                item.ready <= vmif.ARREADY;
                item.valid <= vmif.ARVALID;
                item.BURST_type <= vmif.ARBURST;
                item.CACHE <= vmif.ARCACHE;
                item.LOCK <= vmif.ARLOCK;
                item.BURST_size <= vmif.ARSIZE;
                item.prot <= vmif.ARPROT;

                // outputs 
                item.out_data <= '0; // no data its an addr channel
                item.out_addr <= vmif.ARADDR; // addr is an output 
                item.out_resp <= OKAY; // not used here
            end

            // if write addr
            if(vmif.AWVALID & vmif.AWREADY) begin              
                // inputs (TECHNICALLY OUTS ALSO NEED TO LOOK INTO)
                item.address <= vmif.AWADDR;
                item.command <= WRITE;
                item.data <= '0; // no data on the write addr channel
                item.BURST_length <= vmif.AWLEN;
                item.ready <= vmif.AWREADY;
                item.valid <= vmif.AWVALID;
                item.BURST_type <= vmif.AWBURST;
                item.CACHE <= vmif.AWCACHE;
                item.LOCK <= vmif.AWLOCK;
                item.BURST_size <= vmif.AWSIZE;
                item.prot <= vmif.AWPROT;

                // outputs 
                item.out_data <= '0; // no data its an addr channel
                item.out_addr <= vmif.AWADDR; // addr is an output 
                item.out_resp <= OKAY; // not used here
            end

            // READ DATA
            if(vmif.RVALID & vmif.RREADY) begin
                item.address <= 0; // not relevant
                item.command <= READ;
                item.Channel <= DATA;
                item.data <= 0; // irrelevant
                item.out_data[0] <= vmif.RDATA;
                item.BURST_length <= vmif.ARLEN; // TODO tricky logic gere not simple come back to this 
                item.ready <= vmif.RREADY;
                item.valid <= vmif.RVALID;
                item.BURST_type <= vmif.ARBURST; // not sure what to do with this field
                item.CACHE <= vmif.ARCACHE; // not sure
                item.LOCK <= vmif.ARLOCK; // not sure
                item.BURST_size <= vmif.ARSIZE; // not sure
                item.prot <= vmif.ARPROT; // not sure
            end

            if(item.command == READ && item.Channel == DATA) begin
                int idx = 1;
                repeat(vmif.BURST_length) begin
                    while(!vmif.RVALID && !vmif.RREADY) begin
                        @(vmif.m_drv_cb); // wait till valid go high
                    end

                    item.out_data[idx] <= vmif.RDATA;

                    if(idx == vmif.BURST_length - 1) begin
                        item.Channel <= RDONE; // needed so I do not get stuck in if construct
                        break; // kill the loop 
                    end
                end
            end


            // WRITE DATA
            if(vmif.WVALID & vmif.WREADY) begin
                item.address <= 0; // not relevant
                item.command <= WRITE;
                item.Channel <= DATA;
                item.data[0] <= vmif.WDATA;
                item.BURST_length <= vmif.AWLEN; // TODO tricky logic gere not simple come back to this 
                item.ready <= vmif.WREADY;
                item.valid <= vmif.WVALID;
                item.BURST_type <= vmif.AWBURST; // not sure what to do with this field
                item.CACHE <= vmif.AWCACHE; // not sure
                item.LOCK <= vmif.AWLOCK; // not sure
                item.BURST_size <= vmif.AWSIZE; // not sure
                item.prot <= vmif.AWPROT; // not sure
            end

            if(item.command == WRITE && item.Channel == DATA) begin
                int idx = 1;
                repeat(vmif.BURST_length) begin
                    while(!vmif.WVALID && !vmif.WREADY) begin
                        @(vmif.m_drv_cb); // wait till valid go high
                    end

                    item.out_data[idx] = vmif.WDATA;

                    if(idx == vmif.BURST_length - 1) begin
                        item.Channel <= WDONE; // needed so I do not get stuck in if construct
                        break; // kill the loop 
                    end
                end
            end

            result_ap.write(item); // write to SB
        end
        
    endtask : run_phase

   
endclass //master_monitor




// OLD CODE MAY NEED LATER 
/*
 task void write_monitor();
        if(vif.m_mon_cb.AWVALID && vif.m_mon_cb.AWREADY) begin // READY from slave
            wr_trans = master_seqit#(NUM_ID,NUM_USER,DATA_LEN)::type_id::create("wr_trans"); // Making write transaction
            wr_trans.AWREADY = vif.m_mon_cb.AWREADY;
            wr_trans.WREADY = vif.m_mon_cb.WREADY;
            wr_trans.BVALID = vif.m_mon_cb.BVALID;
            wr_trans.BRESP = vif.m_mon_cb.BRESP;
            wr_trans.ARVALID = vif.m_mon_cb.ARVALID;
            wr_trans.RVALID = vif.m_mon_cb.RVALID;
            wr_trans.RLAST = vif.m_mon_cb.RLAST;
            wr_trans.RDATA = vif.m_mon_cb.RDATA; // TODO need to extend to be array of data for multiple data transfer
            wr_trans.RRESP = vif.m_mon_cb.RRESP;
            wr_trans.RID = vif.m_mon_cb.RID;
            wr_trans.RUSER = vif.m_mon_cb.RUSER;
        end
    endtask

    task void write_monitor(master_seqit t);
        if(vif.m_mon_cb.AWVALID && vif.m_mon_cb.AWREADY) begin // READY from slave
            wr_trans = master_seqit#(NUM_ID,NUM_USER,DATA_LEN)::type_id::create("wr_trans"); // Making write transaction
            wr_trans.AWREADY = vif.m_mon_cb.AWREADY;
            wr_trans.WREADY = vif.m_mon_cb.WREADY;
            wr_trans.BVALID = vif.m_mon_cb.BVALID;
            wr_trans.BRESP = vif.m_mon_cb.BRESP;
        end
    endtask

    task void read_monitor(master_seqit t);
        if(vif.m_mon_cb.ARVALID && vif.m_mon_cb.ARREADY) begin // READY from master
            re_trans = master_seqit#(NUM_ID,NUM_USER,DATA_LEN)::type_id::create("re_trans"); // Making write transaction
            re_trans.ARVALID = vif.m_mon_cb.ARVALID;
            re_trans.RVALID = vif.m_mon_cb.RVALID;
            re_trans.RLAST = vif.m_mon_cb.RLAST;
            re_trans.RDATA = vif.m_mon_cb.RDATA; // TODO need to extend to be array of data for multiple data transfer
            re_trans.RRESP = vif.m_mon_cb.RRESP;
            re_trans.RID = vif.m_mon_cb.RID;
            re_trans.RUSER = vif.m_mon_cb.RUSER;
        end
    endtask



    virtual task run_phase(phase);
        super.run_phase(phase);
        prev_tx = master_seqit#(NUM_ID,NUM_USER,DATA_LEN)::type_id::create("prev_tx"); // building with factory 
        
        // Monitor runs forever
        master_seqit tx;
        forever begin
            fork
                write_monitor(tx);
                read_monitor(tx);
            join
        end
        // PICK UP HERE
        
    endtask //
*/