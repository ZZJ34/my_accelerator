`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/11 09:16:51
// Design Name: 回写
// Module Name: write_back
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//           根据 ex 的输出结果，保存数据
//           1.无新的调用 仅仅更新当前调用的执行位置 （state）
//           2.有新的调用 同时更新当前调用的执行位置 （state，InexRecur）
//           3.更新结束标志位 （state）
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module write_back(
    input rst_n,               // 复位

    input [2:0] en_write_back, // 该模块使能

    // 上一个模块的输出
    input [11:0] current_addr_i,
    input [7:0] current_k_i,
    input [7:0] current_l_i,
    
    input over_1_i,               // 条件1中止   z < D(i)    “1”有效
    input over_2_i,               // 条件2中止   i < 0       “1”有效
    input over_3_i,               // 条件3中止   本次调用完成 “1”有效

    input en_new_position_i,      // 是否更新当前参数执行位置    “1”有效
    input [4:0] new_position_i,   // 新的执行位置

    input new_call_i,             // 调用新的循环   “1”有效
    input [7:0] i_new_i,         
    input [7:0] z_new_i,
    input [7:0] k_new_i,
    input [7:0] l_new_i,
   
    // 输出
    output reg seq_we_state,
    output reg seq_we_InexRecur,

    output reg [17:0] seq_w_data_state,
    output reg [31:0] seq_w_data_InexRecur,

    output reg ran_we_state,
    output reg ran_we_InexRecur,               

    output reg [17:0] ran_w_data_state,
    output reg [31:0] ran_w_data_InexRecur,    

    output reg [11:0] ran_w_addr_state,
    output reg [11:0] ran_w_addr_InexRecur     
    );

    always @(*) begin
        if(!rst_n) begin
            seq_we_state <= 0;
            seq_we_InexRecur <= 0;
            seq_w_data_state <= 0;
            seq_w_data_InexRecur <= 0;
            ran_we_state <= 0;
            ran_we_InexRecur <= 0;
            ran_w_data_state <= 0;
            ran_w_data_InexRecur <= 0;
            ran_w_addr_state <= 0;
            ran_w_addr_InexRecur <= 0;
        end
        else if(en_write_back == 3'b110) begin
            // 尽在当前模块使能时，输出有效的寄存器写信号

            // 这里区分一下两种不同的结束状态
            if(over_1_i) begin
                ran_we_state <= 1;
                ran_w_data_state <= 18'bx_xxxx_xxxx_xxxx_xxxx_1;
                ran_w_addr_state <= current_addr_i;
            end

            if(over_2_i) begin
                ran_we_state <= 1;
                ran_w_data_state <= 18'bx_xxxx_xxxx_xxxx_xxxx_1;
                ran_w_addr_state <= current_addr_i;
            end

            if(over_3_i) begin
                ran_we_state <= 1;
                ran_w_data_state <= 18'bx_xxxx_xxxx_xxxx_xxxx_1;
                ran_w_addr_state <= current_addr_i;
            end

            if(en_new_position_i) begin
                ran_we_state <= 1;
                ran_w_data_state <= { new_position_i, 13'bx };
                ran_w_addr_state <= current_addr_i;
            end

            if(new_call_i) begin
                seq_we_InexRecur <= 1;
                seq_w_data_InexRecur <= { i_new_i, z_new_i, k_new_i, l_new_i};
                seq_we_state <= 1;
                seq_w_data_state <= { 5'b0_0000, current_addr_i, 1'b0 };
            end
            
        end
        else begin
            seq_we_state <= 0;
            seq_we_InexRecur <= 0;
            ran_we_state <= 0;
            ran_we_InexRecur <= 0;
        end
    end
endmodule
