
// --- UVM --- //
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "master_params.svh"

// --- Includes --- //
`include "master_seqit.svh"
`include "axi_master_if.svh"

class master_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(master_scoreboard)

    int m_matches;
    int m_mismatches;
    uvm_analysis_imp #(master_seqit, master_scoreboard) scoreboard_port;
    master_seqit transactions[$]; // dynamic array may need for later


    function new(string name = "master_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scoreboard_port = new("scoreboard_port", this);
        m_matches = 0;
        m_mismatches = 0;
    endfunction : build_phase

    function void write(master_seqit item);
        transactions.push_back(item);
    endfunction  : write


    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("SCB_CLASS", "Run Phase", UVM_LOW)
        
           // --- Transaction Stack --- //
    forever begin
        master_seqit curr_tx;
        wait((transactions.size() != 0));
        curr_tx = transactions.pop_front();
        compare(curr_tx);
    end

    endtask : run_phase

    function compare(master_seqit curr_tx); 
         // --- Reset Check --- //
        if(curr_tx.nRST == 1'b0) begin   
                // TODO FOR SOME REASON ALL THESE HAVE TO BE "`uvm_report_info" need to look into why maybe because its specifically the SB
        
                // inputs (TECHNICALLY OUTS ALSO NEED TO LOOK INTO)
                if (curr_tx.address == '0) begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 address : PASSED"), UVM_HIGH);
                end
                else begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 address : FAILED"), UVM_LOW);
                end

                if (curr_tx.data == '1) begin
                     uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 data: PASSED"), UVM_HIGH);
                     m_matches++;
                end
                else begin
                     uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 data: FAILED"), UVM_LOW);
                     m_mismatches++;
                end

                if (curr_tx.BURST_length == '0) begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 BURST_length : PASSED"), UVM_HIGH);
                end
                else begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 BURST_length : FAILED"), UVM_LOW);
                end

                if (curr_tx.ready == '0) begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 ready : PASSED"), UVM_HIGH);
                end
                else uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 ready : FAILED"), UVM_LOW);

                if (curr_tx.valid == '0)  begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 valid : PASSED"), UVM_HIGH);
                end
                else begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 valid : FAILED"), UVM_LOW);
                end

                if (curr_tx.BURST_type == '0) begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 BURST_type : PASSED"), UVM_HIGH);
                end
                else begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 BURST_type: FAILED"), UVM_LOW);
                end

                if (curr_tx.CACHE == '0) begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 CACHE : PASSED"), UVM_HIGH);
                end
                else begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 CACHE: FAILED"), UVM_LOW);
                end

                if (curr_tx.LOCK == '0) begin
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 LOCK: PASSED"), UVM_HIGH);
                end
                else begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 LOCK: FAILED"), UVM_LOW);
                end

                if (curr_tx.BURST_size == '0) begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 BURST_size: PASSED"), UVM_HIGH);
                end
                else begin
                     uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 BURST_size: FAILED"), UVM_LOW);
                end

                if (curr_tx.LOCK == '0) begin
                     uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 LOCK: PASSED"), UVM_HIGH);
                end
                else begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 LOCK: FAILED"), UVM_LOW);
                end

                if (curr_tx.prot == '0) begin
                     uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 prot: PASSED"), UVM_HIGH);
                end
                else begin
                     uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 prot: FAILED"), UVM_LOW);
                end

                if (curr_tx.out_data == '1) begin
                     uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 out_data: PASSED"), UVM_HIGH);
                end
                else begin
                     uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 out_data: FAILED"), UVM_LOW);
                end

                if (curr_tx.out_addr == '0) begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 out_addr: PASSED"), UVM_HIGH);
                end
                else begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 out_addr : FAILED"), UVM_LOW);
                end

                if (curr_tx.out_resp == '0) begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 out_resp: PASSED"), UVM_HIGH);
                end
                else begin 
                    uvm_report_info("COMPARE", $sformatf("Test Case: RESET0 out_resp: FAILED \n"), UVM_LOW);
                end

            end
    endfunction

    function void report_phase(uvm_phase phase);
        uvm_report_info("Comparator", $sformatf("Matches:    %0d", m_matches));
        uvm_report_info("Comparator", $sformatf("Mismatches: %0d", m_mismatches));
    endfunction
endclass //master_scoreboard extends uvm_scoreboard