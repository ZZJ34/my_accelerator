`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 16:54:29
// Design Name: 
// Module Name: regfile
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


module regfile#(
    DATA_WIDTH = 8  //数据宽度
)(
    input clk,
    input rst_n,
    
    // 顺序写
    input seq_we,                            // 顺序写使能
    input [DATA_WIDTH-1:0] seq_w_data,       // 顺序写数据

    // 随机写
    input ran_we,                            // 随机写使能
    input [11:0] ran_w_addr,                 // 随机写读地址
    input [DATA_WIDTH-1:0] ran_w_data,       // 随机写数据

    // 支持顺序读和随机读
    input seq_re,                            // 顺序读使能
    output reg [DATA_WIDTH-1:0] seq_r_data,  // 顺序读数据
    output reg [11:0] out_seq_r_addr,        // 顺序读数据的地址

    input ran_re,                            // 随机读使能
    input [11:0] ran_r_addr,                 // 随机读地址
    output reg [DATA_WIDTH-1:0] ran_r_data,  // 随机读数据
    output reg [11:0] out_ran_r_addr         // 随机读数据的地址
    );

    reg [DATA_WIDTH-1:0] mem [0:4095] ;     
    reg [11:0] pc;                           // 当前顶端地址

    //////////////////////////////////////////
    // 不支持同时读写
    //////////////////////////////////////////

    // 写操作
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) 
            pc <= 0;
        else begin
            if(seq_we) begin
                mem[pc] <= seq_w_data;
                pc <= pc + 1;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            
        end
        else begin
            if(ran_we) begin
                mem[ran_w_addr] <= ran_w_data;
            end
        end
    end

    // 顺序读操作
    always @(*) begin
        if(!rst_n) begin
            seq_r_data <= 0;           // 复位状态
            out_seq_r_addr <= 12'bz;
        end
        else if(!seq_re) begin
            seq_r_data <= 0;           // 非使能
            out_seq_r_addr <= 12'bz;
        end
        else if(pc == 0) begin
            seq_r_data <= 0;           // 无数据
            out_seq_r_addr <= 12'bz;
        end
        else begin
            seq_r_data <= mem[pc-1];
            out_seq_r_addr <= pc-1;
        end
    end

    // 随机读
    always @(*) begin
        if(!rst_n) begin
            ran_r_data <= 0;           // 复位状态
            out_ran_r_addr <= 12'bz;
        end
        else if(!ran_re) begin
            ran_r_data <= 0;           // 非使能
            out_ran_r_addr <= 12'bz;
        end
        else if(ran_r_addr >= pc) begin
            ran_r_data <= 0;           // 无数据
            out_ran_r_addr <= 12'bz;
        end
        else begin
            ran_r_data <= mem[ran_r_addr];
            out_ran_r_addr <= ran_r_addr;
        end
    end

endmodule
