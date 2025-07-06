`include "instruction_formats.v"

module iitk_mini_mips(
    input wire clk,                
    input wire rst,
    output [31:0] pc_out,
    output [31:0] instruction_out,
    output [31:0] rs_out,
    output [31:0] rt_out,
    output [31:0] rd_out
);

    // Internal signals
    wire [5:0] opcode;
    wire [5:0] funct;
    wire [4:0] rs, rt, rd, shamt;
    wire [15:0] immediate;
    wire [31:0] branch_addr;
    wire [31:0] jump_addr;
    wire [31:0] alu_result;
    wire [3:0] alu_op;
    wire reg_write, mem_to_reg, alu_src, branch, jump, mem_read, mem_write;
    wire [31:0] pc,instruction;
    wire zero,overflow;
    wire [31:0] operand1,operand2,read_data_2;
    wire [31:0] read_mem_data;
    wire [31:0] write_reg_data;


    // Instruction fetch
    instruction_fetch fetch(
        .clk(clk),
        .rst(rst),
        .branch_taken(branch),
        .branch_addr(branch_addr),
        .jump(jump),
        .jump_addr(jump_addr),
        .pc(pc),
        .instruction(instruction)
    );
    assign pc_out = pc;
    assign instruction_out = instruction;
    assign rs_out = operand1;
    assign rt_out = operand2;
    assign rd_out = write_reg_data;

    // register file
    registers register(
        .clk(clk),
        .rst(rst),
        .write_enable(reg_write),
        .read_register_1(rs),
        .read_register_2(rt),
        .write_register(rd),
        .write_data(write_reg_data),
        .read_data_1(operand1),
        .read_data_2(read_data_2)
    );
    // Instruction Decode
    instruction_decode decode(
        .instruction(instruction),
        .pc(pc),
        .rs_addr(rs),
        .rt_addr(rt),
        .rd_addr(rd),
        .shamt(shamt),
        .immediate(immediate),
        .branch_addr(branch_addr),
        .jump_addr(jump_addr),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .jump(jump),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .mem_to_reg(mem_to_reg)
    );

    assign operand2 = (alu_src == 0) ? read_data_2 : immediate;

    // ALU
    alu execute(
        .operand1(operand1),
        .operand2(operand2),
        .shamt(shamt),
        .Alu_control_input(alu_op),
        .zero(zero),
        .result(alu_result),
        .overflow(overflow)
    );

    // Data memory
    data_memory mem(
        .clk(clk),
        .rst(rst),
        .addr(alu_result),
        .write_data(read_data_2),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(read_mem_data)
    );

    assign write_reg_data = (mem_to_reg == 0) ? alu_result : read_mem_data;

endmodule 