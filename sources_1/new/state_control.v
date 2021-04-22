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
    input is_finish,                // 是否已完成所有迭代
    input is_start,                 // 是否开始开始
    input is_find,                  // 是否找到尚未完成的参数
    input is_get_data_in_Occ,       // 是否获取Occ中的数据
    output reg [2:0] state
    );
    
    // 定义状态
    localparam IDLE      = 3'b000;   // 空闲状态
    localparam GET_PARAM = 3'b001;   // 取参数      （存在对应执行模块）
    localparam GET_DATA_1= 3'b010;   // 取数据[C(i)、read(i)、D(i)]      （存在对应执行模块）
    localparam GET_DATA_2= 3'b011;   // 取数据[Occ]                      （存在对应执行模块）
    localparam GET_DATA_3= 3'b100;   // 取数据[Occ]                      （存在对应执行模块）
    localparam EX        = 3'b101;   // 判断/执行   （存在对应执行模块）
    localparam WRITE_BACK= 3'b110;   // 存数据      （存在对应执行模块）
    localparam DONE      = 3'b111;   // 遍历结束

    // reg stay_count;

    // 状态切换
    always @(posedge clk) begin
        if(!rst_n) begin
            state <= IDLE;
            // stay_count <= 0;
        end
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
                        state <= GET_DATA_1;
                    else
                        state <= GET_PARAM;
                end
                GET_DATA_1: begin
                    if(is_get_data_in_Occ)
                        state <= GET_DATA_2;
                    else
                        state <= EX;
                end
                GET_DATA_2: state <= GET_DATA_3;
                GET_DATA_3: state <= EX;
                EX        : state <= WRITE_BACK;
                WRITE_BACK: begin
                    // if( stay_count == 0) begin
                    //     state <= WRITE_BACK;
                    //     stay_count <= stay_count + 1;
                    // end
                    // else begin
                    //     state <= GET_PARAM;
                    //     stay_count <= 0;
                    // end
                    state <= GET_PARAM;
                end
                default: state <= state;
            endcase
        end
    end



endmodule
