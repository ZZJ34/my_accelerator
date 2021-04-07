`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 09:11:28
// Design Name: 
// Module Name: test_rom_Occ
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


module test_rom_Occ(
    );
    reg ce;
    reg [7:0] addr;
    wire [31:0] data;

    initial begin
        ce = 0;
        addr = 0;
        #20
        ce = 1;
        #5
        addr = addr + 1;
        #5
        addr = addr + 1;
        #5
        addr = addr + 1;
        #5
        addr = addr + 1;
        #5
        addr = addr + 1;
        #5
        addr = addr + 1;
        #5
        addr = addr + 1;
        #5
        addr = addr + 1;
        #5
        addr = addr + 1;
        #5
        addr = addr + 1;
    end

    rom_Occ rom_Occ_inst(.ce(ce), .addr_1(addr), .data_1(data));
endmodule
