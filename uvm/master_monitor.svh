import uvm_pkg::*;
`include "uvm_macros.svh"
`include "axi_master_if.svh" // interface added
`include "master_seqit.svh"
`include "master_params.svh"

class master_monitor extends uvm_monitor;
    `uvm_component_utils(master_monitor)

    virtual axi_master_if vmif;

    // Commented out because I do not think I need this since I can not really predict
    // uvm_analysis_port#(master_seqit) axi_ap; // Result from DUT to Predictor

    uvm_analysis_port#(master_seqit) result_ap; // Result from DUT to COMP

    function new(string name = "master_monitor", uvm_component parent = null);
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

    task intial_vals(master_seqit item);
        item.address <= '1;
        item.command <= WRITE;
        item.data <= '0; // no data on the read addr channel TODO CHANGE WRONG
        item.BURST_length <= '1;
        item.ready <= '1;
        item.valid <= '1;
        item.BURST_type <= TYPE_BURST'('1);
        item.CACHE <= '1;
        item.LOCK <= '1;
        item.BURST_size <='1;
        item.prot <= '1;
        item.nRST <= vmif.nRST;

        // outputs 
        item.out_data <= '0; // no data its an addr channel TODO CHANGE WRONG
        item.out_addr <= '1; // addr is an output 
        item.out_qos <= '1; // 
        item.out_region <= '1; // 
        item.out_user <= '1; // 
    endtask

    task set_vals(master_seqit item);
        item.address = vmif.AWADDR;
        item.command = WRITE;
        item.data = vmif.WDATA; 
        item.BURST_length = vmif.AWLEN;
        item.ready = vmif.RREADY;
        item.valid = vmif.AWVALID;
        item.BURST_type = TYPE_BURST'(vmif.AWBURST);
        item.CACHE = vmif.AWCACHE;
        item.LOCK = vmif.AWLOCK;
        item.BURST_size = vmif.AWSIZE;
        item.prot = vmif.AWPROT;
        item.nRST = vmif.nRST;
        item.out_data = vmif.WDATA; // no data its an addr channel TODO CHANGE WRONG
        item.out_addr = vmif.AWADDR; // addr is an output 
        item.out_qos = vmif.AWQOS; 
        item.out_region = vmif.AWREGION; 
        item.out_user = vmif.AWUSER;  
    endtask

    task set_vals2(master_seqit item);
        item.address = vmif.ARADDR;
        item.command = READ;
        item.data = vmif.WDATA; 
        item.BURST_length = vmif.ARLEN;
        item.ready = vmif.RREADY;
        item.valid = vmif.ARVALID;
        item.BURST_type = TYPE_BURST'(vmif.ARBURST);
        item.CACHE = vmif.ARCACHE;
        item.LOCK = vmif.ARLOCK;
        item.BURST_size = vmif.ARSIZE;
        item.prot = vmif.ARPROT;
        item.nRST = vmif.nRST;
        item.out_data = vmif.WDATA; // no data its an addr channel TODO CHANGE WRONG
        item.out_addr = vmif.ARADDR; // addr is an output 
        item.out_qos = vmif.ARQOS; 
        item.out_region = vmif.ARREGION; 
        item.out_user = vmif.ARUSER;  
    endtask

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        // wait(vmif.nRST == 1'b1); // Wait until reset is de-asserted
        `uvm_info("MONITOR CLASS", "Run Phase", UVM_NONE)
        forever begin
            master_seqit item; // Previous transaction
            item = master_seqit#(DATA_WIDTH)::type_id::create("item");
            @(vmif.m_drv_cb);
            @(vmif.m_drv_cb);
            // NOTE I think issue is I need to syncronize twice because at the falling edge of nRST it samples but the DUT has not seen nRST low at a posedge 
            // TODO CONFIRM ABOVE STATEMENT
            set_vals2(item); // reset values 
            // NOTE if nRST you should have to wait an extra clk
            // if(vmif.nRST == 0) begin
            //     // $display("Before calling intial_vals %t", $time);
            //     // @(vmif.m_drv_cb);
            //     // reset_vals(item); // reset values 
            //     // $display("After calling intial_vals, addr=%h, data=%h at time %0t", item.address, item.data,$time);            
            // end
            // $display("VALS SENT, addr=%h, nRST=%h at time %0t", item.address, item.nRST,$time);            
            result_ap.write(item); // write to SB

            set_vals(item); // reset values 
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