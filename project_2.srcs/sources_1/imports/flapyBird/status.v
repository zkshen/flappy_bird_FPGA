`timescale 1ns / 1ps

module status(
	input wire clk,
	input wire reset,
	input wire start,
	input wire failFlag,
	input wire fallOut,
	input wire reStart,
	output reg [1:0] nowStatus
    );
	
	initial 
		begin
			nowStatus = 0;
		end

	always @(posedge clk)
	begin
		if (reset) nowStatus = 2'b00;
		case(nowStatus)
			2'b00: 
				if (start) nowStatus = 2'b01;
			2'b01: 
				if (failFlag) nowStatus = 2'b10;
			2'b10:
				if (fallOut) nowStatus = 2'b11;
			2'b11:
				if (reStart) nowStatus = 2'b00;
			default:
				nowStatus = 2'b01;
		endcase
	end
endmodule
