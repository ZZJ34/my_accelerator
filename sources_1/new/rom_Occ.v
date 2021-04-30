`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 09:01:35
// Design Name: 
// Module Name: rom_Occ
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 参考序列的 Occ 数据
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rom_Occ(
        input ce,

        input       [7:0] addr,

        output reg [31:0] data,
        output reg        valid

    );

    // t [31:24]
    // g [23:16]
    // c [15:8]
    // a [7:0]
    
    reg [31:0] mem [0:255];

    // 绝对路径
    initial $readmemh("D:/RISCV/my_accelerator/my_accelerator.srcs/sources_1/new/Occ.data", mem);

    always @(*) begin
        if(!ce) begin
            data <= 0;
            valid <= 0;
        end
        else begin
            // 地址 16'hff 被认为是 -1，则该 mem 的最后一个地址数据无效
            data <= addr == 16'hff ? 0: mem[addr];
            valid <= 1;
        end
    end


endmodule
