`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/07/2025 02:20:53 PM
// Design Name: 
// Module Name: registers
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


module registers(read_register_1,read_register_2,write_enable,write_register,write_data,read_data_1,read_data_2,clk,rst);
    input [4:0] read_register_1,read_register_2,write_register;
    input write_enable,clk,rst;
    input [31:0]write_data;
    output reg [31:0] read_data_1,read_data_2;
    
    reg [31:0] general_registers [31:0];
    
    reg [31:0] pc;    
    reg [31:0] hi;        
    reg [31:0] lo;        
    
    reg [31:0] floating_registers [31:0];    

    reg [7:0] cc;
    integer i;
    reg initialized = 0;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                general_registers[i] <= 32'h0;
                floating_registers[i] <= 32'h0;
            end
            pc <= 32'h0;
            hi <= 32'h0;
            lo <= 32'h0;
            cc <= 8'h0;
            initialized <= 0;
        end else if (!initialized) begin
            // Initialize registers with predefined values once after reset is deasserted
            general_registers[0] <= 32'h00000010;   // Initialize register 0
            general_registers[9] <= 32'h00000020;   // Initialize register 9
            general_registers[10] <= 32'h00000030;  // Initialize register 10
            initialized <= 1; // Set the flag to prevent reinitialization
        end else begin
      
            if (write_enable && write_register != 0) begin
                general_registers[write_register] <= write_data;
                $display("Write enable: %b, Write register: %h, Write data: %h", write_enable, write_register, write_data);
            end
            read_data_1 <= (read_register_1 == 0) ? 32'h0 : general_registers[read_register_1];
            read_data_2 <= (read_register_2 == 0) ? 32'h0 : general_registers[read_register_2];
            $display("Reading registers: read_register_1: %h, read_register_2: %h", read_register_1, read_register_2);
            $display("read_data_1: %h, read_data_2: %h", read_data_1, read_data_2);

        end
    end
endmodule