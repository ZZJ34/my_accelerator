`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 15:22:02
// Design Name: 
// Module Name: test_regfile_InexRecur
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


module test_regfile_InexRecur(
    );
    reg clk;
    reg rst_n;

    reg we;
    reg [31:0] w_data;

    reg seq_re;

    reg ran_re;
    reg [11:0] ran_r_addr;

    wire [31:0] out_r_data;
    wire [11:0] out_r_addr;

    initial begin
        clk = 0;
        rst_n = 0;
        we = 0;
        seq_re = 0;
        ran_re = 0;
        #10
        rst_n = 1;
        #10
        we = 1;
        w_data = 32'h02_01_00_06;
        #10
        we = 0;
        seq_re =1;
        #10
        we = 1;
        seq_re = 0;
        w_data = 32'h01_00_00_06;
        #10
        we = 0;
        seq_re =1;
        #10
        we = 1;
        seq_re = 0;
        w_data = 32'h02_00_06_06;
        #10
        seq_re =1;
        we = 0;
        #10
        seq_re = 0;
        #10
        seq_re = 1;
        #10
        seq_re = 0;
        #20
        ran_re = 1;
        ran_r_addr = 2;
        #20
        ran_r_addr = 1;
        #20
        ran_r_addr = 0;
        #20
        ran_r_addr = 4;
        #20
        ran_re = 0;

    end

    always #5 clk = ~clk;

    regfile_InexRecur regfile_InexRecur_inst(
        .clk(clk), 
        .rst_n(rst_n), 
        
        .we(we),
        .w_data(w_data),

        .seq_re(seq_re),

        .ran_re(ran_re),
        .ran_r_addr(ran_r_addr),

        .out_r_addr(out_r_addr),
        .out_r_data(out_r_data)
    );
endmodule
