`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/22 11:30:23
// Design Name: 取数据
// Module Name: get_data_3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//            根据 get_param 模块传送的参数（i，z，k，l）从 rom 取出对应的数据
//            
//            从 rom_Occ 取出 l
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module get_data_3(
    input rst_n,               // 复位信号

    input [2:0] en_get_data_3,  // 该模块使能
    
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
    output reg ce_rom_Occ,

    // rom 存储器的地址
    output reg [7:0] addr_rom_Occ,
    
    // 存储器数据输入
    input [31:0] data,         // rom_Occ
    
    // 输出给下一个模块的数据
    output reg [4:0] position_out,
    output reg [11:0] addr_out,
    output reg [7:0] i_out,
    output reg [7:0] z_out,
    output reg [7:0] k_out,
    output reg [7:0] l_out,
    output reg [7:0] data_2_out
    );

    always @(*) begin
        if(!rst_n) begin
            // 使能
            ce_rom_Occ <= 0;
            // 地址线
            addr_rom_Occ <= 0;
            // 模块输出
            position_out <= 0;
            addr_out <= 0;
            i_out <= 0;
            z_out <= 0;
            k_out <= 0;
            l_out <= 0;                 
            data_2_out <= 0;
        end
        else if(en_get_data_3 == 3'b100) begin
            i_out <= i_in;
            z_out <= z_in;
            k_out <= k_in;
            l_out <= l_in;
            addr_out <= addr;
            position_out <= position;
            case (position)
                `A_INSERTION, `A_DELETION: begin
                    // 使能
                    ce_rom_Occ <= 1;
                    // 地址线
                    addr_rom_Occ <= l_in;

                    data_2_out <= data[7:0];
                end
                `C_INSERTION, `C_DELETION: begin
                    // 使能
                    ce_rom_Occ <= 1;
                    // 地址线
                    addr_rom_Occ <= l_in;

                    data_2_out <= data[15:8];
                end
                `G_INSERTION, `G_DELETION: begin
                    // 使能
                    ce_rom_Occ <= 1;
                    // 地址线
                    addr_rom_Occ <= l_in;

                    data_2_out <= data[23:16];
                end
                `T_INSERTION, `T_DELETION: begin
                    // 使能
                    ce_rom_Occ <= 1;
                    // 地址线
                    addr_rom_Occ <= l_in;

                    data_2_out <= data[31:24];
                end
                `NONE, `STOP_1, `STOP_2, `A_MATCH, `C_MATCH, `G_MATCH, `T_MATCH, `A_SNP, `C_SNP, `G_SNP, `T_SNP:begin
                    // 使能
                    ce_rom_Occ <= 0;
                    // 地址线
                    addr_rom_Occ <= 0;
                  
                    data_2_out <= 0;
                end
                default: begin
                    // 使能
                    ce_rom_Occ <= 0;
                    // 地址线
                    addr_rom_Occ <= 0;
                                        
                    data_2_out <= 0;
                end
            endcase
        end
        else begin
            // 使能
            ce_rom_Occ <= 0;
        end
    end
endmodule
