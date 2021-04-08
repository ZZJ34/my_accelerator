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
    input we,              // 写使能
    input [31:0] w_data,   // 写数据

    // 支持顺序读和随机读
    input seq_re,             // 顺序读使能

    input ran_re,             // 随机读使能
    input [11:0] ran_r_addr,  // 随机读地址

    output [11:0] out_r_addr, // 当前数据的地址
    output [31:0] out_r_data  // 当前数据
    );

    // 4个参数 i,z,k,l 每个参数8位 数据宽度32位
    // 不支持同时进行 随机读 和 顺序读

    wire [11:0] out_seq_r_addr;
    wire [11:0] out_ran_r_addr;

    wire [31:0] seq_r_data;
    wire [31:0] ran_r_data;

    regfile #(.DATA_WIDTH(32)) regfile_inst(
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
    assign out_r_data = seq_re ? seq_r_data : (ran_re ? ran_r_data : 32'b0);

endmodule
