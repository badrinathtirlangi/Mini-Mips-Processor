// IITK-Mini-MIPS Floating Point ALU Module
// Author: [Your Name]
// Roll No: [Your Roll No]

module fpalu(
    input wire [31:0] operand1,    // First floating-point operand
    input wire [31:0] operand2,    // Second floating-point operand
    input wire [3:0] fp_op,        // Floating-point operation
    output reg [31:0] result,      // FPALU result
    output reg invalid_op,         // Invalid operation flag
    output reg overflow,           // Overflow flag
    output reg underflow           // Underflow flag
);

    // IEEE 754 single precision format parameters
    localparam EXP_WIDTH = 8;
    localparam MANT_WIDTH = 23;
    localparam BIAS = 127;

    // Floating-point operation codes
    localparam FP_ADD = 4'b0000;
    localparam FP_SUB = 4'b0001;
    localparam FP_MUL = 4'b0010;
    localparam FP_DIV = 4'b0011;
    localparam FP_SQRT = 4'b0100;
    localparam FP_CMP = 4'b0101;

    // Internal signals
    reg [EXP_WIDTH-1:0] exp1, exp2, exp_result;
    reg [MANT_WIDTH:0] mant1, mant2, mant_result;
    reg sign1, sign2, sign_result;
    reg [31:0] temp_result;

    // Extract FP components
    task extract_fp;
        input [31:0] fp_num;
        output [EXP_WIDTH-1:0] exp;
        output [MANT_WIDTH:0] mant;
        output sign;
        begin
            sign = fp_num[31];
            exp = fp_num[30:23];
            mant = {1'b1, fp_num[22:0]};
        end
    endtask

    // Pack FP components
    function [31:0] pack_fp;
        input [EXP_WIDTH-1:0] exp;
        input [MANT_WIDTH:0] mant;
        input sign;
        begin
            pack_fp = {sign, exp, mant[MANT_WIDTH-1:0]};
        end
    endfunction

    // FPALU operation
    always @(*) begin
        // Default outputs
        result = 32'h0;
        invalid_op = 1'b0;
        overflow = 1'b0;
        underflow = 1'b0;

        // Extract components
        extract_fp(operand1, exp1, mant1, sign1);
        extract_fp(operand2, exp2, mant2, sign2);

        case (fp_op)
            FP_ADD: begin
                // Align exponents
                if (exp1 > exp2) begin
                    mant2 = mant2 >> (exp1 - exp2);
                    exp_result = exp1;
                end else begin
                    mant1 = mant1 >> (exp2 - exp1);
                    exp_result = exp2;
                end

                // Add mantissas
                if (sign1 == sign2) begin
                    mant_result = mant1 + mant2;
                    sign_result = sign1;
                end else begin
                    if (mant1 >= mant2) begin
                        mant_result = mant1 - mant2;
                        sign_result = sign1;
                    end else begin
                        mant_result = mant2 - mant1;
                        sign_result = sign2;
                    end
                end

                // Normalize result
                if (mant_result[MANT_WIDTH+1]) begin
                    mant_result = mant_result >> 1;
                    exp_result = exp_result + 1;
                end

                // Check for overflow/underflow
                if (exp_result > BIAS + 127) begin
                    overflow = 1'b1;
                    result = {sign_result, 8'hFF, 23'h0};
                end else if (exp_result < BIAS - 126) begin
                    underflow = 1'b1;
                    result = 32'h0;
                end else begin
                    result = pack_fp(exp_result, mant_result, sign_result);
                end
            end

            FP_MUL: begin
                // Multiply mantissas
                mant_result = mant1 * mant2;
                exp_result = exp1 + exp2 - BIAS;
                sign_result = sign1 ^ sign2;

                // Normalize result
                if (mant_result[MANT_WIDTH+1]) begin
                    mant_result = mant_result >> 1;
                    exp_result = exp_result + 1;
                end

                // Check for overflow/underflow
                if (exp_result > BIAS + 127) begin
                    overflow = 1'b1;
                    result = {sign_result, 8'hFF, 23'h0};
                end else if (exp_result < BIAS - 126) begin
                    underflow = 1'b1;
                    result = 32'h0;
                end else begin
                    result = pack_fp(exp_result, mant_result, sign_result);
                end
            end

            FP_CMP: begin
                // Compare floating-point numbers
                if (exp1 > exp2) begin
                    result = 32'h1;
                end else if (exp1 < exp2) begin
                    result = 32'hFFFFFFFF;
                end else begin
                    if (mant1 > mant2) begin
                        result = 32'h1;
                    end else if (mant1 < mant2) begin
                        result = 32'hFFFFFFFF;
                    end else begin
                        result = 32'h0;
                    end
                end
            end

            default: begin
                invalid_op = 1'b1;
                result = 32'h0;
            end
        endcase
    end

endmodule 