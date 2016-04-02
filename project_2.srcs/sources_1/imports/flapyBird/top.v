`timescale 1ns / 1ps

module top(
	input wire clk, resetButton, flyUpButton, startButton, reStartButton,rxd,
	output wire hsync, vsync, txd, noise,
	output wire [7:0] rgb,
	output wire [11:0]anode, 
	output wire [15:0]segment
	);

	wire reset, flyUp, reStart, fallOut;

	wire [7:0] rgb_wire;
	wire video_on;
	wire clk_1fps;
	wire [15:0] score;
	wire [9:0] hc, vc;
    wire [1:0] nowStatus;
	wire clk25;
	wire start;
	wire [15:0] bird_x, bird_y;
	wire [15:0] px, py;
	
	wire btn_start, btn_fly, btn_restart;
	
	
	wire [15:0] pipe1x, pipe1t, pipe1b; 
	wire [15:0] pipe2x, pipe2t, pipe2b;
	wire [15:0] pipe3x, pipe3t, pipe3b; 
	wire [15:0] pipe4x, pipe4t, pipe4b;
	
	wire hit1, hit2, hit3, hit4;
		
	parameter halfWidth = 16'd10;
	parameter pipeWidth = 16'd30;
	
	pbdebounce key1(clk, resetButton, reset);
	pbdebounce key2(clk, flyUpButton, btn_fly);
	pbdebounce key3(clk, startButton, btn_start);
	pbdebounce key4(clk, reStartButton, btn_restart);
	
	assign clk_1fps = (hc == 0 && vc == 0);
	
	wire up;
	wire [15:0]datasend;
	wire [7:0] seed;
	assign seed=datasend[7:0]; 
    button button1(clk,reset,txd,rxd,up,noise,datasend);
    wire expand_up;
    expand expand1(clk,clk_1fps,up,expand_up);
	
	assign reStart = btn_restart;
	assign start = btn_start;
	assign flyUp = expand_up|btn_fly;
	
	
	clkdiv clkdiv_unit(.clk(clk), .clr(reset), .clk25(clk25));
	vga_640x480 vsync_unit(.clk(clk25), .clr(reset), .hsync(hsync), .vsync(vsync), .vidon(video_on), .hc(hc), .vc(vc));
	calculateXY calculateXY_unit(clk, hc, vc, px, py);
	display m0(clk, score ,anode[3:0], segment[7:0]); 
	
	status status_unit(.clk(clk), .reset(reset), .start(start), .failFlag(failFlag), .fallOut(fallOut), .reStart(reStart), .nowStatus(nowStatus));
	
	
	
	running run_uint(.clk(clk_1fps), .reset(reset), .flyUp(flyUp), .status(nowStatus), .bird_x(bird_x), .bird_y(bird_y));
	pipeControl pipe1(clk_1fps, nowStatus, 2'b00,seed, pipe1x, pipe1t, pipe1b);
	pipeControl pipe2(clk_1fps, nowStatus, 2'b01,seed,pipe2x, pipe2t, pipe2b);
	pipeControl pipe3(clk_1fps, nowStatus, 2'b10,seed, pipe3x, pipe3t, pipe3b);
	pipeControl pipe4(clk_1fps, nowStatus, 2'b11,seed, pipe4x, pipe4t, pipe4b);	
		
	calScore calScore_unit(.clk(clk_1fps), .status(nowStatus), .bird_x(bird_x), .pipe1x(pipe1x), .pipe2x(pipe2x), .pipe3x(pipe3x), .pipe4x(pipe4x), .score(score));
		
	draw draw_unit(.clk(clk), .clk_1fps(clk_1fps),
						.status(nowStatus), .px(px), .py(py), .bird_x(bird_x), .bird_y(bird_y), 
						.pipe1x(pipe1x), .pipe1t(pipe1t), .pipe1b(pipe1b),
						.pipe2x(pipe2x), .pipe2t(pipe2t), .pipe2b(pipe2b),
						.pipe3x(pipe3x), .pipe3t(pipe3t), .pipe3b(pipe3b),
						.pipe4x(pipe4x), .pipe4t(pipe4t), .pipe4b(pipe4b),
						.rgb_reg(rgb_wire));

	assign rgb = (video_on) ? rgb_wire : 8'b01000110;
	assign hit1 = (bird_x - halfWidth) < (pipe1x + pipeWidth) && (bird_x + halfWidth) > (pipe1x - pipeWidth) && (bird_y + halfWidth > pipe1t || bird_y - halfWidth< pipe1b);
	assign hit2 = (bird_x - halfWidth) < (pipe2x + pipeWidth) && (bird_x + halfWidth) > (pipe2x - pipeWidth) && (bird_y + halfWidth > pipe2t || bird_y - halfWidth< pipe2b);
	assign hit3 = (bird_x - halfWidth) < (pipe3x + pipeWidth) && (bird_x + halfWidth) > (pipe3x - pipeWidth) && (bird_y + halfWidth > pipe3t || bird_y - halfWidth< pipe3b);
	assign hit4 = (bird_x - halfWidth) < (pipe4x + pipeWidth) && (bird_x + halfWidth) > (pipe4x - pipeWidth) && (bird_y + halfWidth > pipe4t || bird_y - halfWidth< pipe4b);

	assign failFlag = hit1 || hit2 || hit3 || hit4;
	assign fallOut = (bird_y + halfWidth) > 16'd10000;
endmodule
