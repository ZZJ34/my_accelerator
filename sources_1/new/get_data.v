`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/09 08:36:15
// Design Name: 取数据
// Module Name: get_data
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//            根据 get_param 模块传送的参数（i，z，k，l）从 rom 取出对应的数据
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "config.v"
module get_data(
    input rst_n,               // 复位信号

    input [2:0] en_get_param,  // 该模块使能

    // 四个参数
    input [7:0] i_in,
    input [7:0] z_in,
    input [7:0] k_in,
    input [7:0] l_in,
    
    // 当前参数地址
    input [11:0] addr,

    // 当前参数执行位置
    input [3:0] position,

    // rom 存储器的使能信号
    output reg ce_rom_C,
    output reg ce_rom_Occ,
    output reg ce_rom_read_and_D,

    // rom 存储器的地址
    output reg [1:0] addr_rom_C,
    output reg [7:0] addr1_rom_Occ,
    output reg [7:0] addr2_rom_Occ,
    output reg [7:0] addr_rom_read_and_D,
    
    // 存储器数据输入
    input [7:0] d_i,             // rom_read_and_D
    input [1:0] read_i,          // rom_read_and_D
    input [31:0] data_1,         // rom_Occ
    input [31:0] data_2,         // rom_Occ
    input [31:0] data            // rom_C
    
    // 输出给下一个模块的数据
    output reg [3:0] position_out,
    output reg [11:0] addr_out,
    output reg [7:0] i_out,
    output reg [7:0] z_out,
    output reg [7:0] k_out,
    output reg [7:0] l_out,
    output reg [7:0] d_i_out,            
    output reg [1:0] read_i_out,          
    output reg [31:0] data_1,         
    output reg [31:0] data_2,         
    output reg [31:0] C_out            
    );
endmodule
