`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/09 16:27:33
// Design Name: 执行/判断
// Module Name: ex
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description:
//             根据 postion ，判断接下来的执行 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "config.v"
module ex(
    input rst_n,              // 复位

    input [2:0] en_ex,        // 该模块使能

    // 来自上一个模块的输出
    input [4:0] position_in,
    input [11:0] addr_in,
    input [7:0] i_in,
    input [7:0] z_in,
    input [7:0] k_in,
    input [7:0] l_in,
    input [7:0] d_i_in,
    input [1:0] read_i_in,
    input [7:0] data_1_in,
    input [7:0] data_2_in,
    input [7:0] C_in,

    // 该模块输出

    output reg [11:0] current_addr,
    output reg [7:0] current_k,
    output reg [7:0] current_l,
    
    output reg over_1,             // 条件1中止   z < D(i)    “1”有效
    output reg over_2,             // 条件2中止   i < 0       “1”有效
    output reg over_3,             // 条件3中止   本次调用完成 “1”有效

    output reg en_new_position,    // 是否更新当前参数执行位置    “1”有效
    output reg [4:0] new_position, // 新的执行位置

    output reg new_call,           // 调用新的循环   “1”有效
    output reg [7:0] i_new,         
    output reg [7:0] z_new,
    output reg [7:0] k_new,
    output reg [7:0] l_new,

    output reg finish              // 全部完成       “1”有效
    );

    always @(*) begin
        if(!rst_n) begin
            current_addr <= 0;
            current_k <= 0;
            current_l <= 0;
            over_1 <= 0;
            over_2 <= 0;
            over_3 <= 0;
            en_new_position <= 0;
            new_position <= 0;

            new_call <= 0;
            i_new <= 0;
            z_new <= 0;
            k_new <= 0;
            l_new <= 0;

            finish <= 0;
        end
        else if(en_ex == 3'b101) begin
            current_addr <= addr_in;
            current_k <= k_in;
            current_l <= l_in;
            case (position_in)
                `NONE: begin
                    // 这里 z_in 可能等于 -1 ，涉及有符号数比较
                    if( $signed(z_in) < $signed(d_i_in) ) begin
                        over_1 <= 1;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 0;
                        new_position <= 0;

                        new_call <= 0;
                        i_new <= 0;
                        z_new <= 0;
                        k_new <= 0;
                        l_new <= 0;

                        finish <= 0;
                    end
                    else begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 1;
                        new_position <= `STOP_1;

                        new_call <= 0;
                        i_new <= 0;
                        z_new <= 0;
                        k_new <= 0;
                        l_new <= 0;

                        finish <= 0;
                    end
                end
                `STOP_1: begin
                    // 这里 i_in 可能等于 -1 ，涉及有符号数比较
                    if( $signed(i_in) < $signed(0) ) begin
                        over_1 <= 0;
                        over_2 <= 1;
                        over_3 <= 0;

                        en_new_position <= 0;
                        new_position <= 0;

                        new_call <= 0;
                        i_new <= 0;
                        z_new <= 0;
                        k_new <= 0;
                        l_new <= 0;

                        finish <= 0;
                    end
                    else begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 1;
                        new_position <= `STOP_2;

                        new_call <= 0;
                        i_new <= 0;
                        z_new <= 0;
                        k_new <= 0;
                        l_new <= 0;

                        finish <= 0;
                    end
                end
                `STOP_2: begin
                    over_1 <= 0;
                    over_2 <= 0;

                    en_new_position <= 1;
                    new_position <= `A_INSERTION;

                    new_call <= 1;
                    i_new <= i_in - 1;
                    z_new <= z_in - 1;
                    k_new <= k_in;
                    l_new <= l_in;

                    finish <= 0;
                end
                `A_INSERTION: begin
                    if((C_in + data_1_in + 1) <= (C_in + data_2_in)) begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 1;
                        new_position <= `A_DELETION;

                        new_call <= 1;
                        i_new <= i_in;
                        z_new <= z_in - 1;
                        k_new <= C_in + data_1_in + 1;
                        l_new <= C_in + data_2_in;

                        finish <= 0;
                    end
                    else begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 1;
                        new_position <= `C_INSERTION;

                        new_call <= 0;
                        i_new <= 0;
                        z_new <= 0;
                        k_new <= 0;
                        l_new <= 0;

                        finish <= 0;
                    end
                end
                `C_INSERTION: begin
                    if((C_in + data_1_in + 1) <= (C_in + data_2_in)) begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 1;
                        new_position <= `C_DELETION;

                        new_call <= 1;
                        i_new <= i_in;
                        z_new <= z_in - 1;
                        k_new <= C_in + data_1_in + 1;
                        l_new <= C_in + data_2_in;

                        finish <= 0;
                    end
                    else begin
                        over_1 <= 0;
                        over_2 <= 0;

                        en_new_position <= 1;
                        new_position <= `G_INSERTION;

                        new_call <= 0;
                        i_new <= 0;
                        z_new <= 0;
                        k_new <= 0;
                        l_new <= 0;

                        finish <= 0;
                    end
                end
                `G_INSERTION: begin
                    if((C_in + data_1_in + 1) <= (C_in + data_2_in)) begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 1;
                        new_position <= `G_DELETION;

                        new_call <= 1;
                        i_new <= i_in;
                        z_new <= z_in - 1;
                        k_new <= C_in + data_1_in + 1;
                        l_new <= C_in + data_2_in;

                        finish <= 0;
                    end
                    else begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 1;
                        new_position <= `T_INSERTION;

                        new_call <= 0;
                        i_new <= 0;
                        z_new <= 0;
                        k_new <= 0;
                        l_new <= 0;

                        finish <= 0;
                    end
                end
                `T_INSERTION: begin
                    if((C_in + data_1_in + 1) <= (C_in + data_2_in)) begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 1;
                        new_position <= `T_DELETION;

                        new_call <= 1;
                        i_new <= i_in;
                        z_new <= z_in - 1;
                        k_new <= C_in + data_1_in + 1;
                        l_new <= C_in + data_2_in;

                        finish <= 0;
                    end
                    else begin
                        if(addr_in == 0) begin
                            over_1 <= 0;
                            over_2 <= 0;
                            over_3 <= 0;

                            en_new_position <= 0;
                            new_position <= 0;

                            new_call <= 0;
                            i_new <= 0;
                            z_new <= 0;
                            k_new <= 0;
                            l_new <= 0;

                            finish <= 1; 
                        end
                        else begin
                            over_1 <= 0;
                            over_2 <= 0;
                            over_3 <= 1;

                            en_new_position <= 0;
                            new_position <= 0;

                            new_call <= 0;
                            i_new <= 0;
                            z_new <= 0;
                            k_new <= 0;
                            l_new <= 0;

                            finish <= 0;
                        end
                    end
                end
                `A_DELETION: begin
                    if(read_i_in == 2'b00) begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 1;
                        new_position <= `A_MATCH;

                        new_call <= 1;
                        i_new <= i_in - 1;
                        z_new <= z_in;
                        k_new <= C_in + data_1_in + 1;
                        l_new <= C_in + data_2_in;

                        finish <= 0;
                    end
                    else begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 1;
                        new_position <= `A_SNP;

                        new_call <= 1;
                        i_new <= i_in - 1;
                        z_new <= z_in - 1;
                        k_new <= C_in + data_1_in + 1;
                        l_new <= C_in + data_2_in;

                        finish <= 0;
                    end
                end
                `C_DELETION: begin 
                    if(read_i_in == 2'b01) begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 1;
                        new_position <= `C_MATCH;

                        new_call <= 1;
                        i_new <= i_in - 1;
                        z_new <= z_in;
                        k_new <= C_in + data_1_in + 1;
                        l_new <= C_in + data_2_in;

                        finish <= 0;
                    end
                    else begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 1;
                        new_position <= `C_SNP;

                        new_call <= 1;
                        i_new <= i_in - 1;
                        z_new <= z_in - 1;
                        k_new <= C_in + data_1_in + 1;
                        l_new <= C_in + data_2_in;

                        finish <= 0;
                    end
                end
                `G_DELETION: begin
                    if(read_i_in == 2'b10) begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 1;
                        new_position <= `G_MATCH;

                        new_call <= 1;
                        i_new <= i_in - 1;
                        z_new <= z_in;
                        k_new <= C_in + data_1_in + 1;
                        l_new <= C_in + data_2_in;

                        finish <= 0;
                    end
                    else begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 1;
                        new_position <= `G_SNP;

                        new_call <= 1;
                        i_new <= i_in - 1;
                        z_new <= z_in - 1;
                        k_new <= C_in + data_1_in + 1;
                        l_new <= C_in + data_2_in;

                        finish <= 0;
                    end
                end
                `T_DELETION: begin
                    if(read_i_in == 2'b10) begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 1;
                        new_position <= `T_MATCH;

                        new_call <= 1;
                        i_new <= i_in - 1;
                        z_new <= z_in;
                        k_new <= C_in + data_1_in + 1;
                        l_new <= C_in + data_2_in;

                        finish <= 0;
                    end
                    else begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 1;
                        new_position <= `T_SNP;

                        new_call <= 1;
                        i_new <= i_in - 1;
                        z_new <= z_in - 1;
                        k_new <= C_in + data_1_in + 1;
                        l_new <= C_in + data_2_in;

                        finish <= 0;
                    end
                end
                `A_MATCH,`A_SNP: begin
                    over_1 <= 0;
                    over_2 <= 0;
                    over_3 <= 0;

                    en_new_position <= 1;
                    new_position <= `C_INSERTION;

                    new_call <= 0;
                    i_new <= 0;
                    z_new <= 0;
                    k_new <= 0;
                    l_new <= 0;

                    finish <= 0;
                end
                `C_MATCH,`C_SNP: begin
                    over_1 <= 0;
                    over_2 <= 0;
                    over_3 <= 0;

                    en_new_position <= 1;
                    new_position <= `G_INSERTION;

                    new_call <= 0;
                    i_new <= 0;
                    z_new <= 0;
                    k_new <= 0;
                    l_new <= 0;

                    finish <= 0;
                end
                `G_MATCH,`G_SNP: begin
                    over_1 <= 0;
                    over_2 <= 0;
                    over_3 <= 0;

                    en_new_position <= 1;
                    new_position <= `T_INSERTION;

                    new_call <= 0;
                    i_new <= 0;
                    z_new <= 0;
                    k_new <= 0;
                    l_new <= 0;

                    finish <= 0;
                end
                `T_MATCH,`T_SNP: begin
                    if(addr_in == 0) begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 0;

                        en_new_position <= 0;
                        new_position <= 0;

                        new_call <= 0;
                        i_new <= 0;
                        z_new <= 0;
                        k_new <= 0;
                        l_new <= 0;

                        finish <= 1; 
                    end
                    else begin
                        over_1 <= 0;
                        over_2 <= 0;
                        over_3 <= 1;

                        en_new_position <= 0;
                        new_position <= 0;

                        new_call <= 0;
                        i_new <= 0;
                        z_new <= 0;
                        k_new <= 0;
                        l_new <= 0;

                        finish <= 0;
                    end
                end
                default: begin

                end
            endcase
        end
        else begin
            
        end
    end

endmodule
