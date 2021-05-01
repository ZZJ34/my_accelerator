`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 19:48:03
// Design Name: 
// Module Name: data_path
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 数据通路，处理器核心与存储器的沟通桥梁
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module data_path(
    input rst_n,
    input clk,
    
    input storage_ce_1,
    input [7:0] storage_addr_1,

    input storage_ce_2,
    input [7:0] storage_addr_2,

    input storage_ce_3,
    input [7:0] storage_addr_3,

    input storage_ce_4,
    input [7:0] storage_addr_4,


    output [31:0] data_to_alu_1,
    output done_1,

    output [31:0] data_to_alu_2,
    output done_2,

    output [31:0] data_to_alu_3,
    output done_3,

    output [31:0] data_to_alu_4,
    output done_4

    );

    wire req_1;
    wire req_2;
    wire req_3;
    wire req_4;
    wire [3:0] grant;

    wire storage_valid_1;
    wire storage_valid_2;
    wire storage_valid_3;
    wire storage_valid_4;
    reg storage_valid_fifo;

    wire [11:0] data_to_fifo_1;
    wire [11:0] data_to_fifo_2;
    wire [11:0] data_to_fifo_3;
    wire [11:0] data_to_fifo_4;

    reg [11:0] data_to_fifo;

    // fifo 和 fifo_between_rom 中间件
    wire        is_empty;
    wire [11:0] data_to_middleware;
    wire        rd_en;

    // fifo_between_rom 中间件和 rom
    wire        ce;
    wire [7:0]  addr;
    wire        valid;
    wire [31:0] data;


    // 数据返回
    wire        result_valid;
    wire [35:0] result;

    
    // 存储控制器1
    storage_control #(.CURRENT_NUMBER(1), .CURRENT_GRANT(4'b0001)) storage_control_inst_1(  
        .rst_n(rst_n),
        .clk(clk),

        .storage_ce(storage_ce_1),      
        .storage_addr(storage_addr_1),    
        .number_and_addr(data_to_fifo_1), 
        .storage_valid(storage_valid_1),

        .data_from_storage(result),  // 来自于存储器的数据
        .data_to_alu(data_to_alu_1), // 输出给处理核心的数据

        .grant(grant),        
        .req(req_1),                 // 占用请求

        .txn_done(result_valid),     // 数据传输完成（来自存储器）
        .done(done_1)                // 数据传输完成（给向处理器）
    );

    // 存储控制器2
    storage_control #(.CURRENT_NUMBER(2), .CURRENT_GRANT(4'b0010)) storage_control_inst_2(  
        .rst_n(rst_n),
        .clk(clk),

        .storage_ce(storage_ce_2),      
        .storage_addr(storage_addr_2),    
        .number_and_addr(data_to_fifo_2),
        .storage_valid(storage_valid_2),

        .data_from_storage(result), // 来自于存储器的数据
        .data_to_alu(data_to_alu_2),// 输出给处理核心的数据

        .grant(grant),        
        .req(req_2),                // 占用请求

        .txn_done(result_valid),    // 数据传输完成（来自存储器）
        .done(done_2)               // 数据传输完成（给向处理器）
    );

    // 存储控制器3
    storage_control #(.CURRENT_NUMBER(3), .CURRENT_GRANT(4'b0100)) storage_control_inst_3(  
        .rst_n(rst_n),
        .clk(clk),

        .storage_ce(storage_ce_3),      
        .storage_addr(storage_addr_3),    
        .number_and_addr(data_to_fifo_3),
        .storage_valid(storage_valid_3),

        .data_from_storage(result), // 来自于存储器的数据
        .data_to_alu(data_to_alu_3),// 输出给处理核心的数据

        .grant(grant),        
        .req(req_3),                // 占用请求

        .txn_done(result_valid),    // 数据传输完成（来自存储器）
        .done(done_3)               // 数据传输完成（给向处理器）
    );

    // 存储控制器4
    storage_control #(.CURRENT_NUMBER(4), .CURRENT_GRANT(4'b1000)) storage_control_inst_4(  
        .rst_n(rst_n),
        .clk(clk),

        .storage_ce(storage_ce_4),      
        .storage_addr(storage_addr_4),    
        .number_and_addr(data_to_fifo_4), 
        .storage_valid(storage_valid_4),

        .data_from_storage(result), // 来自于存储器的数据
        .data_to_alu(data_to_alu_4),// 输出给处理核心的数据

        .grant(grant),        
        .req(req_4),                // 占用请求

        .txn_done(result_valid),    // 数据传输完成（来自存储器）
        .done(done_4)               // 数据传输完成（给向处理器）
    );

    // 4通道仲裁器
    arbiter_4_wrapper arbiter_4_wrapper_inst(
        .clk(clk),
        .rst_n(rst_n),

        .req_1(req_1),
        .req_2(req_2),
        .req_3(req_3),
        .req_4(req_4),

        .grant(grant)
    );


    always @(*) begin
        storage_valid_fifo <= storage_valid_1 | storage_valid_2 | storage_valid_3 | storage_valid_4;

        case (1'b1)
            storage_valid_1: data_to_fifo <= data_to_fifo_1;
            storage_valid_2: data_to_fifo <= data_to_fifo_2;
            storage_valid_3: data_to_fifo <= data_to_fifo_3;
            storage_valid_4: data_to_fifo <= data_to_fifo_4;
            default: begin
                data_to_fifo <= 0;
            end
        endcase
    end

    /*
    * 当 empty 失效时，dout 数据有效
    * 使能 rd_en , 刷新 dout 数据
    */
    // fifo
    fifo_generator_0 fifo_inst(
        .srst(~rst_n),
        .clk(clk),
        .din(data_to_fifo),
        .wr_en(storage_valid_fifo),
        .rd_en(rd_en),
        .dout(data_to_middleware),
        .full(),
        .empty(is_empty)
    );
    
    // fifo_between_rom 中间件
    fifo_between_rom fifo_between_rom_inst(
        .clk(clk),
        .rst_n(rst_n),

        .is_empty(is_empty),
        .data_from_fifo(data_to_middleware),
        .rd_en(rd_en),

        .base_addr(0),

        .data_from_rom(data),
        .data_valid(valid),
        .addr(addr),
        .ce(ce),

        .result_valid(result_valid),
        .result(result)
    
    );

    // rom_Occ
    rom_Occ rom_Occ_inst(
        .ce(ce),
        .addr(addr),
        .data(data),
        .valid(valid)
    );

endmodule
