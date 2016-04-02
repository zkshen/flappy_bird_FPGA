`timescale 1ns / 1ps

module calpos_back(
    input wire dir,
    input wire [15:0] x, y,
    input wire [15:0] width,
    input wire [15:0] px, py,
    output reg [16:0] addr
    );
    
    reg [31:0] op1, op2;
    reg [15:0] col;
    reg [15:0] tmp;
    initial
    begin
        addr = 0;
        op1 = 0;
        tmp = 0;
    end
    
    always @*
    begin
        tmp = dir ? y - py : py - y;
        col = px - x;
        if (tmp<16'd318)
            addr = 17'd10605;
        else if (tmp>16'd418)
                addr=17'd10606;
            else 
            begin
                tmp = tmp - 16'd318;
                op1 = (tmp[9:0] * width[6:0]);
                addr = op1+ col;
             end
    end

endmodule