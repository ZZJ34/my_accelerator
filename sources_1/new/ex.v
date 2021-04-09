`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/09 16:27:33
// Design Name: 执行
// Module Name: ex
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:
//             根据 postion ，判断接下来的执行 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ex(
    input rst_n,              // 复位

    // 来自上一个模块的输出
    input [4:0] position_in,
    input [11:0] addr_in,
    input [7:0] i_in,
    input [7:0] z_in,
    input [7:0] k_in,
    input [7:0] l_in,
    input [7:0] d_i_in,
    input [1:0] read_i_in,
    input [7:0] data_1_in,
    input [7:0] data_2_in,
    input [7:0] C_in,

    // 该模块输出
    );

endmodule
