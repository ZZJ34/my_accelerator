`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 10:04:22
// Design Name: 
// Module Name: test_rom_read_and_D
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


module test_rom_read_and_D(

    );
    reg ce;
    reg [7:0] addr;
    wire [1:0] read_i;
    wire [7:0] d_i;

    initial begin
        ce = 0;
        addr = 0;
        #10
        ce = 1;
        #5
        addr = 1;
        #5
        addr = 2;
        #5
        addr = 3;
    end

    rom_read_and_D rom_read_and_D_inst(.ce(ce), .addr(addr), .read_i(read_i), .d_i(d_i));
endmodule
