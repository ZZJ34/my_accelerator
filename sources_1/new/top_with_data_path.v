`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/01 09:40:49
// Design Name: 
// Module Name: top_with_data_path
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


module top_with_data_path(
    input clk,           // 时钟
    input rst_n,         // 复位
    input is_start,      // 开始执行

    // regfile_InexRecur 的随机写端口
    input        ran_we_InexRecur_1,
    input [11:0] ran_w_addr_InexRecur_1,
    input [31:0] ran_w_data_InexRecur_1,
    // regfile_state 的随机写端口
    input        ran_we_state_external_1,
    input [11:0] ran_w_addr_state_external_1,
    input [17:0] ran_w_data_state_external_1,


    // regfile_InexRecur 的随机写端口
    input        ran_we_InexRecur_2,
    input [11:0] ran_w_addr_InexRecur_2,
    input [31:0] ran_w_data_InexRecur_2,
    // regfile_state 的随机写端口
    input        ran_we_state_external_2,
    input [11:0] ran_w_addr_state_external_2,
    input [17:0] ran_w_data_state_external_2,


    // regfile_InexRecur 的随机写端口
    input        ran_we_InexRecur_3,
    input [11:0] ran_w_addr_InexRecur_3,
    input [31:0] ran_w_data_InexRecur_3,
    // regfile_state 的随机写端口
    input        ran_we_state_external_3,
    input [11:0] ran_w_addr_state_external_3,
    input [17:0] ran_w_data_state_external_3,


    // regfile_InexRecur 的随机写端口
    input        ran_we_InexRecur_4,
    input [11:0] ran_w_addr_InexRecur_4,
    input [31:0] ran_w_data_InexRecur_4,
    // regfile_state 的随机写端口
    input        ran_we_state_external_4,
    input [11:0] ran_w_addr_state_external_4,
    input [17:0] ran_w_data_state_external_4
    );

    // path_1
    wire ce_rom_Occ_1;
    wire [7:0] addr_rom_Occ_1;
    
    wire [31:0] data_Occ_1; 
    wire        data_Occ_valid_1;

    // path_2
    wire ce_rom_Occ_2;
    wire [7:0] addr_rom_Occ_2;
    
    wire [31:0] data_Occ_2; 
    wire        data_Occ_valid_2;

    // path_3
    wire ce_rom_Occ_3;
    wire [7:0] addr_rom_Occ_3;
    
    wire [31:0] data_Occ_3; 
    wire        data_Occ_valid_3;

    // path_4
    wire ce_rom_Occ_4;
    wire [7:0] addr_rom_Occ_4;
    
    wire [31:0] data_Occ_4; 
    wire        data_Occ_valid_4;


    accelerator_top_1 accelerator_top_inst_1(
        .clk(clk),             // 时钟
        .rst_n(rst_n),         // 复位
        .is_start(is_start),   // 开始执行
        // rom_Occ
        .ce_rom_Occ_o(ce_rom_Occ_1),
        .addr_rom_Occ_o(addr_rom_Occ_1),
        .data_Occ_i(data_Occ_1),
        .data_Occ_valid_i(data_Occ_valid_1),
        // regfile_InexRecur 的随机写端口
        .ran_we_InexRecur(ran_we_InexRecur_1),
        .ran_w_addr_InexRecur(ran_w_addr_InexRecur_1),
        .ran_w_data_InexRecur(ran_w_data_InexRecur_1),
        // regfile_state 的随机写端口
        .ran_we_state_external(ran_we_state_external_1),
        .ran_w_addr_state_external(ran_w_addr_state_external_1),
        .ran_w_data_state_external(ran_w_data_state_external_1)
    );

    accelerator_top_2 accelerator_top_inst_2(
        .clk(clk),             // 时钟
        .rst_n(rst_n),         // 复位
        .is_start(is_start),   // 开始执行
        // rom_Occ
        .ce_rom_Occ_o(ce_rom_Occ_2),
        .addr_rom_Occ_o(addr_rom_Occ_2),
        .data_Occ_i(data_Occ_2),
        .data_Occ_valid_i(data_Occ_valid_2),
        // regfile_InexRecur 的随机写端口
        .ran_we_InexRecur(ran_we_InexRecur_2),
        .ran_w_addr_InexRecur(ran_w_addr_InexRecur_2),
        .ran_w_data_InexRecur(ran_w_data_InexRecur_2),
        // regfile_state 的随机写端口
        .ran_we_state_external(ran_we_state_external_2),
        .ran_w_addr_state_external(ran_w_addr_state_external_2),
        .ran_w_data_state_external(ran_w_data_state_external_2)
    );

    accelerator_top_3 accelerator_top_inst_3(
        .clk(clk),             // 时钟
        .rst_n(rst_n),         // 复位
        .is_start(is_start),   // 开始执行
        // rom_Occ
        .ce_rom_Occ_o(ce_rom_Occ_3),
        .addr_rom_Occ_o(addr_rom_Occ_3),
        .data_Occ_i(data_Occ_3),
        .data_Occ_valid_i(data_Occ_valid_3),
        // regfile_InexRecur 的随机写端口
        .ran_we_InexRecur(ran_we_InexRecur_3),
        .ran_w_addr_InexRecur(ran_w_addr_InexRecur_3),
        .ran_w_data_InexRecur(ran_w_data_InexRecur_3),
        // regfile_state 的随机写端口
        .ran_we_state_external(ran_we_state_external_3),
        .ran_w_addr_state_external(ran_w_addr_state_external_3),
        .ran_w_data_state_external(ran_w_data_state_external_3)
    );

    accelerator_top_4 accelerator_top_inst_4(
        .clk(clk),             // 时钟
        .rst_n(rst_n),         // 复位
        .is_start(is_start),   // 开始执行
        // rom_Occ
        .ce_rom_Occ_o(ce_rom_Occ_4),
        .addr_rom_Occ_o(addr_rom_Occ_4),
        .data_Occ_i(data_Occ_4),
        .data_Occ_valid_i(data_Occ_valid_4),
        // regfile_InexRecur 的随机写端口
        .ran_we_InexRecur(ran_we_InexRecur_4),
        .ran_w_addr_InexRecur(ran_w_addr_InexRecur_4),
        .ran_w_data_InexRecur(ran_w_data_InexRecur_4),
        // regfile_state 的随机写端口
        .ran_we_state_external(ran_we_state_external_4),
        .ran_w_addr_state_external(ran_w_addr_state_external_4),
        .ran_w_data_state_external(ran_w_data_state_external_4)
    );


    data_path data_path_inst(
        .clk(clk),
        .rst_n(rst_n),
    
        .storage_ce_1(ce_rom_Occ_1),
        .storage_addr_1(addr_rom_Occ_1),

        .storage_ce_2(ce_rom_Occ_2),
        .storage_addr_2(addr_rom_Occ_2),

        .storage_ce_3(ce_rom_Occ_3),
        .storage_addr_3(addr_rom_Occ_3),

        .storage_ce_4(ce_rom_Occ_4),
        .storage_addr_4(addr_rom_Occ_4),


        .data_to_alu_1(data_Occ_1),
        .done_1(data_Occ_valid_1),

        .data_to_alu_2(data_Occ_2),
        .done_2(data_Occ_valid_2),

        .data_to_alu_3(data_Occ_3),
        .done_3(data_Occ_valid_3),

        .data_to_alu_4(data_Occ_4),
        .done_4(data_Occ_valid_4)
    );
endmodule
