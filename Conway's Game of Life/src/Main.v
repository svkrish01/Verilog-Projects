module Conway
    (
        input System_Clk,
        input Reset_n,
        output [7:0] Cols, Rows
    );

    genvar I, J;
    integer X, Y;

    parameter Divider = 25'd13500000;
    wire [63:0] Data_Flat;
    wire [7:0] Data_N [7:0], Data_E [7:0], Data_S [7:0], Data_W [7:0];
    wire [7:0] Data_NE [7:0], Data_SE [7:0], Data_SW [7:0], Data_NW [7:0];
    reg [7:0] Data [7:0], Data_Initial [7:0]; 
    reg [3:0] Counter;

    assign Data_Flat[63:0] = {Data[7], Data[6], Data[5], Data[4], Data[3], Data[2], Data[1], Data[0]};

    initial begin
        Data_Initial[7] = 8'b00000000;
        Data_Initial[6] = 8'b00000000;
        Data_Initial[5] = 8'b00011000;
        Data_Initial[4] = 8'b00100100;
        Data_Initial[3] = 8'b00100100;
        Data_Initial[2] = 8'b00010000;
        Data_Initial[1] = 8'b00000000;
        Data_Initial[0] = 8'b00000000;

        Data[7] = Data_Initial[7];
        Data[6] = Data_Initial[6];
        Data[5] = Data_Initial[5];
        Data[4] = Data_Initial[4];
        Data[3] = Data_Initial[3];
        Data[2] = Data_Initial[2];
        Data[1] = Data_Initial[1];
        Data[0] = Data_Initial[0];
    end

    Clock_Divider Instance_Clock_Divider (.System_Clk(System_Clk), .Reset_n(Reset_n), .Divider(Divider), .Slow_Clk(Clock));
    Matrix Instance_Matrix (.System_Clk(System_Clk), .Reset_n(Reset_n), .Data(Data_Flat), .Cols(Cols), .Rows(Rows));

    generate
        for(I = 0; I < 7; I = I + 1) begin : Loop_1
            for(J = 0; J < 7; J = J + 1) begin : Loop_2
                assign Data_N[I][J] = Data[I+1][J];
                assign Data_E[I][J+1] = Data[I][J];
                assign Data_S[I+1][J] = Data[I][J];
                assign Data_W[I][J] = Data[I][J+1];

                assign Data_NE[I][J+1] = Data[I+1][J];
                assign Data_SE[I+1][J+1] = Data[I][J];
                assign Data_SW[I+1][J] = Data[I][J+1];
                assign Data_NW[I][J] = Data[I+1][J+1];
            end

            assign Data_N[7][I] = Data[0][I];
            assign Data_N[I][7] = Data[I+1][7];
            assign Data_E[7][I+1] = Data[7][I];
            assign Data_E[I][0] = Data[I][7];
            assign Data_S[0][I] = Data[7][I];
            assign Data_S[I+1][7] = Data[I][7];
            assign Data_W[7][I] = Data[7][I+1];
            assign Data_W[I][7] = Data[I][0];
            
            assign Data_NE[7][I+1] = Data[0][I];
            assign Data_NE[I][0] = Data[I+1][7];
            assign Data_SE[0][I+1] = Data[7][I];
            assign Data_SE[I+1][0] = Data[I][7];
            assign Data_SW[0][I] = Data[7][I+1];
            assign Data_SW[I+1][7] = Data[I][0];
            assign Data_NW[7][I] = Data[0][I+1];
            assign Data_NW[I][7] = Data[I+1][0];
        end

        assign Data_N[7][7] = Data[0][7];
        assign Data_E[7][0] = Data[7][7];
        assign Data_S[0][7] = Data[7][7];
        assign Data_W[7][7] = Data[7][0];

        assign Data_NE[7][0] = Data[0][7];
        assign Data_SE[0][0] = Data[7][7];
        assign Data_SW[0][7] = Data[7][0];
        assign Data_NW[7][7] = Data[0][0];
    endgenerate

    always @(posedge Clock or negedge Reset_n) begin
        if(~Reset_n) begin
            Data[7] = Data_Initial[7];
            Data[6] = Data_Initial[6];
            Data[5] = Data_Initial[5];
            Data[4] = Data_Initial[4];
            Data[3] = Data_Initial[3];
            Data[2] = Data_Initial[2];
            Data[1] = Data_Initial[1];
            Data[0] = Data_Initial[0];
        end

        else begin
            for(X = 0; X < 8; X = X + 1) begin : Loop_3
                for(Y = 0; Y < 8; Y = Y + 1) begin : Loop_4
                    Counter = Data_N[X][Y] + Data_E[X][Y] + Data_S[X][Y] + Data_W[X][Y] + Data_NE[X][Y] + Data_SE[X][Y] + Data_SW[X][Y] + Data_NW[X][Y];

                    if((Counter < 2) || (Counter > 3)) Data[X][Y] <= 1'b0;
                    else if(Counter == 2) Data[X][Y] <= Data[X][Y];
                    else if(Counter == 3) Data[X][Y] <= 1'b1;
                end
            end
        end
    end

endmodule



