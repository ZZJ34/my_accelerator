`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 10:35:54
// Design Name: 
// Module Name: test_fifo
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


module test_fifo(

    );

    reg rst_n;
    reg clk;
    reg wr_en;
    reg rd_en;
    reg [7:0] data_in;
    wire[7:0] data_out;

    reg [7:0] i;

    // wire wr_ack;
    wire valid;

    initial begin
        rst_n = 0;
        clk = 0;
        wr_en = 0;
        rd_en = 0;

        #100
        rst_n = 1;

        #20
        wr_en = 1;
        data_in = 8'h00;


        for ( i= 0; i<10; i = i+1) begin
            #10
            data_in = data_in + 1;
        end

        #10
        wr_en = 0;

        #20
        rd_en = 1;

        #40
        rd_en = 0;

    end

    always #5 clk = ~clk;

    fifo_generator_0 fifo_inst(
        .srst(~rst_n),
        .clk(clk),
        .din(data_in),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .dout(data_out),
        .full(),
        .empty(),
        .valid(valid)
    );

endmodule
