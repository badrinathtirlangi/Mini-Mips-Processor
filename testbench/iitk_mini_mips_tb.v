module tb_iitk_mini_mips;

    reg clk;
    reg rst;

    iitk_mini_mips uut (
        .clk(clk),
        .rst(rst)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Reset and simulation control
    initial begin
        rst = 1;
        #10;
        rst = 0;

        #1000;
        $finish;
    end

    initial begin
        $monitor("Time: %0t | PC: %h | Instr: %h | rs: %h | rt: %h | rd: %h",
                 $time, uut.pc_out, uut.instruction_out, uut.rs_out, uut.rt_out, uut.rd_out);
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1, uut);
    end

endmodule
