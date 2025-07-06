module alu(
    input wire [31:0] operand1,  
    input wire [31:0] operand2,
    input wire [4:0] shamt, 
    input wire [3:0] Alu_control_input,  
    output reg zero,               
    output reg [31:0] result,
    output reg overflow
);

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

    reg [63:0] mul_result;
    reg [32:0] add_result;

    // ALU operation
    always @(*) begin
        result = 32'h0;
        zero = 1'b0;
        overflow = 1'b0;

        case (Alu_control_input)
             ALU_ADD: begin
                result = operand1 + operand2;
                overflow = ((operand1[31] == operand2[31]) && (result[31] != operand1[31]));
            end
            ALU_SUB: begin
                result = operand1 - operand2;
                overflow = ((operand1[31] != operand2[31]) && (result[31] != operand1[31]));
            end
            ALU_AND: result = operand1 & operand2;
            ALU_OR:  result = operand1 | operand2;
            ALU_XOR: result = operand1 ^ operand2;
            ALU_SLL: result = operand1 << shamt;
            ALU_SRL: result = operand1 >> shamt;
            ALU_SLA: result = $signed(operand1) <<< shamt;
            ALU_SRA: result = $signed(operand1) >>> shamt;
            ALU_SLT: result = ($signed(operand1) < $signed(operand2)) ? 32'h1 : 32'h0;
            ALU_MUL: begin
                mul_result = $signed(operand1) * $signed(operand2);
                result = mul_result[31:0];  // store lower 32-bits
            end
            ALU_MADD: begin
                mul_result = $signed(operand1) * $signed(operand2);
                result = mul_result[31:0] + operand1;  // just an example
            end
            ALU_NOT: result = ~operand1;
            default: result = 32'h0;
        endcase

        zero <= (result == 32'h0);
    end

endmodule 