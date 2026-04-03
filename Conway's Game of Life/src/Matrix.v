module Matrix
    (
        input System_Clk,
        input Reset_n,
        input [63:0] Data,
        output reg [7:0] Cols, Rows
    );

    parameter Divider = 25'd13500;

    reg [2:0] Counter;

    wire Clock;

    Clock_Divider Instance (.System_Clk(System_Clk), .Reset_n(Reset_n), .Divider(Divider), .Slow_Clk(Clock));

    always @(posedge Clock or negedge Reset_n) begin
        if(~Reset_n) begin
            Rows[7:0] <= 8'b01111111;
            Cols[7:0] <= Data[63:56];
            Counter <= 8'd6;
        end

        else begin
            Rows[7:0] <= {Rows[0], Rows[7:1]};
            Cols[7:0] <= Data[Counter*8 +: 8];

            if(Counter > 3'd0) Counter <= Counter - 1;
            else Counter <= 3'd7;
        end
    end

endmodule
    