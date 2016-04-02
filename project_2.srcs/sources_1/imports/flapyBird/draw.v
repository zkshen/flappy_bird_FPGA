`timescale 1ns / 1ps

module draw(input wire clk, 
				input wire clk_1fps,
				input wire [1:0] status, 
				input wire [15:0] px, py,
				input wire [15:0] bird_x, bird_y,
				input wire [15:0] pipe1x, pipe1t, pipe1b,
				input wire [15:0] pipe2x, pipe2t, pipe2b,
				input wire [15:0] pipe3x, pipe3t, pipe3b, 
				input wire [15:0] pipe4x, pipe4t, pipe4b,
				output reg [7:0] rgb_reg);
				
	
	parameter Height = 16'd32;
	parameter Width = 16'd45;
	parameter pipeWidth = 16'd69;
	
	wire [7:0] pipe_rgb, back_rgb;
	wire [7:0] bird_rgb0, bird_rgb1, bird_rgb2;
	wire [10:0] addr_bird0, addr_bird1, addr_bird2;
	reg [14:0] addr_pipe;
	reg [15:0] addr_back;
	reg [15:0] tmp;
	reg [2:0] cnt;
	reg [1:0] birdImgCnt, cntDir;
	wire cntClk1, cntClk2;


	wire [14:0] addrt1, addrt2, addrt3, addrt4;
	wire [14:0] addrb1, addrb2, addrb3, addrb4;
	
	
	wire [15:0] addrg1, addrg2, addrg3, addrg4, addrg5, addrg6, addrg7, addrg8;
	
	wire [15:0] bx1, by1, bx2, by2; //bird rectangle, bx1 <= bx2, by1 <= by2
	wire [15:0] px1, px2, px3, px4;
		
	assign bx1 = bird_x - 16'd22;
	assign by1 = bird_y - 16'd15;
	assign bx2 = bx1 + Width;
	assign by2 = by1 + Height;
	
	assign px1 = pipe1x - 16'd34;
	assign px2 = pipe2x - 16'd34;
	assign px3 = pipe3x - 16'd34;
	assign px4 = pipe4x - 16'd34;
	
	initial
	begin
		rgb_reg = 0;
		addr_pipe = 0;
		cnt = 0;
		birdImgCnt = 0;
		cntDir = 0;
	end
	
	always @(posedge clk_1fps)
	begin
		cnt <= cnt+1;
	end
	
	assign cntClk1 = cnt[2];
	assign cntClk2 = cnt[1];
	
	always @(posedge cntClk1)
	begin
		if (birdImgCnt == 2'b00) cntDir = 2'b1;
		if (birdImgCnt == 2'b10) cntDir = 2'b11;
		birdImgCnt = birdImgCnt + cntDir;
	end
	
	bird0 bird_unit0(.a(addr_bird0), .spo(bird_rgb0));
	bird bird_unit(.a(addr_bird1), .spo(bird_rgb1));
	bird2 bird_unit2(.a(addr_bird2), .spo(bird_rgb2));
	pipe pipe_unit(.a(addr_pipe), .spo(pipe_rgb));
	back back_unit(.a(addr_back), .spo(back_rgb));
	calpos_bird calposition_bird0(.x(bx1), .y(by1), .width(Width), .height(Height), .px(px), .py(py), .addr(addr_bird0));
	calpos_bird calposition_bird1(.x(bx1), .y(by1), .width(Width), .height(Height), .px(px), .py(py), .addr(addr_bird1));
	calpos_bird calposition_bird2(.x(bx1), .y(by1), .width(Width), .height(Height), .px(px), .py(py), .addr(addr_bird2));
	
	calpos_pipe calposition_pipe1b(.dir(1'b1) , .x(px1), .y(pipe1b), .width(16'd69), .px(px), .py(py), .addr(addrb1));
	calpos_pipe calposition_pipe2b(.dir(1'b1) , .x(px2), .y(pipe2b), .width(16'd69), .px(px), .py(py), .addr(addrb2));
	calpos_pipe calposition_pipe3b(.dir(1'b1) , .x(px3), .y(pipe3b), .width(16'd69), .px(px), .py(py), .addr(addrb3));
	calpos_pipe calposition_pipe4b(.dir(1'b1) , .x(px4), .y(pipe4b), .width(16'd69), .px(px), .py(py), .addr(addrb4));
	
	calpos_pipe calposition_pipe1t(.dir(1'b0) , .x(px1), .y(pipe1t), .width(16'd69), .px(px), .py(py), .addr(addrt1));
	calpos_pipe calposition_pipe2t(.dir(1'b0) , .x(px2), .y(pipe2t), .width(16'd69), .px(px), .py(py), .addr(addrt2));
	calpos_pipe calposition_pipe3t(.dir(1'b0) , .x(px3), .y(pipe3t), .width(16'd69), .px(px), .py(py), .addr(addrt3));
	calpos_pipe calposition_pipe4t(.dir(1'b0) , .x(px4), .y(pipe4t), .width(16'd69), .px(px), .py(py), .addr(addrt4));
	

	calpos_back calposition_back1(.dir(1'b1), .x(10'b0), .y(16'd550), .width(16'd105), .px(px), .py(py), .addr(addrg1));
	calpos_back calposition_back2(.dir(1'b1), .x(10'd105), .y(16'd550), .width(16'd105), .px(px), .py(py), .addr(addrg2));
	calpos_back calposition_back3(.dir(1'b1), .x(10'd210), .y(16'd550), .width(16'd105), .px(px), .py(py), .addr(addrg3));
	calpos_back calposition_back4(.dir(1'b1), .x(10'd315), .y(16'd550), .width(16'd105), .px(px), .py(py), .addr(addrg4));
	calpos_back calposition_back5(.dir(1'b1), .x(10'd420), .y(16'd550), .width(16'd105), .px(px), .py(py), .addr(addrg5));
	calpos_back calposition_back6(.dir(1'b1), .x(10'd525), .y(16'd550), .width(16'd105), .px(px), .py(py), .addr(addrg6));
	calpos_back calposition_back7(.dir(1'b1), .x(10'd630), .y(16'd550), .width(16'd105), .px(px), .py(py), .addr(addrg7));
	
	always @(posedge clk)
		begin
			if (px <= 10'd105) addr_back = addrg1;
			if (px <= 10'd210) addr_back = addrg2;
			if (px <= 10'd315) addr_back = addrg3;
			if (px <= 10'd420) addr_back = addrg4;
			if (px <= 10'd525) addr_back = addrg5;
			if (px <= 10'd630) addr_back = addrg6;
			if (px <= 10'd735) addr_back = addrg7;
		end
	
	always @(posedge clk)
		begin
			if (status == 2'b00)	rgb_reg = 8'b00000111;
			if (status == 2'b01 || status == 2'b10) 
			begin
				rgb_reg = back_rgb;
					//8'b00011111;
				if ( (px1 < px || px1 > 16'd2000) && px < (px1 + pipeWidth) && (py > pipe1t || py < pipe1b))
					begin
						if (py < pipe1b) addr_pipe = addrb1;
						else addr_pipe = addrt1;
						rgb_reg = pipe_rgb;
					end	
				else if ((px2 < px || px2 > 16'd2000)&& px < (px2 + pipeWidth) && (py > pipe2t || py < pipe2b))
					begin
						if (py < pipe2b) addr_pipe = addrb2;
						else addr_pipe = addrt2;
						rgb_reg = pipe_rgb;
					end
				else if ((px3 < px || px3 > 16'd2000) && px < (px3 + pipeWidth) && (py > pipe3t || py < pipe3b))
					begin
						if (py < pipe3b) addr_pipe = addrb3;
						else addr_pipe = addrt3;
						rgb_reg = pipe_rgb;
					end
				else if ((px4 < px || px4 > 16'd2000) && px < (px4 + pipeWidth) && (py > pipe4t || py < pipe4b))
					begin
						if (py < pipe4b) addr_pipe = addrb4;
						else addr_pipe = addrt4;
						rgb_reg = pipe_rgb;
					end
				if (rgb_reg == 8'b00000000) rgb_reg = 8'b01011011;
				
				if (bx1 <= px && px <= bx2 && by1 <= py && py <= by2 )
				begin
					case (birdImgCnt)
						2'b00 : if (bird_rgb0 != 8'b00000000) rgb_reg = bird_rgb0;
						2'b01 : if (bird_rgb1 != 8'b00000000)rgb_reg = bird_rgb1;
						2'b10 : if (bird_rgb2 != 8'b00000000)rgb_reg = bird_rgb2;
						default :
							if (bird_rgb1 != 8'b00000000) rgb_reg = bird_rgb1;
					endcase 
				end
			end
			if (status == 2'b11) //½áÊø¼Æ·Ö×´Ì¬
					rgb_reg = 8'b11000000;
		end

endmodule
