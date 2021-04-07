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

        input       [7:0] addr_1,
        input       [7:0] addr_2,

        output reg [31:0] data_1,
        output reg [31:0] data_2

    );


    reg [255:0] mem [0:31];

    // 绝对路径
    initial $readmemh("D:/RISCV/my_accelerator/my_accelerator.srcs/sources_1/new/Occ.data", mem);

    always @(*) begin
        if(!ce) begin
            data_1 <= 0;
            data_2 <= 0;
        end
        else begin
            data_1 <= mem[addr_1];
            data_2 <= mem[addr_2];
        end
    end


endmodule
