`timescale 1ns / 1ps

module pipeControl(
	input wire clk,
	input wire [1:0] status,
   input wire [1:0] id,
    input wire [7:0]  seed,
	output reg [15:0] x,
	output reg [15:0] t,
	output reg [15:0] b);
	
	parameter v = 16'd1;
	parameter scapeWidth = 15'd160;
	parameter startPosition = 16'd700;
	
	
	initial 
		begin
			x <= 16'b0;
			t <= 16'b0;
			b <= 16'b0;
		end
		
	always @(posedge clk)
	begin
		if (status == 2'b00)
			begin
				case (id)
					2'b00: 
						begin
							x = startPosition;
							b = seed+8'd50;
						end
					2'b01: 
						begin
							x = startPosition + 16'd185;
							b = seed+8'd100;
						end
					2'b10: 
						begin
							x = startPosition + 16'd370;
							b = seed+8'd120;
						end
					2'b11: 
						begin
							x = startPosition + 16'd555;
							b = seed+8'd30;
						end
				endcase
				t = b + scapeWidth;
			end
		if (status == 2'b01)
			begin
				x = x - v;
				if (x + 16'd35 == 16'd0) 
					begin
						x = 16'd705;
						
					case (id)
					2'b00: b = b + 16'd111;
					2'b01: b = b + 16'd58;
					2'b10: b = b + 4'd7;
					2'b11: b = b + 16'd170;
				endcase
				if (b > 16'd400) b = b - 16'd330;
				t = b + scapeWidth;
					end
			end
	end

endmodule
