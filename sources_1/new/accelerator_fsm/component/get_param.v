`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 15:55:38
// Design Name: 取参数
// Module Name: get_param
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//           该模块为状态机
//           1.当前参数（i，z，k，l）尚未完成，直接取出
//           2.当前参数（i，z，k，l）已经完成调用则回溯，直到回溯到未完成调用的参数（i，z，k，l）
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
    input clk,                                // 时钟信号
    input rst_n,                              // 复位信号
    
    input [2:0] en_get_param,                 // 该模块使能
    
    // regfile_InexRecur 
    output reg re_reg_InexRecur_seq_o,          // regfile_InexRecur 顺序读使能
    output reg re_reg_InexRecur_ran_o,          // regfile_InexRecur 随机读使能
    output reg [11:0] r_reg_InexRecur_addr_o,   // regfile_InexRecur 随机读地址
    input [11:0] InexRecur_addr_i,              // regfile_InexRecur 当前地址 
    input [31:0] InexRecur_data_i,              // regfile_InexRecur 当前数据

    // regfile_state    
    output reg re_reg_state_seq_o,              // regfile_state 顺序读使能
    output reg re_reg_state_ran_o,              // regfile_state 随机读使能
    output reg [11:0] r_reg_state_addr_o,       // regfile_state 随机读地址
    input [11:0] state_addr_i,                  // regfile_state 当前地址（ InexRecur 和 state 的数据一一对应，知道一个当前地址即可）
    input [17:0] state_data_i,                  // regfile_state 当前数据

    // 给下一个模块的输出
    // 四个参数
    output reg [7:0] i_out,
    output reg [7:0] z_out,
    output reg [7:0] k_out,
    output reg [7:0] l_out,
    
    // 当前参数地址
    output reg [11:0] addr,

    // 当前参数执行位置
    output reg [4:0] position,
    
    // 是否找到未执行完成的参数
    output reg is_find
    );

    localparam NOW = 1'b0;       // 读取当前参数（顺序读）
    localparam GO_BACK = 1'b1;   // 读取以前的参数（随机读）

    reg state, next_state;


    // 状态控制
    always @(posedge clk) begin
        if(!rst_n) 
            state <= NOW;
        else if(!(en_get_param == 3'b001))
            state <= NOW;
        else begin
            state <= next_state;
            // 保存回溯的地址
            r_reg_InexRecur_addr_o <= state_data_i [12:1];
            r_reg_state_addr_o <= state_data_i [12:1];
        end
    end

    always @(*) begin
        if(!rst_n) 
            next_state <= NOW;
        else if(!(en_get_param == 3'b001))
            next_state <= NOW;
        else
            next_state <= state_data_i [0] ? GO_BACK : NOW;
    end

    always @(*) begin
        if(!rst_n) begin
            // 复位状态为 NOW
            re_reg_InexRecur_seq_o <= 1;
            re_reg_InexRecur_ran_o <= 0;
            r_reg_InexRecur_addr_o <= 0;

            re_reg_state_seq_o <= 1;         
            re_reg_state_ran_o <= 0;              
            r_reg_state_addr_o <= 0;

            i_out <= 0;
            z_out <= 0;
            k_out <= 0;
            l_out <= 0;
            addr <= 0;
            position <= 0;
            
            is_find <= 0;

        end
        else begin
            if(en_get_param == 3'b001) begin
                is_find <= ~(state_data_i[0]);  // 结束标志 over 为 1，则回溯；为 0 则传递

                position <= state_data_i [17:13];

                i_out <= InexRecur_data_i [31:24];
                z_out <= InexRecur_data_i [23:16];
                k_out <= InexRecur_data_i [15:8];
                l_out <= InexRecur_data_i [7:0];


                addr <= InexRecur_addr_i;

                if(state == NOW) begin
                    re_reg_InexRecur_seq_o <= 1;
                    re_reg_state_seq_o <= 1;
                    re_reg_InexRecur_ran_o <= 0;
                    re_reg_state_ran_o <= 0;
                end

                if(state == GO_BACK) begin
                    re_reg_InexRecur_seq_o <= 0;
                    re_reg_state_seq_o <= 0;
                    re_reg_InexRecur_ran_o <= 1;
                    re_reg_state_ran_o <= 1;
                end

            end
        end
        
    end

    
    
    
    
endmodule
