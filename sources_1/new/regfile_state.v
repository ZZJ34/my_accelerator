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
    input [16:0] w_data,    // 写数据

    // 支持顺序读和随机读
    input seq_re,                 // 顺序读使能
    output reg [16:0] seq_r_data, // 顺序读数据

    input ran_re,                 // 随机读使能
    input [11:0] ran_r_addr,      // 随机读地址
    output reg [16:0] ran_r_data, // 随机读数据

    output reg [11:0] out_r_addr  // 当前数据的地址
    );

    // 一个 InexRecur 对应一个 state (一一对应) 
    // 一个 state 包含了上一个调用的位置，上一个 InexRecur 参数的地址以及当前调用是否结束的标志
    // 调用位置4位，地址12位，结束标志1位 数据宽度17位
    // 不支持同时进行 随机读 和 顺序读
    
    wire [16:0] out_seq_r_addr;
    wire [16:0] out_ran_r_addr;

    regfile #(.DATA_WIDTH(17)) regfile_inst(
        .clk(clk),
        .rst_n(rst_n),
    
        .we(we),               
        .w_data(w_data),    

        .seq_re(seq_re),                           
        .seq_r_data(seq_r_data),               
        .out_seq_r_addr(out_seq_r_addr),       

        .ran_re(ran_re),                            
        .ran_r_addr(ran_r_addr),                 
        .ran_r_data(ran_r_data),  
        .out_ran_r_addr(out_ran_r_addr)
    );

    assign out_r_addr = seq_re ? out_seq_r_addr : (ran_re ? out_ran_r_addr : 12'bz);

endmodule