`include "uvm_macros.svh"
import uvm_pkg::*;

`include "master_driver.svh"
`include "master_monitor.svh"
`include "master_sequencer.svh"


class master_agent extends uvm_agent;
    `uvm_component_utils(master_agent)

    master_monitor m_mon;
    master_axi_pipeline_driver m_drv;
    master_sequencer m_sqr;

    function new(string name = "master_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()

     function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        m_mon = master_monitor::type_id::create("m_mon",this);
        m_drv = master_axi_pipeline_driver::type_id::create("m_drv",this);
        m_sqr = master_sequencer::type_id::create("m_seq",this);
       
    endfunction

    function void connect_phase(uvm_phase phase); 
        m_drv.seq_item_port.connect(m_sqr.seq_item_export);
    endfunction

endclass //master_agent extends uvm_agent