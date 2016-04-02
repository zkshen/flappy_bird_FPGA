`timescale 1ns / 1ps

module clkdiv(
	input wire clk, 
	input wire clr, 
	output wire clk25);

	reg [1:0] count;
	
	initial 
		begin
			count <= 0;
		end
	
	always @(posedge clk or posedge clr)
		if (clr == 1'b1) count <= 0;
		else count <= count + 2'b01;
	
	assign clk25 = count[1];
endmodule

