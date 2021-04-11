`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/09 14:55:12
// Design Name: 
// Module Name: test_accelerator_fsm
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


module test_accelerator_fsm(

    );
    reg clk;
    reg rst_n;

    reg we_InexRecur;
    reg we_state;
    reg [31:0] w_data_InexRecur;
    reg [17:0] w_data_state;

    reg start;

    wire ce_rom_C;
    wire ce_rom_Occ;
    wire ce_rom_read_and_D;

    wire [1:0] addr_rom_C;
    wire [7:0] addr1_rom_Occ;
    wire [7:0] addr2_rom_Occ;
    wire [7:0] addr_rom_read_and_D;

    wire [7:0] d_i;             // rom_read_and_D
    wire [1:0] read_i;          // rom_read_and_D
    wire [31:0] data_1;         // rom_Occ
    wire [31:0] data_2;         // rom_Occ
    wire [7:0] data;            // rom_C

    wire seq_re_InexRecur;
    wire seq_re_state;

    wire ran_re_InexRecur;
    wire [11:0] ran_r_addr_InexRecur;
    wire ran_re_state;
    wire [11:0] ran_r_addr_state;

    wire [31:0] out_r_data_InexRecur;
    wire [17:0] out_r_data_state;
    wire [11:0] out_r_addr;

    initial begin
        clk = 0;
        rst_n = 0;
        we_InexRecur = 0;
        we_state = 0;

        start = 0;

        #15
        rst_n = 1;

        #10
        we_InexRecur = 1;
        we_state = 1;
        w_data_InexRecur = 32'h02_01_00_06;
        w_data_state = 18'b0_0000_0000_0000_0000_0;
        #10
        w_data_InexRecur = 32'h01_00_00_06;
        w_data_state = 18'b0_0000_0000_0000_0000_1;
        #10
        w_data_InexRecur = 32'h00_ff_00_06;
        w_data_state = 18'b0_0000_0000_0000_0001_1;
        #10
        w_data_InexRecur = 32'h00_f1_00_06;
        w_data_state = 18'b0_0000_0000_0000_0010_1;
        #10
        we_InexRecur = 0;
        we_state = 0;

        #5
        start = 1;

    end

    always #5 clk = ~clk;

    accelerator_fsm accelerator_fsm_inst(
        .clk(clk),
        .rst_n(rst_n),
        .is_start(start),
        //存储器相关接口
        .re_reg_InexRecur_seq_o(seq_re_InexRecur),          // regfile_InexRecur 顺序读使能
        .re_reg_InexRecur_ran_o(ran_re_InexRecur),          // regfile_InexRecur 随机读使能
        .r_reg_InexRecur_addr_o(ran_r_addr_InexRecur),      // regfile_InexRecur 随机读地址
        .InexRecur_addr_i(out_r_addr),                      // regfile_InexRecur 当前地址 
        .InexRecur_data_i(out_r_data_InexRecur),            // regfile_InexRecur 当前数据

        .re_reg_state_seq_o(seq_re_state),              // regfile_state 顺序读使能
        .re_reg_state_ran_o(ran_re_state),              // regfile_state 随机读使能
        .r_reg_state_addr_o(ran_r_addr_state),          // regfile_state 随机读地址
        .state_addr_i(),                                // regfile_state 当前地址（ InexRecur 和 state 的数据一一对应，知道一个当前地址即可）
        .state_data_i(out_r_data_state),                // regfile_state 当前数据

        .ce_rom_C_o(ce_rom_C),
        .ce_rom_Occ_o(ce_rom_Occ),
        .ce_rom_read_and_D_o(ce_rom_read_and_D),

        .addr_rom_C_o(addr_rom_C),
        .addr1_rom_Occ_o(addr1_rom_Occ),
        .addr2_rom_Occ_o(addr2_rom_Occ),
        .addr_rom_read_and_D_o(addr_rom_read_and_D),

        .d_i_i(d_i),               // rom_read_and_D
        .read_i_i(read_i),         // rom_read_and_D
        .data_1_i(data_1),         // rom_Occ
        .data_2_i(data_2),         // rom_Occ
        .data_i(data)              // rom_C
    );

    // 两个reg
    regfile_InexRecur regfile_InexRecur_inst(
        .clk(clk), 
        .rst_n(rst_n), 
        
        .seq_we(we_InexRecur),
        .seq_w_data(w_data_InexRecur),

        .ran_we(),
        .ran_w_addr(),
        .ran_w_data(),

        .seq_re(seq_re_InexRecur),

        .ran_re(ran_re_InexRecur),
        .ran_r_addr(ran_r_addr_InexRecur),

        .r_addr(out_r_addr),
        .r_data(out_r_data_InexRecur)
    );

    regfile_state regfile_state_inst(
        .clk(clk), 
        .rst_n(rst_n), 
        
        .seq_we(we_state),
        .seq_w_data(w_data_state),

        .ran_we(),
        .ran_w_addr(),
        .ran_w_data(),

        .seq_re(seq_re_state),

        .ran_re(ran_re_state),
        .ran_r_addr(ran_r_addr_state),

        .r_addr(),
        .r_data(out_r_data_state)
    );
    
    // 三个rom
    rom_C rom_C_inst(
        .ce(ce_rom_C),
        .symbol(addr_rom_C),
        .data(data)
    );

    rom_Occ rom_Occ_inst(
        .ce(ce_rom_Occ),
        .addr_1(addr1_rom_Occ),
        .addr_2(addr2_rom_Occ),
        .data_1(data_1),
        .data_2(data_2)
    );

    rom_read_and_D rom_read_and_D_inst(
        .ce(ce_rom_read_and_D),
        .addr(addr_rom_read_and_D),
        .d_i(d_i),
        .read_i(read_i) 
    );

endmodule
