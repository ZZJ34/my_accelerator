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
    output [7:0] addr_rom_Occ_o,
    // output [7:0] addr2_rom_Occ_o,                          // 不用
    output [7:0] addr_rom_read_and_D_o,

    input [7:0] d_i_i,             // rom_read_and_D
    input [1:0] read_i_i,          // rom_read_and_D
    input [31:0] data_1_i,         // rom_Occ
    // input [31:0] data_2_i,         // rom_Occ               // 不用
    input [7:0] data_i,            // rom_C

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

    localparam GET_DATA_2= 3'b011;   // 取数据[Occ]                      （存在对应执行模块）
    localparam GET_DATA_3= 3'b100;   // 取数据[Occ]                      （存在对应执行模块）
    
    // 状态控制输出，使能不同的模块
    wire [2:0] state_out;

    wire is_find_control;
    wire is_finish_control;
    wire is_get_data_in_Occ;
    
    // 模块之间的互连线
    // get_param 到 get_data_1
    wire [7:0] i_param_to_data1;
    wire [7:0] z_param_to_data1;
    wire [7:0] k_param_to_data1;
    wire [7:0] l_param_to_data1;
    wire [11:0] addr_param_to_data1;
    wire [4:0] position_param_to_data1;
    
    // get_data_1 到 get_data_2 和 ex
    wire [7:0] i_data1_to_data2;
    wire [7:0] z_data1_to_data2;
    wire [7:0] k_data1_to_data2;
    wire [7:0] l_data1_to_data2;
    wire [11:0] addr_data1_to_data2;
    wire [4:0] position_data1_to_data2;
    wire [7:0] d_i_data1_to_ex;
    wire [1:0] read_i_data1_to_ex;
    wire [7:0] C_data1_to_ex;

    // get_data_2 到 get_data_3 和 ex
    wire [7:0] i_data2_to_data3;
    wire [7:0] z_data2_to_data3;
    wire [7:0] k_data2_to_data3;
    wire [7:0] l_data2_to_data3;
    wire [11:0] addr_data2_to_data3;
    wire [4:0] position_data2_to_data3;
    wire [7:0] data_1_data2_to_ex;

    // get_data_3 到 ex
    wire [7:0] i_data3_to_ex;
    wire [7:0] z_data3_to_ex;
    wire [7:0] k_data3_to_ex;
    wire [7:0] l_data3_to_ex;
    wire [11:0] addr_data3_to_ex;
    wire [4:0] position_data3_to_ex;
    wire [7:0] data_2_data3_to_ex;

    wire [7:0] i_datax_to_ex;
    wire [7:0] z_datax_to_ex;
    wire [7:0] k_datax_to_ex;
    wire [7:0] l_datax_to_ex;
    wire [11:0] addr_datax_to_ex;
    wire [4:0] position_datax_to_ex;

    assign i_datax_to_ex = !is_get_data_in_Occ ? i_data1_to_data2 : i_data3_to_ex;
    assign z_datax_to_ex = !is_get_data_in_Occ ? z_data1_to_data2 : z_data3_to_ex;
    assign k_datax_to_ex = !is_get_data_in_Occ ? k_data1_to_data2 : k_data3_to_ex;
    assign l_datax_to_ex = !is_get_data_in_Occ ? l_data1_to_data2 : l_data3_to_ex;
    assign addr_datax_to_ex = !is_get_data_in_Occ ? addr_data1_to_data2 : addr_data3_to_ex;
    assign position_datax_to_ex = !is_get_data_in_Occ ? position_data1_to_data2 : position_data3_to_ex;

    // ex 到 wb
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

    // rom 存储器信号
    wire ce_rom_Occ_from_data2;
    wire ce_rom_Occ_from_data3;

    assign ce_rom_Occ_o = state_out == GET_DATA_2 ? ce_rom_Occ_from_data2 : (state_out == GET_DATA_3 ? ce_rom_Occ_from_data3 : 0 );


    wire [7:0] addr_rom_Occ_from_data2;
    wire [7:0] addr_rom_Occ_from_data3;

    assign addr_rom_Occ_o = state_out == GET_DATA_2 ? addr_rom_Occ_from_data2 : (state_out == GET_DATA_3 ? addr_rom_Occ_from_data3 : 0 );

    // 状态控制
    state_control state_control_inst(
        .clk(clk),
        .rst_n(rst_n),
        .is_finish(is_finish_control),            // 是否已完成所有迭代
        .is_start(is_start),                      // 是否开始开始
        .is_find(is_find_control),                // 是否找到尚未完成的参数
        .is_get_data_in_Occ(is_get_data_in_Occ),  // 是否获取Occ中的数据
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
        .i_out(i_param_to_data1),
        .z_out(z_param_to_data1),
        .k_out(k_param_to_data1),
        .l_out(l_param_to_data1),
    
        // 当前参数地址
        .addr(addr_param_to_data1),

        // 当前参数执行位置
        .position(position_param_to_data1),
    
        // 是否找到未执行完成的参数
        .is_find(is_find_control)
    );
    
    // 取数据1
    get_data_1 get_data_1_inst(
        .rst_n(rst_n),               // 复位信号

        .en_get_data_1(state_out),     // 该模块使能

        // 四个参数
        .i_in(i_param_to_data1),
        .z_in(z_param_to_data1),
        .k_in(k_param_to_data1),
        .l_in(l_param_to_data1),
    
        // 当前参数地址
        .addr(addr_param_to_data1),

        // 当前参数执行位置
        .position(position_param_to_data1),

        // rom 存储器的使能信号
        .ce_rom_C(ce_rom_C_o),
        .ce_rom_read_and_D(ce_rom_read_and_D_o),

        // rom 存储器的地址
        .addr_rom_C(addr_rom_C_o),
        .addr_rom_read_and_D(addr_rom_read_and_D_o),
    
        // 存储器数据输入
        .d_i(d_i_i),             // rom_read_and_D
        .read_i(read_i_i),       // rom_read_and_D
        .data(data_i),           // rom_C
    
        // 输出给下一个模块的数据
        .position_out(position_data1_to_data2),
        .addr_out(addr_data1_to_data2),
        .i_out(i_data1_to_data2),
        .z_out(z_data1_to_data2),
        .k_out(k_data1_to_data2),
        .l_out(l_data1_to_data2),
        .d_i_out(d_i_data1_to_ex),            
        .read_i_out(read_i_data1_to_ex),               
        .C_out(C_data1_to_ex),

        .get_data_in_Occ(is_get_data_in_Occ)
    );

    // 取数据2
    get_data_2 get_data_2_inst(
        .rst_n(rst_n),               // 复位信号

        .en_get_data_2(state_out),  // 该模块使能
    
        // 上一个模块的输出
        // 四个参数
        .i_in(i_data1_to_data2),
        .z_in(z_data1_to_data2),
        .k_in(k_data1_to_data2),
        .l_in(l_data1_to_data2),
        // 当前参数地址
        .addr(addr_data1_to_data2),
        // 当前参数执行位置
        .position(position_data1_to_data2),

        // rom 存储器的使能信号
        .ce_rom_Occ(ce_rom_Occ_from_data2),

        // rom 存储器的地址
        .addr_rom_Occ(addr_rom_Occ_from_data2),
    
        // 存储器数据输入
        .data(data_1_i),         // rom_Occ
    
    
        // 输出给下一个模块的数据
        .position_out(position_data2_to_data3),
        .addr_out(addr_data2_to_data3),
        .i_out(i_data2_to_data3),
        .z_out(z_data2_to_data3),
        .k_out(k_data2_to_data3),
        .l_out(l_data2_to_data3),
        .data_1_out(data_1_data2_to_ex)
    ); 

    // 取数据3
    get_data_3 get_data_3_inst(
        .rst_n(rst_n),               // 复位信号

        .en_get_data_3(state_out),  // 该模块使能
    
        // 上一个模块的输出
        // 四个参数
        .i_in(i_data2_to_data3),
        .z_in(z_data2_to_data3),
        .k_in(k_data2_to_data3),
        .l_in(l_data2_to_data3),
        // 当前参数地址
        .addr(addr_data2_to_data3),
        // 当前参数执行位置
        .position(position_data2_to_data3),

        // rom 存储器的使能信号
        .ce_rom_Occ(ce_rom_Occ_from_data3),

        // rom 存储器的地址
        .addr_rom_Occ(addr_rom_Occ_from_data3),
    
        // 存储器数据输入
        .data(data_1_i),         // rom_Occ
    
        // 输出给下一个模块的数据
        .position_out(position_data3_to_ex),
        .addr_out(addr_data3_to_ex),
        .i_out(i_data3_to_ex),
        .z_out(z_data3_to_ex),
        .k_out(k_data3_to_ex),
        .l_out(l_data3_to_ex),
        .data_2_out(data_2_data3_to_ex)
    );
    
    // 判断/执行
    ex ex_inst(
        .rst_n(rst_n),       // 复位

        .en_ex(state_out),   // 该模块使能

        // 来自上一个模块的输出
        .position_in(position_datax_to_ex),
        .addr_in(addr_datax_to_ex),
        .i_in(i_datax_to_ex),
        .z_in(z_datax_to_ex),
        .k_in(k_datax_to_ex),
        .l_in(l_datax_to_ex),
        .d_i_in(d_i_data1_to_ex),
        .read_i_in(read_i_data1_to_ex),
        .data_1_in(data_1_data2_to_ex),
        .data_2_in(data_2_data3_to_ex),
        .C_in(C_data1_to_ex),

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
