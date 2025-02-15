`include "uvm_macros.svh"
import uvm_pkg::*;
`include "axi_master_if.svh"
`include "master_agent.svh"
`include "master_scoreboard.svh"
`include "master_seqit.svh"


class master_enviroment extends uvm_env;
    `uvm_component_utils(master_enviroment)

    master_agent m_agt;
    master_scoreboard m_sb;

    function new(string name = "master_enviroment", uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_agt = master_agent::type_id::create("m_agt");
        m_sb = master_scoreboard::type_id::create("m_sb");
    endfunction

    function void connect_phase(uvm_phase phase);
        // --- Monitor -> Scoreboard --- //
        m_agt.m_mon.result_ap.connect(m_sb.scoreboard_port);
    endfunction
    
endclass //master_enviroment extends uvm_enviroment