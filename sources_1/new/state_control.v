`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 10:21:47
// Design Name: 
// Module Name: state_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//            一个大的状态机
//            负责状态控制，五个有效状态
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module state_control(
    input clk,
    input rst_n,
    input  is_finish,                // 是否已完成所有迭代
    input  is_start,                 // 是否开始开始
    input  is_find,                  // 是否找到尚未完成的参数
    output reg [2:0] state
    );
    
    // 定义状态
    localparam IDLE      = 3'b000;   // 空闲状态
    localparam GET_PARAM = 3'b001;   // 取参数      （存在对应执行模块）
    localparam GET_DATA  = 3'b010;   // 取数据      （存在对应执行模块）
    localparam EX        = 3'b011;   // 判断/执行   （存在对应执行模块）
    localparam WRIT_PRE  = 3'b100;   // 准备数据    （存在对应执行模块）
    localparam WRITE_BACK= 3'b101;   // 存数据      （存在对应执行模块）
    localparam DONE      = 3'b110;   // 遍历结束

    // 状态切换
    always @(posedge clk) begin
        if(!rst_n) 
            state <= IDLE;
        else if(is_finish)
            state <= DONE;
        else begin
            case (state)
                IDLE      : begin
                    if(is_start) 
                        state <= GET_PARAM;
                    else
                        state <= IDLE;
                end
                GET_PARAM : begin
                    if(is_find)
                        state <= GET_DATA;
                    else
                        state <= GET_PARAM;
                end
                GET_DATA  : state <= EX;
                EX        : state <= WRIT_PRE;
                WRIT_PRE  : state <= WRITE_BACK;
                WRITE_BACK: state <= GET_PARAM;
                default: state <= state;
            endcase
        end
    end

endmodule
