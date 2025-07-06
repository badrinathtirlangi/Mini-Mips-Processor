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

module data_memory(clk,rst,addr,mem_read,read_data,mem_write,write_data);
    input  clk;
    input  rst;     
    input  [31:0] addr;        
    input  [31:0] write_data; 
    input  mem_read;           
    input  mem_write;          
    output reg [31:0] read_data;

    parameter DATA_MEM_SIZE = 4096;
    
    reg [31:0] data_mem [DATA_MEM_SIZE-1:0];
    integer i;

    initial begin
        data_mem[0] = 32'h00000010;
        data_mem[4] = 32'h00000020; 
        data_mem[8] = 32'h00000030; 
    end
    
    always @(posedge clk or posedge rst) begin
    if (rst) begin
        for (i = 0; i < DATA_MEM_SIZE; i = i + 1) begin
            data_mem[i] <= 32'h0;
        end
        read_data <= 32'h0;
    end 
    else begin
        if (mem_write) begin
            $display("Writing to address: %h, Data: %h", addr, write_data);
            data_mem[addr[13:2]] <= write_data;
        end
        else if (mem_read) begin
            $display("Reading from address: %h, Data: %h", addr, read_data);
            read_data <= data_mem[addr[13:2]];
        end
        else begin
            read_data <= 32'h0;
        end
    end
end

endmodule 