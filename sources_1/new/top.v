`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/12 08:45:01
// Design Name: 
// Module Name: top
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


module top(
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
    
    // rom_C
    wire ce_rom_C;
    wire [1:0] addr_rom_C;
    wire [7:0] data_C;

    // rom_Occ
    wire ce_rom_Occ;
    wire [7:0] addr_rom_Occ;
    
    wire [31:0] data_Occ; 
    wire        data_Occ_valid;                


    accelerator_top accelerator_top_inst(
        .clk(clk),             // 时钟
        .rst_n(rst_n),         // 复位
        .is_start(is_start),   // 开始执行
        // rom_C
        .ce_rom_C_o(ce_rom_C),
        .addr_rom_C_o(addr_rom_C),
        .data_C_i(data_C),
        // rom_Occ
        .ce_rom_Occ_o(ce_rom_Occ),
        .addr_rom_Occ_o(addr_rom_Occ),
        .data_Occ_i(data_Occ),
        .data_Occ_valid_i(data_Occ_valid),
        // regfile_InexRecur 的随机写端口
        .ran_we_InexRecur(ran_we_InexRecur),
        .ran_w_addr_InexRecur(ran_w_addr_InexRecur),
        .ran_w_data_InexRecur(ran_w_data_InexRecur),
        // regfile_state 的随机写端口
        .ran_we_state_external(ran_we_state_external),
        .ran_w_addr_state_external(ran_w_addr_state_external),
        .ran_w_data_state_external(ran_w_data_state_external)
    );

    rom_C rom_C_inst(
        .ce(ce_rom_C),
        .symbol(addr_rom_C),
        .data(data_C)
    );

    rom_Occ rom_Occ_inst(
        .ce(ce_rom_Occ),
        .addr(addr_rom_Occ),
        .data(data_Occ),
        .valid(data_Occ_valid)
    );
endmodule
