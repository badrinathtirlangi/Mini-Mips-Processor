`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2025 02:52:41 PM
// Design Name: 
// Module Name: Instruction_fetch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module instruction_fetch(clk, rst,branch_taken,branch_addr,jump,jump_addr,pc,instruction);
    input clk;
    input rst;
    input branch_taken;      
    input [31:0] branch_addr;
    input jump;       
    input [31:0] jump_addr;
    output reg [31:0] pc;      
    output reg [31:0] instruction;

    wire [31:0] instr_mem_data;
    
    instruction_memory get_mem(
        .clk(clk),
        .rst(rst),
        .instruction(instr_mem_data),
        .pc(pc)
    );

    always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc <= 32'h0;
        instruction <= 32'h0;
    end else begin
      instruction <= instr_mem_data;
      
      $display("PC: %h, Jump: %b, Branch: %b", pc, jump, branch_taken);
      
      if (jump) begin
          pc <= jump_addr;
      end else if (branch_taken) begin
          pc <= branch_addr;
      end else begin
          pc <= pc + 4;
      end
    end
    end

endmodule 