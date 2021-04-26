`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/26 12:37:10
// Design Name: 
// Module Name: test_round_robin_arbiter
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


module test_round_robin_arbiter(

    );

    reg clk;
    reg rst_n;
    reg [1:0] req = 2'b00;

    wire [1:0] grant;

    initial begin
        clk = 0;
        rst_n = 0;

        #30
        rst_n = 1;

        #50
        req = 2'b01;

        #50
        req = 2'b10;

        #50
        req = 4'b11;
    end

    always #5 clk = ~clk;
    
    round_robin_arbiter_2 round_robin_arbiter_2_inst(
        .rst_n(rst_n),
	    .clk(clk),
	    .req(req),
	    .grant(grant)
    );

endmodule
