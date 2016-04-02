`timescale 1ns / 1ps

module calpos_bird(
	input wire [15:0] x, y,
	input wire [15:0] width, height,
	input wire [15:0] px, py,
	output wire [31:0] addr
    );
	
	wire [31:0] op1, op2;
	wire [15:0] row, col;
	assign row = height + y - py;
	assign col = px - x;
	assign op1 =  row * width;
	assign addr = op1 + col;
endmodule
