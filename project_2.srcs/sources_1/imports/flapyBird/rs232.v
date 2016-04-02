/*------------- 接收模块代码 ---------------*/
module RxD(baud,reset,rxd,data,done);
    input baud,reset,rxd;
    output [7:0] data;
    output done;
    
    reg [3:0] cnt;
    reg [7:0] data;
    wire rxd_flag;
    
    assign rxd_flag = (cnt>=4'd0)&&(cnt<=4'd8); 
    
    always @ (posedge baud or posedge reset)
    begin
        if(reset)
            data <= 8'h00;
        else  
        begin
            case(cnt)
                4'd0: data[0] <= rxd;
                4'd1: data[1] <= rxd;
                4'd2: data[2] <= rxd;
                4'd3: data[3] <= rxd;
                4'd4: data[4] <= rxd;
                4'd5: data[5] <= rxd;
                4'd6: data[6] <= rxd;
                4'd7: data[7] <= rxd;
                default:
                    data <= data;
            endcase
        end
    end
    always @ (posedge baud or posedge reset)
    begin
        if(reset)
            cnt <= 4'd8;
        else if((!rxd)||rxd_flag)
            cnt <= (cnt==4'd9) ? 0 : (cnt+4'd1);
        else
            cnt <= 4'd9;
    end
    
    one_pulse one_pulse(.clk(baud),.in(cnt==4'd9),.out(done));
    
endmodule

/*------------- 发送模块代码 ---------------*/
module  TxD(reset,baud,ena,data,txd);
    input    reset;           //全局复位
    input    baud;             //串口发送时钟
    input    ena;             //串口发送使能输入端,即按键输入端
    input    [7:0] data;      //FPGA向串口发送的数据
    output   txd;             //FPGA向串口发送数据的发送端

    reg      txd;             
    reg      [3:0] cnt; //延时去抖计数器，延时时间为1010/11920秒
    //wire     txd_flag;
    
    //assign txd_flag = (cnt>=4'd0)&&(cnt<=4'd9);
    
    always @(posedge baud or posedge reset)
    begin
        if(reset)
        begin
            txd <= 1'b1;              //发送端复位，高电平      
            cnt <= 4'd9;
        end
        else if(ena)          //检测按键按下后弹起，即ena的上升沿（因为无动作时连接按键的pin处于高电平）
            cnt <= 4'd0;
        else
            cnt <= (cnt==4'd9) ? 4'd9 : (cnt+1);
        case (cnt)        
            4'd0: txd <= 1'b0;         //发送起始位
            4'd1: txd <= data[0];      //发送第一位
            4'd2: txd <= data[1];      //发送第二位
            4'd3: txd <= data[2];      //发送第三位
            4'd4: txd <= data[3];      //发送第四位
            4'd5: txd <= data[4];      //发送第五位
            4'd6: txd <= data[5];      //发送第六位
            4'd7: txd <= data[6];      //发送第七位
            4'd8: txd <= data[7];      //发送第八位
            4'd9: txd <= 1'b1;         //发送停止位
            default: txd <= 1'b1;
        endcase
    end
    
    //one_pulse one_pulse(.clk(baud),.in(~txd_flag),.out(done));
    
endmodule

/*------------- 波特率发生模块 ---------------*/
module Baud(clk,reset,baud);
    input clk,reset;
    output baud;
    
    reg [11:0] cnt;
    
    always @ (posedge clk)
    begin
        if(reset)
            cnt <= 12'b0;
        else 
            cnt <= (cnt==1735) ? 0 : (cnt+12'b1);
    end
    assign baud = (cnt==1735);
endmodule