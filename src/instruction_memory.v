`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2025 02:38:53 PM
// Design Name: 
// Module Name: memory
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

module instruction_memory(clk, rst, instruction, pc);
    input  clk;
    input  rst;      
    input  [31:0] pc;
    output reg [31:0] instruction; 

    parameter INS_MEM_SIZE = 4096;
    
    reg [31:0] instruction_memory [0:INS_MEM_SIZE-1];
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < INS_MEM_SIZE; i = i + 1) begin
                instruction_memory[i] = 32'b0;
            end
            $readmemb("instructions.mem", instruction_memory,0,3);
            instruction <= 32'h0;
        end else begin
            instruction <= instruction_memory[pc[13:2]];  
        end
    end

    integer j;

    initial begin
        $readmemb("instructions.mem", instruction_memory,0,3);
        $display("Loaded Instructions:");
        for (j = 0; j < 4; j = j + 1) begin
            $display("Instruction %0d: %b", j, instruction_memory[j]);
        end
    end

endmodule
