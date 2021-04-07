`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 11:18:02
// Design Name: 
// Module Name: regfile_state
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


module regfile_state(
    input clk,
    input rst_n,
    
    // 不支持随机写
    input we,               // 写使能
    input [15:0] w_data,    // 写数据

    // 支持顺序读和随机读
    input seq_re,                 // 顺序读使能
    output reg [15:0] seq_r_data, // 顺序读数据
    output reg [11:0] out_r_addr, // 当前数据的地址

    input ran_re,                 // 随机读使能
    input [11:0] ran_r_addr,      // 随机读地址
    output reg [15:0] ran_r_data  // 随机读数据
    );

    // 一个 InexRecur 对应一个 state (一一对应) 
    // 一个 state 包含了上一个调用的位置，上一个 InexRecur 参数的地址以及当前调用是否结束的标志

    reg [4095:0] mem [15:0];     // 调用位置4位，地址11位，结束标志1位
    reg [11:0] pc;               // 当前写地址

    // 写操作
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) 
            pc <= 0;
        else begin
            if(we) begin
                mem[pc] <= w_data;
                pc <= pc + 1;
            end
        end
    end

    // 顺序读操作
    always @(*) begin
        if(!rst_n)
            seq_r_data <= 0;           // 复位状态
        else if(!seq_re)
            seq_r_data <= 0;           // 非使能
        else if(pc == 0)
            seq_r_data <= 0;           // 无数据
        else
            seq_r_data <= mem[pc-1];
            out_r_addr <= pc-1;
    end

    // 随机读
    always @(*) begin
        if(!rst_n)
            ran_r_data <= 0;           // 复位状态
        else if(!ran_re)
            ran_r_data <= 0;           // 非使能
        else if(ran_r_addr >= pc)
            ran_r_data <= 0;           // 无数据
        else
            ran_r_data <= mem[ran_r_addr];
    end

endmodule