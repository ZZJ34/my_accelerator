`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/11 11:46:45
// Design Name: 加速器
// Module Name: accelerator_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//           包含：
//               加速器状态控制 accelerator_fsm
//                   寄存器文件 regfile_InexRecur 和 regfile_state
//                   存储器文件 rom_read_and_D
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module accelerator_top(
    input clk,           // 时钟
    input rst_n,         // 复位
    input is_start,      // 开始执行
    // rom_C
    output       ce_rom_C_o,
    output [1:0] addr_rom_C_o,
    input  [7:0] data_i,
    // rom_C
    output       ce_rom_Occ_o,
    output [7:0] addr1_rom_Occ_o,
    output [7:0] addr2_rom_Occ_o,
    input  [31:0] data_1_i,
    input  [31:0] data_2_i,
    // regfile_InexRecur 的随机写端口
    input        ran_we_InexRecur,
    input [11:0] ran_w_addr_InexRecur,
    input [31:0] ran_w_data_InexRecur,
    // regfile_state 的随机写端口
    input        ran_we_state_external,
    input [11:0] ran_w_addr_state_external,
    input [17:0] ran_w_data_state_external
    );
    
    // accelerator_fsm & regfile_InexRecur => read
    wire seq_re_InexRecur;
    wire ran_re_InexRecur;
    wire [11:0] ran_r_addr_InexRecur;
    wire [31:0] out_r_data_InexRecur;

    // accelerator_fsm & regfile_InexRecur => write
    wire seq_we_InexRecur;
    // wire ran_we_InexRecur;
    // wire [11:0] ran_w_addr_InexRecur;
    // wire [31:0] ran_w_data_InexRecur;
    wire [31:0] seq_w_data_InexRecur;


    // regfile_state/regfile_InexRecur & accelerator_fsm => read
    wire [11:0] out_r_addr;

    
    // accelerator_fsm & regfile_state => read
    wire seq_re_state;
    wire ran_re_state;
    wire [11:0] ran_r_addr_state;
    wire [17:0] out_r_data_state;
    
    // accelerator_fsm & regfile_state => write
    wire seq_we_state;
    wire ran_we_state_interior;
    wire ran_we_state;
    wire [11:0] ran_w_addr_state_interior;
    wire [11:0] ran_w_addr_state;
    wire [17:0] ran_w_data_state_interior;
    wire [17:0] ran_w_data_state;
    wire [17:0] seq_w_data_state;

    // accelerator_fsm & rom_read_and_D => read
    wire ce_rom_read_and_D;
    wire [7:0] addr_rom_read_and_D;
    wire [7:0] d_i;
    wire [1:0] read_i; 


    assign ran_we_state = is_start == 0 ? ran_we_state_external : ran_w_addr_state_interior;
    assign ran_w_addr_state = is_start == 0 ? ran_w_addr_state_external : ran_w_addr_state_interior;
    assign ran_w_data_state = is_start == 0 ? ran_w_data_state_external : ran_w_data_state_interior;

    accelerator_fsm accelerator_fsm_inst(
        .clk(clk),
        .rst_n(rst_n),
        .is_start(is_start),

        //存储器相关接口
        .re_reg_InexRecur_seq_o(seq_re_InexRecur),        // regfile_InexRecur 顺序读使能
        .re_reg_InexRecur_ran_o(ran_re_InexRecur),        // regfile_InexRecur 随机读使能
        .r_reg_InexRecur_addr_o(ran_r_addr_InexRecur),    // regfile_InexRecur 随机读地址
        .InexRecur_addr_i(out_r_addr),                    // regfile_InexRecur 当前地址 
        .InexRecur_data_i(out_r_data_InexRecur),          // regfile_InexRecur 当前数据

        .re_reg_state_seq_o(seq_re_state),        // regfile_state 顺序读使能
        .re_reg_state_ran_o(ran_re_state),        // regfile_state 随机读使能
        .r_reg_state_addr_o(ran_r_addr_state),    // regfile_state 随机读地址
        .state_addr_i(),                          // regfile_state 当前地址（ InexRecur 和 state 的数据一一对应，知道一个当前地址即可）
        .state_data_i(out_r_data_state),          // regfile_state 当前数据

        .ce_rom_C_o(ce_rom_C_o),
        .ce_rom_Occ_o(ce_rom_Occ_o),
        .ce_rom_read_and_D_o(ce_rom_read_and_D),

        .addr_rom_C_o(addr_rom_C_o),
        .addr1_rom_Occ_o(addr1_rom_Occ_o),
        .addr2_rom_Occ_o(addr2_rom_Occ_o),
        .addr_rom_read_and_D_o(addr_rom_read_and_D),

        .d_i_i(d_i),                // rom_read_and_D
        .read_i_i(read_i),          // rom_read_and_D
        .data_1_i(data_1_i),        // rom_Occ
        .data_2_i(data_2_i),        // rom_Occ
        .data_i(data_i),            // rom_C

        .seq_we_state_o(seq_we_state),
        .seq_we_InexRecur_o(seq_we_InexRecur),

        .seq_w_data_state_o(seq_w_data_state),
        .seq_w_data_InexRecur_o(seq_w_data_InexRecur),

        .ran_we_state_o(ran_we_state_interior),
        .ran_we_InexRecur_o(),                      

        .ran_w_data_state_o(ran_w_data_state_interior),
        .ran_w_data_InexRecur_o(),    

        .ran_w_addr_state_o(ran_w_addr_state_interior),
        .ran_w_addr_InexRecur_o()     
    );

    /*
    * 回写模块不涉及 regfile_InexRecur 的随机写
    * 将 regfile_InexRecur 的随机写端口暴露给顶层，实现初始数据的写入
    *
    * 也需要将 regfile_state 的随机写端口暴露给顶层，实现初始数据的写入
    */

    regfile_InexRecur regfile_InexRecur_inst(
        .clk(clk),
        .rst_n(rst_n),
    
        .seq_we(seq_we_InexRecur),              
        .seq_w_data(seq_w_data_InexRecur),            

        .ran_we(ran_we_InexRecur),
        .ran_w_addr(ran_w_addr_InexRecur),
        .ran_w_data(ran_w_data_InexRecur),

        .seq_re(seq_re_InexRecur),             

        .ran_re(ran_re_InexRecur),             
        .ran_r_addr(ran_r_addr_InexRecur),  

        .r_addr(out_r_addr), 
        .r_data(out_r_data_InexRecur)  
    );

    regfile_state regfile_state_inst(
        .clk(CLK),
        .rst_n(rst_n),
    
        .seq_we(seq_we_state), 
        .seq_w_data(seq_w_data_state),             

        .ran_we(ran_we_state),                 
        .ran_w_addr(ran_w_addr_state),             
        .ran_w_data(ran_w_data_state),             

        .seq_re(seq_re_state),                 

        .ran_re(ran_re_state),                 
        .ran_r_addr(ran_r_addr_state),      
   
        .r_addr(),      
        .r_data(out_r_data_state)       
    );

    rom_read_and_D rom_read_and_D_inst(
        .ce(ce_rom_read_and_D),
        .addr(addr_rom_read_and_D),
        .d_i(d_i),
        .read_i(read_i)  
    );


endmodule
