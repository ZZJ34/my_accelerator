`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/07 10:49:32
// Design Name: 
// Module Name: test_state_control
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


module test_state_control(
    );
    reg clk;
    reg rst_n;
    reg finish;
    reg start;
    wire       done;
    wire [2:0] state;

    initial begin
        clk = 0;
        rst_n = 0;
        finish = 0;
        start = 0;
        #20
        rst_n = 1;
        #100
        start = 1;
        #200
        finish = 1;
        #20
        finish = 0;
    end

    always #3 clk = ~ clk;

    state_control state_control_inst (.clk(clk), .rst_n(rst_n), .finish(finish), .start(start), .done(done), .state(state));
endmodule
