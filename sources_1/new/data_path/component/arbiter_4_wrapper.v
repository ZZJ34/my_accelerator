`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 19:39:35
// Design Name: 
// Module Name: arbiter_4_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 封装四通道的仲裁器
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module arbiter_4_wrapper(
    input clk,
    input rst_n,

    input req_1,
    input req_2,
    input req_3,
    input req_4,

    output [3:0] grant
    );

    wire [3:0] req;

    assign req = { req_4, req_3, req_2, req_1 };

    round_robin_arbiter_4 round_robin_arbiter_4_inst(
        .rst_n(rst_n),
	    .clk(clk),
	    .req(req),
	    .grant(grant)
    );
endmodule
