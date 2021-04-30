`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 20:06:45
// Design Name: 
// Module Name: test_data_path
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


module test_data_path(

    );
    reg rst_n;
    reg clk;

    reg storage_ce_1;
    reg [7:0] storage_addr_1;

    reg storage_ce_2;
    reg [7:0] storage_addr_2;

    reg storage_ce_3;
    reg [7:0] storage_addr_3;

    reg storage_ce_4;
    reg [7:0] storage_addr_4;

    reg rd_en;
    wire [11:0] data_out;
    wire        full;
    wire        empty;


    initial begin
        storage_addr_1 <= 8'haa;
        storage_addr_2 <= 8'hbb;
        storage_addr_3 <= 8'hcc;
        storage_addr_4 <= 8'hdd;
        rst_n = 0;
        clk = 0;
        storage_ce_1 = 0;
        storage_ce_2 = 0;
        storage_ce_3 = 0;
        storage_ce_4 = 0;

        rd_en = 0;

        #20
        rst_n = 1;

        #20
        storage_ce_1 = 1;
        storage_ce_2 = 1;
        storage_ce_3 = 1;
        storage_ce_4 = 1;

        #150
        rd_en = 1;

    end

    always #5 clk = ~ clk;

    data_path data_path_inst(
        .rst_n(rst_n),
        .clk(clk),

        .storage_ce_1(storage_ce_1),
        .storage_addr_1(storage_addr_1),

        .storage_ce_2(storage_ce_2),
        .storage_addr_2(storage_addr_2),

        .storage_ce_3(storage_ce_3),
        .storage_addr_3(storage_addr_3),

        .storage_ce_4(storage_ce_4),
        .storage_addr_4(storage_addr_4),


        // 测试端口
        .rd_en_test(rd_en),
        .data_out_test(data_out),
        .full_test(full),
        .empty_test(empty)
    );
endmodule
