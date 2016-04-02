module ReceiveBag(baud,en,out,data,reset,done);
    input en,baud,reset;
    input [7:0] data;
    output [15:0] out;
    output done;
    
    reg [7:0] raw0,raw1,raw2,raw3,raw4,raw5,raw6,raw7;
    reg [3:0] cnt;
    reg [15:0] out;
    
    wire [7:0] chk;
    wire delay;
    one_pulse pulse0(.clk(en),.in((~chk)==raw7),.out(delay)); 
    //one_pulse pulse0(.clk(en),.in(cnt==4'd7),.out(delay)); 
    
    one_pulse pulse1(.clk(en),.in(~delay),.out(done));
    
    
    assign chk = raw3+raw4+raw5+raw6;
        
    always @ (posedge en)
    begin           
        case (cnt)
            4'd0: 
                if(data==8'hAA)
                begin
                    raw0 <= data;
                    cnt <= cnt + 4'd1;
                end
                else
                    cnt <= 4'd0;
            4'd1: 
                if(data==8'hAA)
                begin
                    raw1 <= data;
                    cnt <= cnt + 4'd1;
                end
                else
                    cnt <= 4'd0;
            4'd2: 
                if(data==8'h04)
                begin
                    raw2 <= data;
                    cnt <= cnt + 4'd1;
                end
                else
                    cnt <= 4'd0;
            4'd3: 
                if(data==8'h80)
                begin
                    raw3 <= data;
                    cnt <= cnt + 4'd1;
                end
            else
                cnt <= 4'd0;
            4'd4: 
                if(data==8'h02)
                begin
                    raw4 <= data;
                    cnt <= cnt + 4'd1;
                end
                else
                    cnt <= 4'd0;
            4'd5: 
                begin
                    raw5 <= data;
                    cnt <= cnt + 4'd1;
                end
            4'd6: 
                begin
                    raw6 <= data;
                    cnt <= cnt + 4'd1;
                end
            4'd7:
                begin
                    raw7 <= data;
                    cnt <= 4'd0;
                    out <= ((~chk)==data) ? ({raw5,raw6}) : out;
                    //out <= {raw5,raw6};
                end
            default:
                cnt <= 4'd0;
        endcase
    end
endmodule


module compute(baud,en,in,reset,out);
    input baud,reset,en;
    input [15:0] in;
    output [15:0] out;
    
    reg signed [15:0] d0,d1,d2,d3,d4;
    reg [15:0] out;
    
    always @ (posedge en)
    begin

            d0 <= d1;
            d1 <= d2;
            d2 <= d3;
            d3 <= d4;
            d4 <= in;
            out <= d0/6+d1/6+d3/6+d4/6+d2/3;
    end
endmodule

            
module Dsend(reset,in,send,baud,en);
    input reset,en,baud;
    input [15:0] in;
    output send;
    
    reg [7:0] datasend;
    reg ena;
    reg [7:0] cnt;
    
    wire en0;
    TxD TxD(.reset(reset),.baud(baud),.ena(ena),.data(datasend),.txd(send));
    one_pulse pulse_en(.clk(baud),.in(en),.out(en0));
    
    always @ (posedge baud or posedge reset)
    begin   
        if(reset)
            cnt <= 8'd71;
        else if(en0)
            cnt <= 8'd0;
        else
            cnt <= (cnt==8'd71) ? 8'd71 : (cnt+8'd1);
        case(cnt)
            8'd0: 
            begin
                datasend <= 8'hAA;
                ena <= 1'b1;
            end
            8'd10: 
            begin
                datasend <= 8'hAA;
                ena <= 1'b1;
            end
            8'd20: 
            begin
                datasend <= 8'h04;
                ena <= 1'b1;
            end
            8'd30: 
            begin
                datasend <= 8'h80;
                ena <= 1'b1;
            end
            8'd40: 
            begin
                datasend <= 8'h02;
                ena <= 1'b1;
            end
            8'd50: 
            begin
                datasend <= in[15:8];
                ena <= 1'b1;
            end
            8'd60: 
            begin
                datasend <= in[7:0];
                ena <= 1'b1;
            end
            8'd70: 
            begin
                datasend <= ~(8'h82+in[15:8]+in[7:0]);
                ena <= 1'b1;
            end
            default: 
            begin
                ena <= 1'b0;
            end
                    
        endcase
    end
endmodule
        
module jump(clk,baud,datasend,up,reset,noise);
    input clk,baud,reset;
    input signed [15:0] datasend;
    output up,noise;
    
    reg state;
    reg [9:0] cnt;
    
    always @ (posedge baud)
    begin
        if(reset)
            cnt <= 10'b0;
        else if((datasend>=16'sd600)||(datasend <= -16'sd600))
            cnt <= 10'b1;
        else if(cnt)
            cnt <= (cnt==10'd512) ? 10'b0 : (cnt+10'b1);
        else
            cnt <= 10'b0;
    end
    
    always @ (posedge baud)
    begin
        if(reset|noise)
            state <= 1'b0;
        else if(datasend>=16'sd200)
            state <= 1'b1;
        else if(datasend <= -16'sd100)
            state <= 1'b0;
        else
            state <= state;
     end
     
     assign noise = (cnt!=0);
     
     one_pulse one_pulse(.clk(clk),.in(state),.out(up));
endmodule
                
           
                
    
    