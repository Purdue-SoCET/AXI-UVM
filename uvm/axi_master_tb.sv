`include "uvm_macros.svh"
import uvm_pkg::*;

`include "axi_master_if.vh"
`include "master_test.svh"

`timescale 1ns/1ps

module axi_duv_tb();

    parameter PERIOD = 10;
    logic CLK = 0;

    always forever #PERIOD CLK = !CLK;

    axi_master_if amif (CLK);

    axi_duv_master DUT(
    .aclk_i(CLK),
    .aresetn_i(amif.nRST),
    .bid_i(amif.BID),
    .bresp_i(amif.BRESP),
    .bvalid_i(amif.BVALID),
    .buser_i(amif.BUSER),
    .rdata_i(amif.RDATA),
    .rresp_i(amif.RRESP),
    .rlast_i(amif.RLAST),
    .rvalid_i(amif.RVALID),
    .ruser_i(amif.RUSER),
    .csysreq_i(0),
    .csysack_i(0),
    .cactive_i(0),
    .awid_i(amif.AWID),
    .awaddr_i(amif.AWADDR),
    .awlen_i(amif.AWLEN),
    .awsize_i(amif.AWSIZE),
    .awburst_i(amif.AWBURST),
    .awlock_i(amif.AWLOCK),
    .awcache_i(amif.AWCACHE),
    .awprot_i(amif.AWPROT),
    .awvalid_i(amif.AWVALID),
    .awready_i(amif.AWREADY),
    .awqos_i(amif.ARQOS),
    .awregion_i(amif.AWREGION),
    .awuser_i(amif.AWUSER),
    .wdata_i(amif.WDATA),
    .wstrb_i(amif.WSTRB),
    .wlast_i(amif.WLAST),
    .wvalid_i(amif.WVALID),
    .wready_i(amif.WREADY),
    .wuser_i(amif.WUSER),
    .bready_i(amif.BREADY),
    .arid_i(amif.ARID),
    .araddr_i(amif.ARADDR),
    .arlen_i(amif.ARLEN),
    .arsize_i(amif.ARSIZE),
    .arburst_i(amif.ARBURST),
    .arlock_i(amif.ARLOCK),
    .arcache_i(amif.ARCACHE),
    .arprot_i(amif.ARPROT),
    .arvalid_i(amif.ARVALID),
    .arready_i(amif.ARREADY),
    .arqos_i(amif.ARQOS),
    .arregion_i(amif.ARREGION),
    .aruser_i(amif.ARUSER),
    .rready_i(amif.RREADY)
    // add reset of signals 
  );
    

endmodule