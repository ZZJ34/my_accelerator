`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/11 10:17:49
// Design Name: 
// Module Name: test_regfile
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


module test_regfile(

    );

    reg clk;
    reg rst_n;

    reg seq_we;
    reg [7:0] seq_w_data;

    reg ran_we;
    reg [11:0] ran_w_addr;
    reg [7:0] ran_w_data;

    initial begin
        clk <= 0;
        rst_n <= 0;
        seq_we <= 0;
        seq_w_data <= 0;
        ran_we <= 0;
        ran_w_addr <= 0;
        ran_w_data <= 0;

        #15
        rst_n <= 1;

        #10
        seq_we <= 1;
        seq_w_data <= 8'b1111_0011;

        #10
        seq_w_data <= 8'b1001_1000;

        #10
        seq_w_data <= 8'b0011_1111;

        #10
        seq_we <= 0;

        #10
        ran_we <= 1;
        ran_w_addr <= 0;
        ran_w_data <= 8'bxxxx_0000;

        #10
        ran_w_addr <= 5;
        ran_w_data <= 8'b1010_0000;

        #10
        ran_w_addr <= 6;
        ran_w_data <= 8'b1010_0001;
    end

    always #5 clk = ~clk;

    regfile #(.DATA_WIDTH(8)) regfile_inst (
        .clk(clk),
        .rst_n(rst_n),
    
        // 顺序写
        .seq_we(seq_we),               // 顺序写使能
        .seq_w_data(seq_w_data),       // 顺序写数据

        // 随机写
        .ran_we(ran_we),                     // 随机写使能
        .ran_w_addr(ran_w_addr),             // 随机写读地址
        .ran_w_data(ran_w_data),             // 随机写数据

        // 支持顺序读和随机读
        .seq_re(1'b0),                       // 顺序读使能
        .seq_r_data(),                       // 顺序读数据
        .out_seq_r_addr(),                   // 顺序读数据的地址

        .ran_re(1'b0),                       // 随机读使能
        .ran_r_addr(),                       // 随机读地址
        .ran_r_data(),                       // 随机读数据
        .out_ran_r_addr()                    // 随机读数据的地址
    );
endmodule
