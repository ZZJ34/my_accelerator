`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 09:37:54
// Design Name: 
// Module Name: test_rom_C
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


module test_rom_C(

    );
    reg ce;
    reg [1:0] symbol;

    wire [7:0] data;

    initial begin
        ce = 0;
        symbol = 0;
        #10
        ce = 1;
        #10
        symbol = 1;
        #10
        symbol = 2;
        #10
        symbol = 3;
        #10
        symbol = 4;
    end

    rom_C rom_C_inst(.ce(ce), .symbol(symbol), .data(data));
endmodule
