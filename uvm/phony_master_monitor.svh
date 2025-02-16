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

    uvm_analysis_port#(master_seqit) result_ap; // Result from DUT to COMP

    function new(string name = "phony_master_monitor", uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase); 
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        `uvm_info("MONITOR CLASS", "Run Phase", UVM_HIGH)
        forever begin
            master_seqit item; // Previous transaction
            item = master_seqit#(DATA_WIDTH)::type_id::create("item");
            
            item.nRST = vmif.nRST;
            

            @(vmif.m_drv_cb);

            // Inital values
            item.address <= '1;
            item.command <= WRITE;
            item.data[0] <= '1; // no data on the read addr channel TODO CHANGE WRONG
            item.BURST_length <= '1;
            item.ready <= '1;
            item.valid <= '1;
            item.BURST_type <= TYPE_BURST'('1);
            item.CACHE <= '1;
            item.LOCK <= '1;
            item.BURST_size <= '1;
            item.prot <= '1;
            item.out_data[0] <= '1; // no data its an addr channel TODO CHANGE WRONG
            item.out_addr <='1; // addr is an output 

            // READ ADDR
            if(vmif.ARVALID && vmif.ARREADY) begin              
                // inputs (TECHNICALLY OUTS ALSO NEED TO LOOK INTO)
                item.address <= vmif.ARADDR;
                item.command <= READ;
                item.data[0] <= '0; // no data on the read addr channel TODO CHANGE WRONG
                item.BURST_length <= vmif.ARLEN;
                item.ready <= vmif.ARREADY;
                item.valid <= vmif.ARVALID;
                item.BURST_type <= TYPE_BURST'(vmif.ARBURST);
                item.CACHE <= vmif.ARCACHE;
                item.LOCK <= vmif.ARLOCK;
                item.BURST_size <= vmif.ARSIZE;
                item.prot <= vmif.ARPROT;

                // outputs 
                item.out_data[0] <= '0; // no data its an addr channel TODO CHANGE WRONG
                item.out_addr <= vmif.ARADDR; // addr is an output 
                // item.out_resp <= OKAY; // not used here
            end

            // WRITE ADDR
            if(vmif.AWVALID && vmif.AWREADY) begin              
                // inputs (TECHNICALLY OUTS ALSO NEED TO LOOK INTO)
                item.address <= vmif.AWADDR;
                item.command <= WRITE;
                item.data[0] <= '0; // no data on the write addr channel TODO CHANGE WRONG
                item.BURST_length <= vmif.AWLEN;
                item.ready <= vmif.AWREADY;
                item.valid <= vmif.AWVALID;
                item.BURST_type <= TYPE_BURST'(vmif.AWBURST);
                item.CACHE <= vmif.AWCACHE;
                item.LOCK <= vmif.AWLOCK;
                item.BURST_size <= vmif.AWSIZE;
                item.prot <= vmif.AWPROT;

                // outputs 
                item.out_data[0] <= '0; // no data its an addr channel TODO CHANGE WRONF
                item.out_addr <= vmif.AWADDR; // addr is an output 
                // item.out_resp <= OKAY; // not used here
            end

            // READ DATA
            if(vmif.RVALID && vmif.RREADY) begin
                item.address <= 0; // not relevant
                item.command <= READ;
                item.Channel <= DATA;
                item.data[0] <= 0; // irrelevant todo change wrong
                item.out_data[0] <= vmif.RDATA;
                item.BURST_length <= vmif.ARLEN; // TODO tricky logic gere not simple come back to this 
                item.ready <= vmif.RREADY;
                item.valid <= vmif.RVALID;
                item.BURST_type <= TYPE_BURST'(vmif.ARBURST); // not sure what to do with this field
                item.CACHE <= vmif.ARCACHE; // not sure
                item.LOCK <= vmif.ARLOCK; // not sure
                item.BURST_size <= vmif.ARSIZE; // not sure
                item.prot <= vmif.ARPROT; // not sure
            end

            // WRITE DATA
            if(vmif.WVALID && vmif.WREADY) begin
                item.address <= 0; // not relevant
                item.command <= WRITE;
                item.Channel <= DATA;
                item.data[0] <= vmif.WDATA;
                item.BURST_length <= vmif.AWLEN; // TODO tricky logic gere not simple come back to this 
                item.ready <= vmif.WREADY;
                item.valid <= vmif.WVALID;
                item.BURST_type <= TYPE_BURST'(vmif.AWBURST); // not sure what to do with this field
                item.CACHE <= vmif.AWCACHE; // not sure
                item.LOCK <= vmif.AWLOCK; // not sure
                item.BURST_size <= vmif.AWSIZE; // not sure
                item.prot <= vmif.AWPROT; // not sure
            end

            result_ap.write(item); // write to SB
        end
        
    endtask : run_phase

   
endclass //master_monitor
