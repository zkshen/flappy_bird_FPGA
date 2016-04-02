`timescale 1ns / 1ps

module running(
	input wire clk,
	input wire reset,
	input wire flyUp,
	input wire [1:0] status,
	output wire [15:0] bird_x, bird_y
    );
	
	
	localparam a = 19'd1;
	localparam upSpeed = 19'd30;

	reg [18:0] v;
	reg [15:0] s;
	reg [1:0] cntFlyUp;
	reg [1:0] preStatus;
	reg [9:0] delay;
	
	initial
	begin
		v <= 0;
		s <= 240;
		cntFlyUp <= 0;
		preStatus <= 0;
	end
	
	always @(posedge clk)
	begin
		cntFlyUp = cntFlyUp << 1;
		cntFlyUp[0] = flyUp;
	end
	
	always @(posedge clk)
		begin
			if (status == 2'b00)
				begin
					v = 0;
					s = 240;
				end
			if (status == 2'b01)
				begin
					if (status != preStatus) delay = 0;
					else if (delay < 10'd120) delay = delay + 1;
					else 
						begin
							if (cntFlyUp != 2'b01) v = v - a;
							else v = upSpeed;
							s = s + v[18:3];
						end
				end
			if (status == 2'b10)
				begin
					if (status != preStatus) v = 0;
					v = v - a;
					s = s + v[18:3];
				end
			preStatus = status;
		end
			
	assign bird_x = 200;
	assign bird_y = s;
	
endmodule
