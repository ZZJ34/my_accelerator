`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/08 10:11:57
// Design Name: 
// Module Name: tes_top
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


module test_top(
    );

    reg clk;
    reg rst_n;

    reg we_InexRecur;
    reg we_state;
    reg [31:0] w_data_InexRecur;
    reg [16:0] w_data_state;

    wire [2:0] en_get_param;

    reg start;

    wire seq_re_InexRecur;
    wire seq_re_state;

    wire ran_re_InexRecur;
    wire [11:0] ran_r_addr_InexRecur;
    wire ran_re_state;
    wire [11:0] ran_r_addr_state;


    wire [31:0] out_r_data_InexRecur;
    wire [16:0] out_r_data_state;
    wire [11:0] out_r_addr;

    wire now;

    initial begin
        clk = 0;
        rst_n = 0;
        we_InexRecur = 0;
        we_state = 0;

        start = 0;

        #10
        rst_n = 1;

        #10
        we_InexRecur = 1;
        we_state = 1;
        w_data_InexRecur = 32'h02_01_00_06;
        w_data_state = 17'b0001_0000_0000_0000_0;
        #10
        w_data_InexRecur = 32'h01_00_00_06;
        w_data_state = 17'b0000_0000_0000_0000_1;
        #10
        w_data_InexRecur = 32'h00_ff_00_06;
        w_data_state = 17'b0000_0000_0000_0001_1;
        #10
        w_data_InexRecur = 32'h00_f1_00_06;
        w_data_state = 17'b0000_0000_0000_0010_1;
        #10
        we_InexRecur = 0;
        we_state = 0;

        #20
        start = 1;


    end

    always #5 clk = ~clk;


    state_control state_control_inst(
        .clk(clk),
        .rst_n(rst_n),
        .is_finish(1'b0),
        .is_start(start),
        .is_find(now),   
        .state(en_get_param)
    );

    get_param get_param_inst(
        .clk(clk),
        .rst_n(rst_n),
    
        .en_get_param(en_get_param),
    
        // regfile_InexRecur 
        .re_reg_InexRecur_seq_o(seq_re_InexRecur),          // 顺序读使能
        .re_reg_InexRecur_ran_o(ran_re_InexRecur),          // 随机读使能
        .r_reg_InexRecur_addr_o(ran_r_addr_InexRecur),      // 随机读地址
        .InexRecur_addr_i(out_r_addr),                      // 当前地址 
        .InexRecur_data_i(out_r_data_InexRecur),            // 当前数据

        // regfile_state    
        .re_reg_state_seq_o(seq_re_state),                  // 顺序读使能
        .re_reg_state_ran_o(ran_re_state),                  // 随机读使能
        .r_reg_state_addr_o(ran_r_addr_state),              // 随机读地址
        .state_addr_i(),                                    // 当前地址
        .state_data_i(out_r_data_state),                    // 当前数据

        // 给下一个模块的输出
        // 四个参数
        .i_out(),
        .z_out(),
        .k_out(),
        .l_out(),
    
        // 当前参数地址
        .addr(),

        // 执行位置
        .position(),
    
        // 是否找到未执行完成的参数
        .is_find(now)
    );

    regfile_InexRecur regfile_InexRecur_inst(
        .clk(clk), 
        .rst_n(rst_n), 
        
        .we(we_InexRecur),
        .w_data(w_data_InexRecur),

        .seq_re(seq_re_InexRecur),

        .ran_re(ran_re_InexRecur),
        .ran_r_addr(ran_r_addr_InexRecur),

        .r_addr(out_r_addr),
        .r_data(out_r_data_InexRecur)
    );

    regfile_state regfile_state_inst(
        .clk(clk), 
        .rst_n(rst_n), 
        
        .we(we_state),
        .w_data(w_data_state),

        .seq_re(seq_re_state),

        .ran_re(ran_re_state),
        .ran_r_addr(ran_r_addr_state),

        .r_addr(),
        .r_data(out_r_data_state)
    );

endmodule
