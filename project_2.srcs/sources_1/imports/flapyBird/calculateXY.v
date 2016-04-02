`timescale 1ns / 1ps
module calculateXY(
	input wire clk,
	input wire [9:0] hc, vc,
	output wire [15:0] px, py
    );
	
	parameter hbp = 16'd144;
	parameter hfp = 16'd784;
	parameter vbp = 16'd31;
	parameter vfp = 16'd511;
	
	reg [15:0] x, y;
	
	initial
		begin
			x <= 0;
			y <= 0;
		end

	
	always @(posedge clk)
		if ((hbp < hc) && (hc < hfp) && (vbp < vc) && (vc < vfp))
			begin
				x <= hc - hbp;
				y <= vfp - (vc - vbp);
			end
		else
			begin
				x <= hfp;
				y <= vfp;
			end

	assign px = x;
	assign py = y;
endmodule
