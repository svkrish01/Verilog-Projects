module Clock_Divider
(
        input System_Clk,
        input Reset_n,
        input [24:0] Divider,
        output reg Slow_Clk
    );

    reg [24:0] Counter;

    initial Counter <= 25'd0;

    always @(posedge System_Clk or negedge Reset_n) begin
        if(~Reset_n) begin
            Counter <= 25'd0;
            Slow_Clk <= 1'b0;
        end

        else begin
            if(Counter < Divider) begin
                Counter <= Counter + 1;
            end

            else begin
                Counter <= 25'd0;
                Slow_Clk <= ~Slow_Clk;
            end
        end
    end

endmodule
