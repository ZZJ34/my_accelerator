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
    
    // regfile_InexRecur 顺序取值
    input [31:0] wdata_reg_InexRecur_seq,
    output reg   we_reg_InexRecur_seq,

    // regfile_state 顺序取值
    input [16:0] wdata_reg_state_seq,
    output reg   we_reg_state,

    // 给下一个模块的输出
    // 四个参数
    output reg [7:0] i_out,
    output reg [7:0] z_out,
    output reg [7:0] k_out,
    output reg [7:0] l_out,

    // 执行位置
    output reg [3:0] position,

    // 当前输出是否有效
    output reg is_valid,
    
    // 当前输出是否已经完成(用于控制状态)
    output current_finish
    );
    
    reg [11:0] position;
    reg current_finish;
    
    always @(*) begin
        // 初始化
        if(!rst_n) begin
            is_valid <= 0;
            current_finish <= 0;
            i_out <= 0;
            z_out <= 0;
            k_out <= 0;
            l_out <= 0;
            we_reg_InexRecur <= 1;
            we_reg_state <= 1;
            position <= 0;
        end
    end
endmodule
