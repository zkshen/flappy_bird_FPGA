module expand(clk,clk_1fps,flyup,outflyup);
    input clk,clk_1fps,flyup;
    output reg outflyup;

reg [1:0] count;

always @(posedge flyup or  posedge clk_1fps) 
begin
    if (flyup)
    begin
        outflyup=1;
        count=1;
    end
    else begin
        if (outflyup)
            if (count>1)
            begin
                outflyup=0;
                count=0;
            end
            else 
                count=count+1;

            
         end
end
endmodule