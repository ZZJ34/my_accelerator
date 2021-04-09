`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/09 11:44:26
// Design Name: 加速器状态机部分
// Module Name: accelerator_fsm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//             加速器状态控制
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module accelerator_fsm(
    input clk,
    input rst_n,
    input is_start,
    //存储器相关接口
    output re_reg_InexRecur_seq_o,          // regfile_InexRecur 顺序读使能
    output re_reg_InexRecur_ran_o,          // regfile_InexRecur 随机读使能
    output [11:0] r_reg_InexRecur_addr_o,   // regfile_InexRecur 随机读地址
    input [11:0] InexRecur_addr_i,          // regfile_InexRecur 当前地址 
    input [31:0] InexRecur_data_i,          // regfile_InexRecur 当前数据

    output re_reg_state_seq_o,              // regfile_state 顺序读使能
    output re_reg_state_ran_o,              // regfile_state 随机读使能
    output [11:0] r_reg_state_addr_o,       // regfile_state 随机读地址
    input [11:0] state_addr_i,              // regfile_state 当前地址（ InexRecur 和 state 的数据一一对应，知道一个当前地址即可）
    input [17:0] state_data_i,              // regfile_state 当前数据

    output ce_rom_C_o,
    output ce_rom_Occ_o,
    output ce_rom_read_and_D_o,

    output [1:0] addr_rom_C_o,
    output [7:0] addr1_rom_Occ_o,
    output [7:0] addr2_rom_Occ_o,
    output [7:0] addr_rom_read_and_D_o,

    input [7:0] d_i_i,             // rom_read_and_D
    input [1:0] read_i_i,          // rom_read_and_D
    input [31:0] data_1_i,         // rom_Occ
    input [31:0] data_2_i,         // rom_Occ
    input [7:0] data_i             // rom_C
    );
    
    // 状态控制输出，使能不同的模块
    wire [2:0] state_out;

    wire is_find_control;

    wire [7:0] i_param_to_data;
    wire [7:0] z_param_to_data;
    wire [7:0] k_param_to_data;
    wire [7:0] l_param_to_data;
    wire [11:0] addr_param_to_data;
    wire [4:0] position_param_to_data;

    // 状态控制
    state_control state_control_inst(
        .clk(clk),
        .rst_n(rst_n),
        .is_finish(),                      // 是否已完成所有迭代
        .is_start(is_start),               // 是否开始开始
        .is_find(is_find_control),         // 是否找到尚未完成的参数
        .state(state_out)
    );
    
    // 取参数
    get_param get_param_inst(
        .clk(clk),                   // 时钟信号
        .rst_n(rst_n),               // 复位信号
    
        .en_get_param(state_out),    // 该模块使能
    
        // regfile_InexRecur 
        .re_reg_InexRecur_seq_o(re_reg_InexRecur_seq_o), // regfile_InexRecur 顺序读使能
        .re_reg_InexRecur_ran_o(re_reg_InexRecur_ran_o), // regfile_InexRecur 随机读使能
        .r_reg_InexRecur_addr_o(r_reg_InexRecur_addr_o), // regfile_InexRecur 随机读地址
        .InexRecur_addr_i(InexRecur_addr_i),             // regfile_InexRecur 当前地址 
        .InexRecur_data_i(InexRecur_data_i),             // regfile_InexRecur 当前数据

        // regfile_state    
        .re_reg_state_seq_o(re_reg_state_seq_o),          // regfile_state 顺序读使能
        .re_reg_state_ran_o(re_reg_state_ran_o),          // regfile_state 随机读使能
        .r_reg_state_addr_o(r_reg_state_addr_o),          // regfile_state 随机读地址
        .state_addr_i(state_addr_i),                      // regfile_state 当前地址（ InexRecur 和 state 的数据一一对应，知道一个当前地址即可）
        .state_data_i(state_data_i),                      // regfile_state 当前数据

        // 给下一个模块的输出
        // 四个参数
        .i_out(i_param_to_data),
        .z_out(z_param_to_data),
        .k_out(k_param_to_data),
        .l_out(l_param_to_data),
    
        // 当前参数地址
        .addr(addr_param_to_data),

        // 当前参数执行位置
        .position(position_param_to_data),
    
        // 是否找到未执行完成的参数
        .is_find(is_find_control)
    );
    
    // 取数据
    get_data get_data_inst(
        .rst_n(rst_n),               // 复位信号

        .en_get_data(state_out),     // 该模块使能

        // 四个参数
        .i_in(i_param_to_data),
        .z_in(z_param_to_data),
        .k_in(k_param_to_data),
        .l_in(l_param_to_data),
    
        // 当前参数地址
        .addr(addr_param_to_data),

        // 当前参数执行位置
        .position(position_param_to_data),

        // rom 存储器的使能信号
        .ce_rom_C(ce_rom_C_o),
        .ce_rom_Occ(ce_rom_Occ_o),
        .ce_rom_read_and_D(ce_rom_read_and_D_o),

        // rom 存储器的地址
        .addr_rom_C(addr_rom_C_o),
        .addr1_rom_Occ(addr1_rom_Occ_o),
        .addr2_rom_Occ(addr2_rom_Occ_o),
        .addr_rom_read_and_D(addr_rom_read_and_D_o),
    
        // 存储器数据输入
        .d_i(d_i_i),             // rom_read_and_D
        .read_i(read_i_i),       // rom_read_and_D
        .data_1(data_1_i),       // rom_Occ
        .data_2(data_2_i),       // rom_Occ
        .data(data_i),           // rom_C
    
        // 输出给下一个模块的数据
        .position_out(),
        .addr_out(),
        .i_out(),
        .z_out(),
        .k_out(),
        .l_out(),
        .d_i_out(),            
        .read_i_out(),          
        .data_1_out(),         
        .data_2_out(),         
        .C_out()
    );


endmodule
