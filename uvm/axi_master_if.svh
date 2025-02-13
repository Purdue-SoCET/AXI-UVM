`ifndef AXI_MASTER_VH
`define AXI_MASTER_VH


interface axi_master_if #( // MAY NOT NEED TO PARM
    parameter NUM_ID = NUM_ID,
    parameter NUM_USER = NUM_USER,
    parameter DATA_LEN = DAT_LEN // May get rid of TODO 1/20/25
)
(input logic ACLK, ARESETn); // FLAG I do not think rst should be here but I will look into


/////////////// WRITE ADDR CHANNEL/////////////////
// INPUTS
logic AWREADY;
// OUTPUTS
logic AWVALID;
logic [31:0] AWADDR;
logic [2:0] AWSIZE;
logic [1:0] AWBURST;
logic [3:0] AWCACHE
logic [2:0] AWPROT
logic [NUM_ID - 1:0] AWID;
logic [7:0] AWLEN;
logic AWLOCK;
logic [3:0] AWQOS;
logic [3:0] AWREGION;
logic [NUM_USER - 1:0] AWUSER; // Todo look into size
// logic [DAT_LEN - 1:0] m_data[];


/////////////// WRITE DATA CHANNEL/////////////////
// INPUTS
logic WREADY;
// OUTPUTS
logic WVALID;
logic WLAST;
logic [DATA_LEN- 1:0] WDATA ;
logic [x:0] WSTRB; // Todo figure out len
logic [NUM_ID - 1: 0] WUSER; // Todo look into size

// Signals needed for UVM TB
// logic [DATA_LEN- 1:0] WCDATA []; // Write Check data
/////////////// WRITE RESPONSE CHANNEL/////////////////
// INPUTS
logic BVALID;
logic BRESP;
logic BID;
// OUTPUTS
logic BREADY;
logic BUSER; // Todo look into size

/////////////// READ ADDR CHANNEL/////////////////
// INPUTS
logic ARVALID;
// OUTPUTS
logic ARREADY;
logic [31:0] ARADDR;
logic [2:0] ARSIZE;
logic [1:0] ARBURST;
logic [3:0] ARCACHE;
logic [2:0] ARPROT;
logic [NUM_ID - 1:0] ARID;
logic [7:0] ARLEN;
logic ARLOCK;
logic [3:0] ARQOS;
logic [3:0] ARREGION;
logic [NUM_USER- 1:0] ARUSER; // Todo look into size

/////////////// READ DATA CHANNEL/////////////////
// INPUTS
logic RVALID;
logic RLAST;
logic [DATA_LEN - 1:0] RDATA;
logic [1:0] RRESP;
logic [NUM_ID - 1:0] RID;
logic [NUM_ID - 1: 0] RUSER; // Todo look into size
// OUTPUTS
logic RREADY;

// TODO LOOK INTO CLOCKING BLOCK

/*CLOCKING block Def "It is a collection of signals synchronous with 
a particular clock and helps to specify the timing requirements 
between the clock and the signals"
*/

//  driver clocking block
clocking m_drv_cb @(posedge ACLK)
    output AWVALID, AWADDR, AWSIZE, AWBURST, AWCACHE, AWPROT,
    AWID, AWLEN, AWLOCK, AWQOS, AWREGION, AWUSER,
    WVALID, WLAST, WDATA, WSTRB, WUSER, BREADY, 
    ARADDR, ARSIZE, ARBURST, ARCACHE, ARPROT, ARID, ARREADY, 
    ARLEN, ARLOCK, ARQOS, ARREGION, ARUSER, RREADY;

    input AWREADY, WREADY, BVALID, BRESP, BID, ARVALID, BUSER,
    RVALID, RDATA, RRESP, RID, RUSER, RVALID;
endclocking

// //  monitor clocking block
// clocking m_mon_cb @(posedge ACLK) // This makes sense inputs into the monitor are outputs of DUT
//     input AWVALID, AWADDR, AWSIZE, AWBURST, AWCACHE, AWPROT,
//     AWID, AWLEN, AWLOCK, AWQOS, AWREGION, AWUSER,
//     WVALID, WLAST, WDATA, WSTRB, WUSER, BREADY, 
//     ARADDR, ARSIZE, ARBURST, ARCACHE, ARPROT, ARID, ARREADY, 
//     ARLEN, ARLOCK, ARQOS, ARREGION, ARUSER, RREADY;
    
//     output AWREADY, WREADY, BVALID, BRESP, BID, ARVALID, BUSER,
//     RVALID, RDATA, RRESP, RID, RUSER, RVALID;
// endclocking

// modport MDRV(m_drv_cb, input ARESETn);
// modport MMON(m_mon_cb, input ARESETn);

// TODO ADD ASSERTIONS WHEN I KNOW THE SPECIFICATIONS OF THE DUT
property nrst_success;
    (@(m_mon_cb) $fell(nRST) |=> (AWVALID == 0 && AWSIZE == 0 && AWBURST == 0 && AWCACHE == 0 &&
    AWPROT == 0 && AWID == 0 && AWLEN == 0 && AWLOCK == 0 && AWQOS == 0 && AWREGION == 0 && AWUSER == 0 &&
    WVALID == 0 && WLAST == 0 && WDATA == '1 && WSTRB == 0 && WUSER == 0 &&
    ARADDR == 0 && ARSIZE == 0 && ARBURST == 0 && ARCACHE == 0 && ARPROT == 0 && ARID == 0 && ARLEN == 0 &&
    ARLOCK == 0 && ARQOS == 0 && ARREGION == 0 && ARUSER == 0 && RREADY == 0));
endproperty 

// nRST correct
assert property (nrst_success) begin
    `uvm_info("sva", $sformatf("Test Case: nRST0 : PASSED"), UVM_LOW)
end 
else begin
    `uvm_info("sva", $sformatf("Test Case: nRST0 : FAILED, @ Time : %0t"), UVM_HIGH, $timeformat(-9, 2, "ns", 20))
end



///////////////////////////// OLD WRONG CODE/////////////////////////////
// modport write_addr ( // modport to DUT
//    input AWREADY,
//    output AWVALID,AWADDR,AWSIZE, AWBURST,AWCACHE,AWPROT,
//    AWID,AWLEN,AWLOCK,AWQOS,AWREGION,AWUSER
// );

// modport write_data ( // modport to DUT
//     input WREADY,
//     output WVALID,WLAST,WDATA,WSTRB,WUSER
// );

// modport write_resp ( // modport to DUT
//     input BVALID,BRESP,BID,
//     output BREADY,BUSER
// );

// modport read_addr ( // modport to DUT
//     input ARVALID,
//     output ARREADY,ARSIZE,ARBURST,ARCACHE,ARPROT,ARID
//     ARLEN,ARLOCK,ARQOS,ARREGION,ARUSER
// );

// modport read_data ( // modport to DUT
//     input RVALID,RDATA,RDATA,RRESP,RID,RUSER,
//     output RREADY
// );

endinterface
`endif // end of 