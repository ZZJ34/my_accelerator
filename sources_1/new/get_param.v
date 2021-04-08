`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 15:55:38
// Design Name: 
// Module Name: get_param
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

`include "config.v"
module get_param(
    input rst_n,
    
    input en_get_param,
    
    // regfile_InexRecur 
    input [31:0] wdata_reg_InexRecur,
    output reg we_reg_InexRecur_seq,          // 顺序读使能
    output reg we_reg_InexRecur_ran,          // 随机读使能
    output reg [11:0] we_reg_InexRecur_addr,  // 随机读地址
    input [11:0] current_InexRecur_addr,      // 当前地址        

    // regfile_state 顺序取值
    input [16:0] wdata_reg_state,      
    output reg we_reg_state_seq,              // 顺序读使能
    output reg we_reg_state_ran,              // 随机读使能
    output reg [11:0] we_reg_state_addr,      // 随机读地址
    input [11:0] current_state_addr,          // 当前地址

    // 给下一个模块的输出
    // 四个参数
    output reg [7:0] i_out,
    output reg [7:0] z_out,
    output reg [7:0] k_out,
    output reg [7:0] l_out,
    
    // 当前参数地址
    output reg [11:0] addr,

    // 执行位置
    output reg [3:0] position,
    
    // 当前输出是否已经完成(用于控制状态)
    output current_finish
    );
    
    
    
    
endmodule
