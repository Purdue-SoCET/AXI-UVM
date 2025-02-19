import uvm_pkg::*;
`include "uvm_macros.svh"
`include "axi_master_if.svh" // interface added
`include "master_seqit.svh"
`include "master_params.svh"
// `include "master_monitor.svh"

class phony_master_monitor extends master_monitor;
    `uvm_component_utils(phony_master_monitor)

    virtual axi_master_if vmif;

    // Commented out because I do not think I need this since I can not really predict
    // uvm_analysis_port#(master_seqit) axi_ap; // Result from DUT to Predictor

    // uvm_analysis_port#(master_seqit) result_ap; // Result from DUT to COMP

    function new(string name = "phony_master_monitor", uvm_component parent = null);
        super.new(name,parent);
        `uvm_info("PHONEY_MONITOR", "phony_master_monitor constructor called", UVM_MEDIUM)
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); 
    endfunction

    function intial_vals(master_seqit item);
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
        item.nRST <= vmif.m_drv_cb.nRST;

        // outputs 
        item.out_data <= '0; // no data its an addr channel TODO CHANGE WRONG
        item.out_addr <= '1; // addr is an output 
        item.out_qos <= '1; // 
        item.out_region <= '1; // 
        item.out_user <= '1; // 
    endfunction

    task reset_vals(master_seqit item);
        item.address <= vmif.m_drv_cb.AWADDR;
        item.command <= WRITE;
        item.data <= vmif.m_drv_cb.WDATA; 
        item.BURST_length <= vmif.m_drv_cb.AWLEN;
        item.ready <= vmif.m_drv_cb.AWREADY;
        item.valid <= vmif.m_drv_cb.AWVALID;
        item.BURST_type <= TYPE_BURST'(vmif.m_drv_cb.AWBURST);
        item.CACHE <= vmif.m_drv_cb.AWCACHE;
        item.LOCK <= vmif.m_drv_cb.AWLOCK;
        item.BURST_size <= vmif.m_drv_cb.AWSIZE;
        item.prot <= vmif.m_drv_cb.AWPROT;
        item.nRST <= vmif.m_drv_cb.nRST;
        item.out_data <= vmif.m_drv_cb.WDATA; // no data its an addr channel TODO CHANGE WRONG
        item.out_addr <= vmif.m_drv_cb.AWADDR; // addr is an output 
        item.out_qos <= vmif.m_drv_cb.AWQOS; 
        item.out_region <= vmif.m_drv_cb.AWREGION; 
        item.out_user <= vmif.m_drv_cb.AWUSER;  
    endtask

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        // wait(vmif.m_drv_cb.nRST == 1'b1); // Wait until reset is de-asserted
        `uvm_info("MONITOR CLASS", "Run Phase", UVM_NONE)
        forever begin
            master_seqit item; // Previous transaction
            item = master_seqit#(DATA_WIDTH)::type_id::create("item");
            $display("Before calling intial_vals");
            intial_vals(item);
            $display("After calling intial_vals, addr=%h, data=%h", item.address, item.data);            
            @(vmif.m_drv_cb);

            if(vmif.m_drv_cb.nRST == 0) begin
                reset_vals(item); // reset values 
            end
            result_ap.write(item); // write to SB
        end
        
    endtask : run_phase

   
endclass //master_monitor




//    // Inital values
// item.address <= '1;
// item.command <= WRITE;
// item.data <= '1; // no data on the read addr channel TODO CHANGE WRONG
// item.BURST_length <= '1;
// item.ready <= '1;
// item.valid <= '1;
// item.BURST_type <= TYPE_BURST'('1);
// item.CACHE <= '1;
// item.LOCK <= '1;
// item.BURST_size <= '1;
// item.prot <= '1;
// item.out_data <= '1; // no data its an addr channel TODO CHANGE WRONG
// item.out_addr <='1; // addr is an output 








// // READ ADDR
// if(vmif.m_drv_cb.ARVALID && vmif.m_drv_cb.ARREADY) begin              
//     // inputs (TECHNICALLY OUTS ALSO NEED TO LOOK INTO)
//     item.address <= vmif.m_drv_cb.ARADDR;
//     item.command <= READ;
//     item.data <= '0; // no data on the read addr channel TODO CHANGE WRONG
//     item.BURST_length <= vmif.m_drv_cb.ARLEN;
//     item.ready <= vmif.m_drv_cb.ARREADY;
//     item.valid <= vmif.m_drv_cb.ARVALID;
//     item.BURST_type <= TYPE_BURST'(vmif.m_drv_cb.ARBURST);
//     item.CACHE <= vmif.m_drv_cb.ARCACHE;
//     item.LOCK <= vmif.m_drv_cb.ARLOCK;
//     item.BURST_size <= vmif.m_drv_cb.ARSIZE;
//     item.prot <= vmif.m_drv_cb.ARPROT;

//     // outputs 
//     item.out_data <= '0; // no data its an addr channel TODO CHANGE WRONG
//     item.out_addr <= vmif.m_drv_cb.ARADDR; // addr is an output 
//     // item.out_resp <= OKAY; // not used here
// end

// // WRITE ADDR
// else if(vmif.m_drv_cb.AWVALID && vmif.m_drv_cb.AWREADY) begin              
//     // inputs (TECHNICALLY OUTS ALSO NEED TO LOOK INTO)
//     item.address <= vmif.m_drv_cb.AWADDR;
//     item.command <= WRITE;
//     item.data <= '0; // no data on the write addr channel TODO CHANGE WRONG
//     item.BURST_length <= vmif.m_drv_cb.AWLEN;
//     item.ready <= vmif.m_drv_cb.AWREADY;
//     item.valid <= vmif.m_drv_cb.AWVALID;
//     item.BURST_type <= TYPE_BURST'(vmif.m_drv_cb.AWBURST);
//     item.CACHE <= vmif.m_drv_cb.AWCACHE;
//     item.LOCK <= vmif.m_drv_cb.AWLOCK;
//     item.BURST_size <= vmif.m_drv_cb.AWSIZE;
//     item.prot <= vmif.m_drv_cb.AWPROT;

//     // outputs 
//     item.out_data <= '0; // no data its an addr channel TODO CHANGE WRONF
//     item.out_addr <= vmif.m_drv_cb.AWADDR; // addr is an output 
//     // item.out_resp <= OKAY; // not used here
// end

// // READ DATA
// else if(vmif.m_drv_cb.RVALID && vmif.m_drv_cb.RREADY) begin
//     item.address <= 0; // not relevant
//     item.command <= READ;
//     item.Channel <= DATA;
//     item.data <= '1; // RDATA is an input 
//     item.out_data <= '1; // RDATA IS AN INPUT
//     item.BURST_length <= vmif.m_drv_cb.ARLEN; // TODO tricky logic gere not simple come back to this 
//     item.ready <= vmif.m_drv_cb.RREADY;
//     item.valid <= vmif.m_drv_cb.RVALID;
//     item.BURST_type <= TYPE_BURST'(vmif.m_drv_cb.ARBURST); // not sure what to do with this field
//     item.CACHE <= vmif.m_drv_cb.ARCACHE; // not sure
//     item.LOCK <= vmif.m_drv_cb.ARLOCK; // not sure
//     item.BURST_size <= vmif.m_drv_cb.ARSIZE; // not sure
//     item.prot <= vmif.m_drv_cb.ARPROT; // not sure
// end

// // WRITE DATA
// else if(vmif.m_drv_cb.WVALID && vmif.m_drv_cb.WREADY) begin
//     item.address <= 0; // not relevant
//     item.command <= WRITE;
//     item.Channel <= DATA;
//     item.data <= vmif.m_drv_cb.WDATA;
//     item.BURST_length <= vmif.m_drv_cb.AWLEN; // TODO tricky logic gere not simple come back to this 
//     item.ready <= vmif.m_drv_cb.WREADY;
//     item.valid <= vmif.m_drv_cb.WVALID;
//     item.BURST_type <= TYPE_BURST'(vmif.m_drv_cb.AWBURST); // not sure what to do with this field
//     item.CACHE <= vmif.m_drv_cb.AWCACHE; // not sure
//     item.LOCK <= vmif.m_drv_cb.AWLOCK; // not sure
//     item.BURST_size <= vmif.m_drv_cb.AWSIZE; // not sure
//     item.prot <= vmif.m_drv_cb.AWPROT; // not sure
// end