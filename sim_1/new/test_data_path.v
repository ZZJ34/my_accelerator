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

    initial begin
        storage_addr_1 <= 8'hff;
        storage_addr_2 <= 8'h02;
        storage_addr_3 <= 8'h03;
        storage_addr_4 <= 8'h04;
        rst_n = 0;
        clk = 0;
        storage_ce_1 = 0;
        storage_ce_2 = 0;
        storage_ce_3 = 0;
        storage_ce_4 = 0;

        #20
        rst_n = 1;

        #20
        storage_ce_1 = 1;
        storage_ce_2 = 1;
        storage_ce_3 = 1;
        storage_ce_4 = 1;

        #100
        storage_ce_1 = 1;
        storage_ce_2 = 0;
        storage_ce_3 = 0;
        storage_ce_4 = 0;
        storage_addr_1 <= 8'h06;

        #20
        storage_ce_1 = 0;

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
        .storage_addr_4(storage_addr_4)

    );
endmodule
