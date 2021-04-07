`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 11:18:02
// Design Name: 
// Module Name: regfile_InexRecur
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


module regfile_InexRecur(
    input clk,
    input rst_n,
    
    // 不支持随机写
    input we,               // 写使能
    input [31:0] w_data,   // 写数据

    // 支持顺序读和随机读
    input seq_re,                 // 顺序读使能
    output reg [31:0] seq_r_data, // 顺序读数据

    input ran_re,                 // 随机读使能
    input [11:0] ran_r_addr,      // 随机读地址
    output reg [31:0] ran_r_data  // 随机读地址
    );

    //////////////////////////////////////////
    // flag_1:
    // 这里实现的寄存器是针对状态机的，不是流水线
    // 理论上不存在同时读写的情况
    //////////////////////////////////////////

    reg [4095:0] mem [31:0];
    reg [11:0] pc;               //当前写地址

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
