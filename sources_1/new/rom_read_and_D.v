`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 09:50:11
// Design Name: 
// Module Name: rom_read_and_D
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 短序列和搜索边界(每个短序列都是不同的)
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rom_read_and_D(
    input ce,
    input      [7:0] addr,
    output reg [7:0] d_i,
    output reg [1:0] read_i    
    );

    reg [9:0] mem [0:255]; // [7:0] 后8位表示搜索边界数据D(i)，[10:9] 前2位表示短序列符号

    // 00 - A
    // 01 - C
    // 10 - G
    // 11 = T

    // 绝对路径
    initial $readmemb("D:/RISCV/my_accelerator/my_accelerator.srcs/sources_1/new/read_and_D.data", mem);

    always @(*) begin
        if(!ce) begin
            d_i <= 0;
            read_i <= 0;
        end
        else begin
            // 地址 16'hff 被认为是 -1，则该 mem 的最后一个地址数据无效
            d_i <= addr == 16'hff ? 0: mem[addr][7:0];
            read_i <= addr == 16'hff ? 0: mem[addr][9:8];
        end
    end

endmodule
