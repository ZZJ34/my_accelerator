`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/12 08:54:17
// Design Name: 
// Module Name: test_all
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


module test_all(

    );

    reg clk;
    reg rst_n;
    reg is_start;

    reg        ran_we_InexRecur;
    reg [11:0] ran_w_addr_InexRecur;
    reg [31:0] ran_w_data_InexRecur;

    reg        ran_we_state_external;
    reg [11:0] ran_w_addr_state_external;
    reg [17:0] ran_w_data_state_external;

    initial begin
        clk = 0;
        rst_n = 0;
        is_start = 0;

        ran_we_InexRecur = 0;
        ran_w_addr_InexRecur = 0;
        ran_w_data_InexRecur = 0;

        ran_we_state_external = 0;
        ran_w_addr_state_external = 0;
        ran_w_data_state_external = 0;
        #15
        rst_n = 1;

        #10
        ran_we_state_external = 1;
        ran_we_InexRecur = 1;
        
        ran_w_data_state_external = 18'b0_0000_0000_0000_0000_0;
        ran_w_data_InexRecur = 32'h02_01_00_06;
        

        #20
        ran_we_InexRecur = 0;
        ran_we_state_external = 0;

        #30
        is_start = 1;
    end

    always #5 clk = ~clk;

    top_with_data_path top_with_data_path_inst(
        .clk(clk),              // 时钟
        .rst_n(rst_n),          // 复位
        .is_start(is_start),    // 开始执行
        // regfile_InexRecur 的随机写端口
        .ran_we_InexRecur(ran_we_InexRecur),
        .ran_w_addr_InexRecur(ran_w_addr_InexRecur),
        .ran_w_data_InexRecur(ran_w_data_InexRecur),
        // regfile_state 的随机写端口
        .ran_we_state_external(ran_we_state_external),
        .ran_w_addr_state_external(ran_w_addr_state_external),
        .ran_w_data_state_external(ran_w_data_state_external)
    );
 
endmodule
