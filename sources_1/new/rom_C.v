`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 09:29:19
// Design Name: 
// Module Name: ram_C
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


module rom_C(
    input ce,
    input      [1:0] symbol,
    output reg [7:0] data
    );

    reg [7:0] mem [0:3];

    // 00 - A
    // 01 - C
    // 10 - G
    // 11 = T

    // 绝对路径
    initial $readmemb("D:/RISCV/my_accelerator/my_accelerator.srcs/sources_1/new/data/C/C.data", mem);

    always @(*) begin
        if(!ce)
            data <= 0;
        else
            data <= mem[symbol];
    end

endmodule
