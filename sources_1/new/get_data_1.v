`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/09 08:36:15
// Design Name: 取数据
// Module Name: get_data_1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//            根据 get_param 模块传送的参数（i，z，k，l）从 rom 取出对应的数据
//            
//            从 rom_C 和 rom_read_and_D 中取参数
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "config.v"
module get_data_1(
    input rst_n,               // 复位信号

    input [2:0] en_get_data_1,  // 该模块使能

    output reg get_data_in_Occ,
    
    // 上一个模块的输出
    // 四个参数
    input [7:0] i_in,
    input [7:0] z_in,
    input [7:0] k_in,
    input [7:0] l_in,
    // 当前参数地址
    input [11:0] addr,
    // 当前参数执行位置
    input [4:0] position,

    // rom 存储器的使能信号
    output reg ce_rom_C,
    output reg ce_rom_read_and_D,

    // rom 存储器的地址
    output reg [1:0] addr_rom_C,
    output reg [7:0] addr_rom_read_and_D,
    
    // 存储器数据输入
    input [7:0] d_i,             // rom_read_and_D
    input [1:0] read_i,          // rom_read_and_D
    input [7:0] data,            // rom_C
    
    // 输出给下一个模块的数据
    output reg [4:0] position_out,
    output reg [11:0] addr_out,
    output reg [7:0] i_out,
    output reg [7:0] z_out,
    output reg [7:0] k_out,
    output reg [7:0] l_out,
    output reg [7:0] d_i_out,
    output reg [1:0] read_i_out,
    output reg [7:0] C_out
    );

    always @(*) begin
        if(!rst_n) begin
            // 使能
            ce_rom_C <= 0;
            ce_rom_read_and_D <= 0;
            // 地址线
            addr_rom_C <= 0;
            addr_rom_read_and_D <= 0;
            // 模块输出
            position_out <= 0;
            addr_out <= 0;
            i_out <= 0;
            z_out <= 0;
            k_out <= 0;
            l_out <= 0;
            d_i_out <= 0;           
            read_i_out <= 0;                 
            C_out <= 0;

            get_data_in_Occ <= 0;
        end
        else if(en_get_data_1 == 3'b010) begin
            i_out <= i_in;
            z_out <= z_in;
            k_out <= k_in;
            l_out <= l_in;
            addr_out <= addr;
            position_out <= position;
            case (position)
                `NONE: begin
                    // 使能
                    ce_rom_C <= 0;
                    ce_rom_read_and_D <= 1;
                    // 地址线
                    addr_rom_C <= 0;
                    addr_rom_read_and_D <= i_in;

                    d_i_out <= d_i;

                    get_data_in_Occ <= 0;
                end
                `A_INSERTION: begin
                    // 使能
                    ce_rom_C <= 1;
                    ce_rom_read_and_D <= 0;
                    // 地址线
                    addr_rom_C <= 2'b00;
                    addr_rom_read_and_D <= 0;

                    C_out <= data;

                    get_data_in_Occ <= 1;
                end
                `C_INSERTION: begin
                    // 使能
                    ce_rom_C <= 1;
                    ce_rom_read_and_D <= 0;
                    // 地址线
                    addr_rom_C <= 2'b01;
                    addr_rom_read_and_D <= 0;

                    C_out <= data;

                    get_data_in_Occ <= 1;
                end
                `G_INSERTION: begin
                    // 使能
                    ce_rom_C <= 1;
                    ce_rom_read_and_D <= 0;
                    // 地址线
                    addr_rom_C <= 2'b10;
                    addr_rom_read_and_D <= 0;

                    C_out <= data;

                    get_data_in_Occ <= 1;
                end
                `T_INSERTION: begin
                    // 使能
                    ce_rom_C <= 1;
                    ce_rom_read_and_D <= 0;
                    // 地址线
                    addr_rom_C <= 2'b11;
                    addr_rom_read_and_D <= 0;;

                    C_out <= data;

                    get_data_in_Occ <= 1;
                end
                `A_DELETION: begin
                    //使能
                    ce_rom_C <= 1;
                    ce_rom_read_and_D <= 1;
                    // 地址线
                    addr_rom_C <= 2'b00;
                    addr_rom_read_and_D <= i_in;

                    read_i_out <= read_i;
                    C_out <= data;

                    get_data_in_Occ <= 1;
                end
                `C_DELETION: begin
                    //使能
                    ce_rom_C <= 1;
                    ce_rom_read_and_D <= 1;
                    // 地址线
                    addr_rom_C <= 2'b01;
                    addr_rom_read_and_D <= i_in;

                    read_i_out <= read_i;
                    C_out <= data;

                    get_data_in_Occ <= 1;
                end
                `G_DELETION: begin
                    // 使能
                    ce_rom_C <= 1;
                    ce_rom_read_and_D <= 1;
                    // 地址线
                    addr_rom_C <= 2'b10;
                    addr_rom_read_and_D <= i_in;

                    read_i_out <= read_i;
                    C_out <= data;

                    get_data_in_Occ <= 1;
                end
                `T_DELETION: begin
                    // 使能
                    ce_rom_C <= 1;
                    ce_rom_read_and_D <= 1;
                    // 地址线
                    addr_rom_C <= 2'b11;
                    addr_rom_read_and_D <= i_in;

                    read_i_out <= read_i;
                    C_out <= data;

                    get_data_in_Occ <= 1;
                end
                `STOP_1,`STOP_2,`A_MATCH,`C_MATCH,`G_MATCH,`T_MATCH,`A_SNP,`C_SNP,`G_SNP,`T_SNP:begin
                    // 使能
                    ce_rom_C <= 0;
                    ce_rom_read_and_D <= 0;
                    // 地址线
                    addr_rom_C <= 0;

                    addr_rom_read_and_D <= 0;
                   
                    d_i_out <= 0;           
                    read_i_out <= 0;                
                    C_out <= 0;

                    get_data_in_Occ <= 0;
                end
                default: begin
                    // 使能
                    ce_rom_C <= 0;
                    ce_rom_read_and_D <= 0;
                    // 地址线
                    addr_rom_C <= 0;
                    addr_rom_read_and_D <= 0;
                   
                    d_i_out <= 0;           
                    read_i_out <= 0;               
                    C_out <= 0; 
                end
            endcase
        end
        else begin
            // 使能
            ce_rom_C <= 0;
            ce_rom_read_and_D <= 0;
        end
    end
endmodule
