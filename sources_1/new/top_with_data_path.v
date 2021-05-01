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
    input        ran_we_InexRecur,
    input [11:0] ran_w_addr_InexRecur,
    input [31:0] ran_w_data_InexRecur,
    // regfile_state 的随机写端口
    input        ran_we_state_external,
    input [11:0] ran_w_addr_state_external,
    input [17:0] ran_w_data_state_external
    );

    // path_1
    wire ce_rom_Occ_1;
    wire [7:0] addr_rom_Occ_1;
    
    wire [31:0] data_Occ_1; 
    wire        data_Occ_valid_1;  


    accelerator_top accelerator_top_inst(
        .clk(clk),             // 时钟
        .rst_n(rst_n),         // 复位
        .is_start(is_start),   // 开始执行
        // rom_Occ
        .ce_rom_Occ_o(ce_rom_Occ_1),
        .addr_rom_Occ_o(addr_rom_Occ_1),
        .data_Occ_i(data_Occ_1),
        .data_Occ_valid_i(data_Occ_valid_1),
        // regfile_InexRecur 的随机写端口
        .ran_we_InexRecur(ran_we_InexRecur),
        .ran_w_addr_InexRecur(ran_w_addr_InexRecur),
        .ran_w_data_InexRecur(ran_w_data_InexRecur),
        // regfile_state 的随机写端口
        .ran_we_state_external(ran_we_state_external),
        .ran_w_addr_state_external(ran_w_addr_state_external),
        .ran_w_data_state_external(ran_w_data_state_external)
    );


    data_path data_path_inst(
        .clk(clk),
        .rst_n(rst_n),
    
        .storage_ce_1(ce_rom_Occ_1),
        .storage_addr_1(addr_rom_Occ_1),

        .storage_ce_2(0),
        .storage_addr_2(),

        .storage_ce_3(0),
        .storage_addr_3(),

        .storage_ce_4(0),
        .storage_addr_4(),


        .data_to_alu_1(data_Occ_1),
        .done_1(data_Occ_valid_1),

        .data_to_alu_2(),
        .done_2(),

        .data_to_alu_3(),
        .done_3(),

        .data_to_alu_4(),
        .done_4()
    );
endmodule
