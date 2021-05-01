`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/26 12:34:36
// Design Name: 
// Module Name: round_robin_arbiter
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

// 总线上挂4个信号A,B,C,D，仲裁信号grant[3:0]。
// grant[3:0]=4’b0001   A获得总线
// grant[3:0]=4’b0010   B获得总线
// grant[3:0]=4’b0100   C获得总线
// grant[3:0]=4’b1000   D获得总线
// 总线轮询算法:
// a.如果当前只有一个信号请求，则处理.
// b.如果没有请求，则无仲裁信号输出.
// c.如果同时有多个信号请求，考虑上一个请求信号，
// 如果上一个请求信号是A，那么轮询的是BCDA，
// 如果上一个请求信号是B，那么轮询的是CDAB，
// 如果上一个请求信号是C，那么轮询的是DABC，
// 如果上一个请求信号是D，那么轮询的是ABCD，

// 4 通道仲裁器

module round_robin_arbiter_4(
    input            rst_n,
	input            clk,
	input      [3:0] req,
	output reg [3:0] grant
    );

reg	[1:0]	rotate_ptr;
reg [3:0]   next_grant;

always @(*) begin
    next_grant <= 4'b0000;

    // 无请求
    if(req[0] + req[1] + req[2] + req[3] == 0) begin
        
    end
    // 当前只有一个请求
    if(req[0] + req[1] + req[2] + req[3] == 1) begin
        next_grant <= req;
    end
    // 当前有多个请求
    else  begin
        case (rotate_ptr)
            // 轮询顺序 BCDA
            2'd1: begin
                case (1'b1)
                    req[1]: next_grant[1] <= 1'b1;
                    req[2]: next_grant[2] <= 1'b1;
                    req[3]: next_grant[3] <= 1'b1;
                    req[0]: next_grant[0] <= 1'b1;
                    default: begin
                    end
                endcase
            end
            // 轮询顺序 CDAB
            2'd2: begin
                case (1'b1)
                    req[2]: next_grant[2] <= 1'b1;
                    req[3]: next_grant[3] <= 1'b1;
                    req[0]: next_grant[0] <= 1'b1;
                    req[1]: next_grant[1] <= 1'b1;
                    default: begin
                    end
                endcase
            end
            // 轮询顺序 DABC
            2'd3: begin
                case (1'b1)
                    req[3]: next_grant[3] <= 1'b1;
                    req[0]: next_grant[0] <= 1'b1;
                    req[1]: next_grant[1] <= 1'b1;
                    req[2]: next_grant[2] <= 1'b1;
                    default: begin
                    end
                endcase
            end
            // 轮询顺序 ABCD
            2'd0: begin
                case (1'b1)
                    req[0]: next_grant[0] <= 1'b1;
                    req[1]: next_grant[1] <= 1'b1;
                    req[2]: next_grant[2] <= 1'b1;
                    req[3]: next_grant[3] <= 1'b1;
                    default: begin
                    end
                endcase
            end
            default: begin
            end
        endcase
    end
    
end

always @ (posedge clk)
begin
	if (!rst_n)	grant <= 4'b0;
	else		    grant <= next_grant;
end

always @ (posedge clk)
begin
	if (!rst_n)
		rotate_ptr[1:0] <= 2'b0;
	else 
		case (1'b1) // synthesis parallel_case
			grant[0]: rotate_ptr[1:0] <= 2'd1;
			grant[1]: rotate_ptr[1:0] <= 2'd2;
			grant[2]: rotate_ptr[1:0] <= 2'd3;
			grant[3]: rotate_ptr[1:0] <= 2'd0;
		endcase
end
endmodule

