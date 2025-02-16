
// --- UVM --- //
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "master_params.svh"

// --- Includes --- //
`include "master_seqit.svh"
`include "axi_master_if.svh"

class master_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(master_scoreboard)

    uvm_analysis_imp #(master_seqit, master_scoreboard) scoreboard_port;
    master_seqit transactions[$]; // dynamic array may need for later


    function new(string name = "master_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scoreboard_port = new("scoreboard_port", this);
    endfunction : build_phase

    function void write(master_seqit item);
        transactions.push_back(item);
    endfunction  : write


    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("SCB_CLASS", "Run Phase", UVM_HIGH)
        
           // --- Transaction Stack --- //
    forever begin
        master_seqit curr_tx;
        wait((transactions.size() != 0));
        curr_tx = transactions.pop_front();
        compare(curr_tx);
    end

    endtask : run_phase

    task compare(master_seqit curr_tx); 

         // --- Reset Check --- //
        if(curr_tx.nRST == 1'b0) begin   
                // TODO FOR SOME REASON ALL THESE HAVE TO BE "`uvm_report_info" need to look into why maybe because its specifically the SB
        
                // inputs (TECHNICALLY OUTS ALSO NEED TO LOOK INTO)
                if (curr_tx.address == '0) uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : PASSED"), UVM_LOW);
                else uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : FAILED"), UVM_HIGH);

                if (curr_tx.data[0] == '1) uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : PASSED"), UVM_LOW);
                else uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : FAILED"), UVM_HIGH);

                if (curr_tx.BURST_length == '0) uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : PASSED"), UVM_LOW);
                else uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : FAILED"), UVM_HIGH);

                if (curr_tx.ready == '0) uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : PASSED"), UVM_LOW);
                else uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : FAILED"), UVM_HIGH);

                if (curr_tx.valid == '0) uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : PASSED"), UVM_LOW);
                else uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : FAILED"), UVM_HIGH);

                if (curr_tx.BURST_type == '0) uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : PASSED"), UVM_LOW);
                else uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : FAILED"), UVM_HIGH);

                if (curr_tx.CACHE == '0) uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : PASSED"), UVM_LOW);
                else uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : FAILED"), UVM_HIGH);

                if (curr_tx.LOCK == '0) uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : PASSED"), UVM_LOW);
                else uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : FAILED"), UVM_HIGH);

                if (curr_tx.BURST_size == '0) uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : PASSED"), UVM_LOW);
                else uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : FAILED"), UVM_HIGH);

                if (curr_tx.LOCK == '0) uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : PASSED"), UVM_LOW);
                else uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : FAILED"), UVM_HIGH);

                if (curr_tx.prot == '0) uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : PASSED"), UVM_LOW);
                else uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : FAILED"), UVM_HIGH);

                if (curr_tx.out_data[0] == '1) uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : PASSED"), UVM_LOW);
                else uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : FAILED"), UVM_HIGH);

                if (curr_tx.out_addr == '0) uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : PASSED"), UVM_LOW);
                else uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : FAILED"), UVM_HIGH);

                if (curr_tx.out_resp == '0) uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : PASSED"), UVM_LOW);
                else uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 : FAILED"), UVM_HIGH);
            end
    endtask

endclass //master_scoreboard extends uvm_scoreboard