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


// 2 通道仲裁器

module round_robin_arbiter_2(
    input            rst_n,
	input            clk,
	input      [1:0] req,
	output reg [1:0] grant
    );

reg		    rotate_ptr;
reg [1:0]   next_grant;

always @(*) begin
    next_grant <= 2'b00;

    // 无请求
    if(req[0] + req[1] == 0) begin
        
    end
    // 当前只有一个请求
    if(req[0] + req[1] == 1) begin
        next_grant <= req;
    end
    // 当前有多个请求
    else  begin
        case (rotate_ptr)
            2'd1: begin
                case (1'b1)
                    req[1]: next_grant[1] <= 1'b1;
                    req[0]: next_grant[0] <= 1'b1;
                    default: begin
                    end
                endcase
            end
            2'd0: begin
                case (1'b1)
                    req[0]: next_grant[0] <= 1'b1;
                    req[1]: next_grant[1] <= 1'b1;
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
	if (!rst_n)	grant <= 2'b0;
	else		    grant <= next_grant;
end

always @ (posedge clk)
begin
	if (!rst_n)
		rotate_ptr <= 1'b0;
	else 
		case (1'b1) // synthesis parallel_case
			grant[0]: rotate_ptr <= 1'd1;
			grant[1]: rotate_ptr <= 1'd0;
		endcase
end
endmodule

