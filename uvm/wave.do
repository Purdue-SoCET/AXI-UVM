onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /axi_master_duv_tb/amif/ACLK
add wave -noupdate /axi_master_duv_tb/amif/nRST
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Write addr} /axi_master_duv_tb/amif/AWREADY
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Write addr} /axi_master_duv_tb/amif/local_awid
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Write addr} /axi_master_duv_tb/amif/local_awaddr
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Write addr} /axi_master_duv_tb/amif/local_awlen
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Write addr} /axi_master_duv_tb/amif/local_awsize
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Write addr} /axi_master_duv_tb/amif/local_awburst
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Write addr} /axi_master_duv_tb/amif/local_awlock
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Write addr} /axi_master_duv_tb/amif/local_awvalid_i
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Write data } /axi_master_duv_tb/amif/WREADY
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Write data } /axi_master_duv_tb/amif/local_wdata
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Write data } /axi_master_duv_tb/amif/local_wstrb
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Write data } /axi_master_duv_tb/amif/local_wlast
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Write resp} /axi_master_duv_tb/amif/BVALID
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Write resp} /axi_master_duv_tb/amif/BRESP
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Write resp} /axi_master_duv_tb/amif/BID
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Write resp} /axi_master_duv_tb/amif/BUSER
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Read values set} /axi_master_duv_tb/amif/ARREADY
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Read values set} /axi_master_duv_tb/amif/local_arid
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Read values set} /axi_master_duv_tb/amif/local_araddr
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Read values set} /axi_master_duv_tb/amif/local_arlen
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Read values set} /axi_master_duv_tb/amif/local_arsize
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Read values set} /axi_master_duv_tb/amif/local_arburst
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Read values set} /axi_master_duv_tb/amif/local_arlock
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Read data resp} /axi_master_duv_tb/amif/RVALID
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Read data resp} /axi_master_duv_tb/amif/RDATA
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Read data resp} /axi_master_duv_tb/amif/RLAST
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Read data resp} /axi_master_duv_tb/amif/RRESP
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Read data resp} /axi_master_duv_tb/amif/RID
add wave -noupdate -expand -group {Master side CPU inputs} -expand -group {Read data resp} /axi_master_duv_tb/amif/RUSER
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/AWVALID
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/AWLEN
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/AWADDR
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/AWSIZE
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/AWBURST
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/AWCACHE
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/AWPROT
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/AWID
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/AWLOCK
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/AWQOS
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/AWREGION
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/AWUSER
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/WVALID
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/WLAST
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/WDATA
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/WSTRB
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/WUSER
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/BREADY
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/ARVALID
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/ARADDR
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/ARSIZE
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/ARBURST
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/ARCACHE
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/ARPROT
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/ARID
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/ARLEN
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/ARLOCK
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/ARQOS
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/ARREGION
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/ARUSER
add wave -noupdate -expand -group Outputs /axi_master_duv_tb/amif/RREADY
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {289973 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {929252 ps}
