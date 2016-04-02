`timescale 1ns / 1ps

module calScore(
	input wire clk,
	input wire [1:0] status,
	input wire [15:0] bird_x,
	input wire [15:0] pipe1x, pipe2x, pipe3x, pipe4x,
	output reg [15:0] score);

	initial 
	begin
		score <= 0;
	end
	
	always @(posedge clk)
	begin
		if (status == 2'b00)
			begin
				score <= 0;
			end
		if (status == 2'b01)
			begin
				if (pipe1x == bird_x || pipe2x == bird_x || pipe3x == bird_x || pipe4x == bird_x )
				score <= score + 1'b1;
			end
	end

endmodule
