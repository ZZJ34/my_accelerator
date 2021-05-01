`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 18:49:59
// Design Name: 
// Module Name: storage_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 此模块用于处理器核心和存储读取，并接受仲裁器调度
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module storage_control#(
    
    CURRENT_NUMBER = 1,           // 两个编码的格式不相同，当前令牌的偏码格式请参考仲裁器
    CURRENT_GRANT  = 4'b0001     // 两个编码的格式不相同，当前令牌的偏码格式请参考仲裁器
)(  
    input rst_n,
    input clk,

    input             storage_ce,        // 存储器使能
    input      [7:0]  storage_addr,      // 读取地址
    output reg [11:0] number_and_addr,   // 编号+读取地址
    output reg        storage_valid,     // 当前有效

    input      [35:0] data_from_storage,      // 来自于存储器的数据
    output reg [31:0] data_to_alu,            // 输出给处理核心的数据

    
    input      [3:0] grant,        // 允许令牌
    output reg       req,          // 占用请求


    input  txn_done,           // 数据传输完成（来自存储器）
    output reg done                // 数据传输完成（给向处理器）

    );
    
    // 当前处理核心的唯一编号
    reg [3:0] current_number = CURRENT_NUMBER;

    // 当前处理核心对应的令牌
    reg [3:0] current_grant = CURRENT_GRANT;


    // 一个状态机
    // 控制发起请求、写入FIFO、等待数据返回、完成
    localparam IDLE = 3'b000,
               REQ  = 3'b001,
               WRITE_FIFO = 3'b010,
               WAIT_DATA = 3'b011,
               DONE = 3'b100;
    
    reg [2:0] state;

    // 状态控制
    always @(posedge clk) begin
        if(!rst_n) begin
            // 状态复位
            state <= IDLE;
            // 输出复位
            number_and_addr <= 0;
            data_to_alu <= 0;
            req <= 0;
            done <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    if(storage_ce) begin
                        state <= REQ;
                        done  <= 0;
                    end
                    else state <= state;
                end
                REQ: begin
                    if(grant == current_grant) state <= WRITE_FIFO;
                    else state <= state;
                end
                WRITE_FIFO: begin
                    state <= WAIT_DATA;
                end
                WAIT_DATA: begin
                    if(txn_done && data_from_storage[35:32] == CURRENT_NUMBER) begin 
                        state <= DONE;
                        done  <= 1;
                    end
                    else state <= state;
                end
                DONE: begin
                    state <= IDLE;
                end
                default: begin
                    state <= state;
                end
            endcase
        end
    end

    // 输出控制
    always @(*) begin
        // req
        if (state == REQ) req <= 1;
        else req <= 0;

        // number_and_addr
        if (state == REQ) number_and_addr <= {current_number,storage_addr};

        // storage_valid
        if (state == WRITE_FIFO) storage_valid <= 1;
        else storage_valid <= 0;
        
        // data_to_alu
        if (state == DONE) data_to_alu <= data_from_storage[31:0];

        // done
        // if (state == DONE) done <= 1;
        // else done <= 0;
    end
endmodule
