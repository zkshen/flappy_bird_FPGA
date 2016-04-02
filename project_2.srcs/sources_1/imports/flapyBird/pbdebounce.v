`timescale 1ns / 1ps

module pbdebounce
	(input wire clk,
	input wire button,
	output reg pbreg);
	
	reg [5:0] pbshift;
	wire clk_1ms;
	
	timer_1ms m0(clk, clk_1ms);
	initial 
		begin
			pbreg = 0;
			pbshift = 0;
		end
	
	always@(posedge clk_1ms) begin
		pbshift=pbshift<<1;//×óÒÆ1Î»
		pbshift[0]=button;
		if (pbshift==0) pbreg=0;
		if (pbshift==6'hFF)	pbreg=1;
end
endmodule
