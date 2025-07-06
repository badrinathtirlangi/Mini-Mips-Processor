`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2025 02:59:42 PM
// Design Name: 
// Module Name: Instruction_decode
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

`include "instruction_formats.v"

module instruction_decode(instruction,pc,rs_addr,rt_addr,rd_addr,shamt,immediate,branch_addr,jump_addr,reg_write,mem_read,mem_write,branch,jump,alu_src,alu_op,mem_to_reg); 
    input [31:0] instruction;
    input [31:0] pc;          
    output reg [4:0] rs_addr;      
    output reg [4:0] rt_addr;     
    output reg [4:0] rd_addr;    
    output reg [4:0] shamt;    
    output reg [15:0] immediate;    
    output reg [31:0] branch_addr;    
    output reg [31:0] jump_addr;   
    output reg reg_write;         
    output reg mem_read;            
    output reg mem_write;           
    output reg branch;              
    output reg jump;                
    output reg alu_src;             
    output reg [3:0] alu_op;        
    output reg mem_to_reg;

    // Instruction fields
    wire [5:0] opcode = instruction[31:26];
    wire [4:0] rs = instruction[25:21];
    wire [4:0] rt = instruction[20:16];
    wire [4:0] rd = instruction[15:11];
    wire [4:0] shamt1 = instruction[10:6];
    wire [5:0] funct = instruction[5:0];
    wire [15:0] imm = instruction[15:0];
    wire [25:0] addr = instruction[25:0];
    reg [31:0] pc_plus_4;

    // ALU operation codes
    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_AND = 4'b0010;
    localparam ALU_OR  = 4'b0011;
    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLL = 4'b0101;
    localparam ALU_SRL = 4'b0110;
    localparam ALU_SLA = 4'b0111;
    localparam ALU_SRA = 4'b1000;
    localparam ALU_SLT = 4'b1001;
    localparam ALU_MADD = 4'b1010;
    localparam ALU_MUL = 4'b1011;
    localparam ALU_NOT = 4'b1100;

    always @(*) begin
        alu_src <= 0;
        mem_to_reg <= 0;
        reg_write <= 0;
        mem_read <= 0;
        mem_write <= 0;
        branch <= 0;
        jump <= 0;
        alu_op <= ALU_ADD;

        rs_addr <= rs;
        rt_addr <= rt;
        rd_addr <= rd;
        shamt   <= shamt1;
        immediate <= imm;
        branch_addr <= 32'b0;
        jump_addr <= 32'b0;

        case(opcode)
            `OP_R_TYPE: begin
                $display("Opcode: %b, Funct: %b, rs: %d, rt: %d, rd: %d", opcode, funct, rs, rt, rd);
                rd_addr <= rd;
                reg_write <= 1;
                case(funct)
                    `FUNCT_ADD: begin
                        alu_op <= ALU_ADD;  
                    end
                    `FUNCT_SUB: begin
                        alu_op <= ALU_SUB;
                    end
                    `FUNCT_AND: begin
                        alu_op = ALU_AND; 
                    end
                    `FUNCT_OR: begin
                        alu_op <= ALU_OR; 
                    end
                    `FUNCT_XOR: begin
                        alu_op <= ALU_XOR; 
                    end
                    `FUNCT_SLL: begin
                        alu_op <= ALU_SLL;
                    end
                    `FUNCT_SRL: begin
                        alu_op <= ALU_SRL; 
                    end
                    `FUNCT_SLA: begin
                        alu_op <= ALU_SLA;
                    end
                    `FUNCT_SRA: begin
                        alu_op <= ALU_SRA; 
                    end
                    `FUNCT_SLT: begin
                        alu_op <= ALU_SLT; 
                    end
                    `FUNCT_MADD: begin
                        alu_op <= ALU_MADD; 
                    end
                    `FUNCT_MUL: begin
                        alu_op <= ALU_MUL; 
                    end
                    `FUNCT_NOT: begin
                        alu_op <= ALU_NOT; 
                    end
                    default: begin
                        alu_op <= ALU_ADD;
                    end
                endcase
            end

            `OP_LOAD_TYPE: begin
                $display("Opcode: %b, Funct: %b, rs: %d, rt: %d, rd: %d", opcode, funct, rs, rt, rd);
                rd_addr <= rt;
                reg_write <= 1;
                mem_read <= 1;
                mem_to_reg <= 1;
                alu_src <= 1;
                alu_op <= ALU_ADD;
            end

            `OP_STORE_TYPE: begin
                $display("Opcode: %b, Funct: %b, rs: %d, rt: %d, rd: %d", opcode, funct, rs, rt, rd);
                rd_addr <= rt;
                mem_write <= 1;
                alu_src <= 1;
                alu_op <= ALU_ADD;
            end

            `OP_BRANCH_TYPE: begin
                $display("Opcode: %b, Funct: %b, rs: %d, rt: %d, rd: %d", opcode, funct, rs, rt, rd);
                branch <= 1;
                alu_op <= ALU_SUB;
                branch_addr <= {{16{imm[15]}}, imm};
            end

           `OP_JUMP_TYPE: begin
                $display("Opcode: %h, Funct: %h, rs: %d, rt: %d, rd: %d", opcode, funct, rs, rt, rd);
                jump <= 1;
                pc_plus_4 <= pc + 4;
                jump_addr <= { pc_plus_4[31:28], addr, 2'b00 };
            end

            `OP_JAL_TYPE: begin
                $display("Opcode: %h, Funct: %h, rs: %d, rt: %d, rd: %d", opcode, funct, rs, rt, rd);
                jump <= 1;
                reg_write <= 1;
                rd_addr <= 5'b11111;  // $ra
                pc_plus_4 <= pc + 4;
                jump_addr <= { pc_plus_4[31:28], addr, 2'b00 };
            end


            default: begin
                $display("Opcode: %h, Funct: %h, rs: %d, rt: %d, rd: %d", opcode, funct, rs, rt, rd);
                reg_write <= 0;
                mem_read <= 0;
                mem_write <= 0;
                branch <= 0;
                jump <= 0;
                alu_src <= 0;
                alu_op <= ALU_ADD;
                mem_to_reg <= 0;
            end
        endcase
    end

endmodule 