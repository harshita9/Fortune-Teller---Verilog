


module representation(input [5:0] pattern, output reg [6:0] message);
   
    always @(*)
        case (pattern)
            6'b000000: message = 7'd0;
            6'b000010: message = 7'd1;
            6'b000100: message = 7'd2;
            6'b000110: message = 7'd3;
            6'b001000: message = 7'd4;
            6'b001010: message = 7'd5;
            6'b001100: message = 7'd6;
            6'b001110: message = 7'd7;
            6'b010000: message = 7'd8;
            6'b010010: message = 7'd9;
            6'b000001: message = 7'd10;
            6'b000011: message = 7'd11;
            6'b000101: message = 7'd12;
            6'b000111: message = 7'd13;
            6'b001001: message = 7'd14;
            6'b001011: message = 7'd15;
            6'b001101: message = 7'd16;
            6'b001111: message = 7'd17;
            6'b010001: message = 7'd18;
            6'b010011: message = 7'd19;
            6'b100000: message = 7'd20;
            6'b100010: message = 7'd21;
            6'b100100: message = 7'd22;
            6'b100110: message = 7'd23;
            6'b101000: message = 7'd24;
            6'b101010: message = 7'd25;
            6'b101100: message = 7'd26;
            6'b101110: message = 7'd27;
            6'b110000: message = 7'd28;
            6'b110010: message = 7'd29;
            6'b100001: message = 7'd30;
            6'b100011: message = 7'd31;
            6'b100101: message = 7'd32;
            6'b100111: message = 7'd33;
            6'b101001: message = 7'd34;
            6'b101011: message = 7'd35;
            6'b101101: message = 7'd36;
            6'b101111: message = 7'd37;
            6'b110001: message = 7'd38;
            6'b110011: message = 7'd39;
            default: message = 7'b0000000;
        endcase
        
endmodule

