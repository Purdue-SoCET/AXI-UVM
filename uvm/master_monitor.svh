import uvm_pkg::*;
`include "uvm_macros.svh"
`include "axi_master_if.vh" // interface added

class master_monitor extends uvm_monitor;
    `uvm_component_utils(master_monitor)

    virtual axi_master_if#(NUM_ID,NUM_USER,DATA_LEN)).MMON vif;
    master_transaction#(NUM_ID,NUM_USER,DATA_LEN) re_trans,wr_trans;
    uvm_analysis_port#(master_base_sequence) result_ap; // Result from DUT to COMP
    uvm_analysis_port#(master_base_sequence) axi_ap; // Result from DUT to Predictor
    master_transaction prev_tx; // Previous transaction

    function new(string name, uvm_component parent = null);
        super.new(name,parent);
        axi_ap = new("axi_ap",this);
        result_ap = new("result_ap",this);
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); 
        // get interface from upper level
        if(!uvm_config_db#(virtual axi_master_if#((NUM_ID,NUM_USER,DATA_LEN)).MMON)::get(this,"","MMON",vif)) begin
            `uvm_fatal("Monitor", "No virtual interface specified for the monitor instance")
        end
    endfunction

    task void write_monitor();
        if(vif.m_mon_cb.AWVALID && vif.m_mon_cb.AWREADY) begin // READY from slave
            wr_trans = master_transaction#(NUM_ID,NUM_USER,DATA_LEN)::type_id::create("wr_trans"); // Making write transaction
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

    task void write_monitor(master_transaction t);
        if(vif.m_mon_cb.AWVALID && vif.m_mon_cb.AWREADY) begin // READY from slave
            wr_trans = master_transaction#(NUM_ID,NUM_USER,DATA_LEN)::type_id::create("wr_trans"); // Making write transaction
            wr_trans.AWREADY = vif.m_mon_cb.AWREADY;
            wr_trans.WREADY = vif.m_mon_cb.WREADY;
            wr_trans.BVALID = vif.m_mon_cb.BVALID;
            wr_trans.BRESP = vif.m_mon_cb.BRESP;
        end
    endtask

    task void read_monitor(master_transaction t);
        if(vif.m_mon_cb.ARVALID && vif.m_mon_cb.ARREADY) begin // READY from master
            re_trans = master_transaction#(NUM_ID,NUM_USER,DATA_LEN)::type_id::create("re_trans"); // Making write transaction
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
        prev_tx = master_transaction#(NUM_ID,NUM_USER,DATA_LEN)::type_id::create("prev_tx"); // building with factory 
        
        // Monitor runs forever
        master_transaction tx;
        forever begin
            fork
                write_monitor(tx);
                read_monitor(tx);
            join
        end
        // PICK UP HERE
        
    endtask //
endclass //master_monitor extends uvm_monitor