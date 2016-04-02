module button(clk,reset,txd,rxd,up,noise,datasend);
    input clk,reset,rxd;
    output txd,up,noise;
    output [15:0] datasend;
    
    wire baud;
    //wire rxdone;
    wire enc;
    //wire [15:0] datasend;
    wire [15:0] rawdata;
    wire [7:0] data;
    
    //assign txd = sel ? send : rxd;
    
    Baud Baud(.clk(clk),.reset(reset),.baud(baud));
    RxD RxD(.baud(baud),.rxd(rxd),.reset(reset),.data(data),.done(rxdone));
    //TxD TxD(.reset(reset),.baud(baud),.ena(en),.data(data),.txd(txd));
    ReceiveBag ReceiveBag(.baud(baud),.en(rxdone),.out(rawdata),.reset(reset),.data(data),.done(enc));
    compute compute(.baud(baud),.en(enc),.in(rawdata),.out(datasend),.reset(reset));
    Dsend Dsend(.reset(reset),.in(datasend),.send(txd),.baud(baud),.en(enc));
    jump jump(.clk(clk),.baud(baud),.datasend(datasend),.up(up),.reset(reset),.noise(noise));
endmodule