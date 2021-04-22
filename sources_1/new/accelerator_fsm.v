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
    input [7:0] data_i,             // rom_C

    output seq_we_state_o,
    output seq_we_InexRecur_o,

    output [17:0] seq_w_data_state_o,
    output [31:0] seq_w_data_InexRecur_o,

    output ran_we_state_o,
    output ran_we_InexRecur_o,               

    output [17:0] ran_w_data_state_o,
    output [31:0] ran_w_data_InexRecur_o,    

    output [11:0] ran_w_addr_state_o,
    output [11:0] ran_w_addr_InexRecur_o     
    );
    
    // 状态控制输出，使能不同的模块
    wire [2:0] state_out;

    wire is_find_control;
    wire is_finish_control;
    
    // 模块之间的互连线
    wire [7:0] i_param_to_data;
    wire [7:0] z_param_to_data;
    wire [7:0] k_param_to_data;
    wire [7:0] l_param_to_data;
    wire [11:0] addr_param_to_data;
    wire [4:0] position_param_to_data;

    wire [7:0] i_data_to_ex;
    wire [7:0] z_data_to_ex;
    wire [7:0] k_data_to_ex;
    wire [7:0] l_data_to_ex;
    wire [11:0] addr_data_to_ex;
    wire [4:0] position_data_to_ex;
    wire [7:0] d_i_data_to_ex;
    wire [1:0] read_i_data_to_ex;
    wire [7:0] data_1_data_to_ex;
    wire [7:0] data_2_data_to_ex;
    wire [7:0] C_in_data_to_ex;

    wire [11:0] current_addr_ex_to_wb;
    wire [7:0]  current_k_ex_to_wb;
    wire [7:0]  current_l_ex_to_wb;
    wire over_1_ex_to_wb;
    wire over_2_ex_to_wb;
    wire over_3_ex_to_wb;
    wire en_new_position_ex_to_wb;
    wire [4:0] new_position_ex_to_wb;
    wire new_call_i_ex_to_wb;
    wire [7:0] i_new_ex_to_wb;
    wire [7:0] z_new_ex_to_wb;
    wire [7:0] k_new_ex_to_wb;
    wire [7:0] l_new_ex_to_wb;

    // 状态控制
    state_control state_control_inst(
        .clk(clk),
        .rst_n(rst_n),
        .is_finish(is_finish_control),     // 是否已完成所有迭代
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
    get_data_1 get_data_1_inst(
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
        .position_out(position_data_to_ex),
        .addr_out(addr_data_to_ex),
        .i_out(i_data_to_ex),
        .z_out(z_data_to_ex),
        .k_out(k_data_to_ex),
        .l_out(l_data_to_ex),
        .d_i_out(d_i_data_to_ex),            
        .read_i_out(read_i_data_to_ex),          
        .data_1_out(data_1_data_to_ex),         
        .data_2_out(data_2_data_to_ex),         
        .C_out(C_in_data_to_ex)
    );
    
    // 判断/执行
    ex ex_inst(
        .rst_n(rst_n),       // 复位

        .en_ex(state_out),   // 该模块使能

        // 来自上一个模块的输出
        .position_in(position_data_to_ex),
        .addr_in(addr_data_to_ex),
        .i_in(i_data_to_ex),
        .z_in(z_data_to_ex),
        .k_in(k_data_to_ex),
        .l_in(l_data_to_ex),
        .d_i_in(d_i_data_to_ex),
        .read_i_in(read_i_data_to_ex),
        .data_1_in(data_1_data_to_ex),
        .data_2_in(data_2_data_to_ex),
        .C_in(C_in_data_to_ex),

        // 该模块输出
        .current_addr(current_addr_ex_to_wb),
        .current_k(current_k_ex_to_wb),
        .current_l(current_l_ex_to_wb),
    
        .over_1(over_1_ex_to_wb),             // 条件1中止   z < D(i)   “1”有效
        .over_2(over_2_ex_to_wb),             // 条件2中止   i < 0      “1”有效
        .over_3(over_3_ex_to_wb),             // 条件3中止  本次调用完成 “1”有效

        .en_new_position(en_new_position_ex_to_wb), // 是否更新当前参数执行位置    “1”有效
        .new_position(new_position_ex_to_wb),       // 新的执行位置

        .new_call(new_call_i_ex_to_wb),             // 调用新的循环   “1”有效
        .i_new(i_new_ex_to_wb),         
        .z_new(z_new_ex_to_wb),
        .k_new(k_new_ex_to_wb),
        .l_new(l_new_ex_to_wb),

        .finish(is_finish_control)              // 全部完成       “1”有效
    );

    // 数据回写
    write_back write_back_inst(
        .rst_n(rst_n),               // 复位

        .en_write_back(state_out), // 该模块使能

        // 上一个模块的输出
        .current_addr_i(current_addr_ex_to_wb),
        .current_k_i(current_k_ex_to_wb),
        .current_l_i(current_l_ex_to_wb),
    
        .over_1_i(over_1_ex_to_wb),               // 条件1中止   z < D(i)   “1”有效
        .over_2_i(over_2_ex_to_wb),               // 条件2中止   i < 0      “1”有效
        .over_3_i(over_3_ex_to_wb),               // 条件3中止  本次调用完成 “1”有效

        .en_new_position_i(en_new_position_ex_to_wb),   // 是否更新当前参数执行位置    “1”有效
        .new_position_i(new_position_ex_to_wb),                              // 新的执行位置

        .new_call_i(new_call_i_ex_to_wb),               // 调用新的循环   “1”有效
        .i_new_i(i_new_ex_to_wb),         
        .z_new_i(z_new_ex_to_wb),
        .k_new_i(k_new_ex_to_wb),
        .l_new_i(l_new_ex_to_wb),
   
        // 输出
        .seq_we_state(seq_we_state_o),
        .seq_we_InexRecur(seq_we_InexRecur_o),

        .seq_w_data_state(seq_w_data_state_o),
        .seq_w_data_InexRecur(seq_w_data_InexRecur_o),

        .ran_we_state(ran_we_state_o),
        .ran_we_InexRecur(ran_we_InexRecur_o),               

        .ran_w_data_state(ran_w_data_state_o),
        .ran_w_data_InexRecur(ran_w_data_InexRecur_o),      

        .ran_w_addr_state(ran_w_addr_state_o),
        .ran_w_addr_InexRecur(ran_w_addr_InexRecur_o)         
    );


endmodule
