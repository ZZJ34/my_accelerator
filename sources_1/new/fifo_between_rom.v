`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/30 14:44:05
// Design Name: 
// Module Name: fifo_between_rom
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 该模块用于根据 FIFO 中的数据从 rom 中读取数据
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo_between_rom(
    input clk,
    input rst_n,

    input is_empty,
    input [11:0] data_from_fifo,
    output reg rd_en,

    input [7:0] base_addr,

    input [31:0] data_from_rom,
    input        data_valid,
    output reg [7:0] addr,
    output reg       ce,

    output reg       result_valid,
    output reg [35:0] result
    
    );

    reg [2:0] state;

    localparam IDLE = 3'b000,
               GET_DATA = 3'b001,
               DONE = 3'b010,
               REFRESH = 3'b011,
               WAIT = 3'b100;

    always @(posedge clk) begin
        if(!rst_n) begin
            // 输出复位
            rd_en <= 0;
            addr <= 0;
            ce <= 0;
            result <= 0;
            result_valid <= 0;
            // 状态复位
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE: begin
                    if(is_empty) state <= IDLE;
                    else state <= GET_DATA;
                end
                GET_DATA: begin
                    if(data_valid) state <= DONE;
                    else state <= GET_DATA;
                end
                DONE: state <= REFRESH;
                REFRESH: state <= WAIT;
                WAIT: begin
                    if(is_empty) state <= REFRESH;
                    else state <= GET_DATA;
                end
                default: begin
                end
            endcase
        end
    end

    always @(*) begin
        // for rom
        if(state == GET_DATA) begin
            ce <= 1;
            addr <= base_addr + data_from_fifo[7:0];
            result <= { data_from_fifo[11:8], data_from_rom };
        end
        else begin
            ce <= 0;
        end

        if(state == DONE) begin
            result_valid <= 1;
        end
        else begin
            result_valid <= 0;
        end

        if(state == REFRESH) begin
            rd_en <= 1;
        end
        else begin
            rd_en <= 0;
        end
    end
endmodule
