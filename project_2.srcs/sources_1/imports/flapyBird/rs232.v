/*------------- ����ģ����� ---------------*/
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

/*------------- ����ģ����� ---------------*/
module  TxD(reset,baud,ena,data,txd);
    input    reset;           //ȫ�ָ�λ
    input    baud;             //���ڷ���ʱ��
    input    ena;             //���ڷ���ʹ�������,�����������
    input    [7:0] data;      //FPGA�򴮿ڷ��͵�����
    output   txd;             //FPGA�򴮿ڷ������ݵķ��Ͷ�

    reg      txd;             
    reg      [3:0] cnt; //��ʱȥ������������ʱʱ��Ϊ1010/11920��
    //wire     txd_flag;
    
    //assign txd_flag = (cnt>=4'd0)&&(cnt<=4'd9);
    
    always @(posedge baud or posedge reset)
    begin
        if(reset)
        begin
            txd <= 1'b1;              //���Ͷ˸�λ���ߵ�ƽ      
            cnt <= 4'd9;
        end
        else if(ena)          //��ⰴ�����º��𣬼�ena�������أ���Ϊ�޶���ʱ���Ӱ�����pin���ڸߵ�ƽ��
            cnt <= 4'd0;
        else
            cnt <= (cnt==4'd9) ? 4'd9 : (cnt+1);
        case (cnt)        
            4'd0: txd <= 1'b0;         //������ʼλ
            4'd1: txd <= data[0];      //���͵�һλ
            4'd2: txd <= data[1];      //���͵ڶ�λ
            4'd3: txd <= data[2];      //���͵���λ
            4'd4: txd <= data[3];      //���͵���λ
            4'd5: txd <= data[4];      //���͵���λ
            4'd6: txd <= data[5];      //���͵���λ
            4'd7: txd <= data[6];      //���͵���λ
            4'd8: txd <= data[7];      //���͵ڰ�λ
            4'd9: txd <= 1'b1;         //����ֹͣλ
            default: txd <= 1'b1;
        endcase
    end
    
    //one_pulse one_pulse(.clk(baud),.in(~txd_flag),.out(done));
    
endmodule

/*------------- �����ʷ���ģ�� ---------------*/
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