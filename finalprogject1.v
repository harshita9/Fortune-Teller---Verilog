

module milestone1(input[3:0]SW,input[1:0]KEY,input CLOCK_50, output[6:0]HEX0,HEX1,HEX3,HEX4);
wire [6:0] message;
wire [6:0] address;
wire wr;

writeMemory c1(.clk(CLOCK_50),
					.resetn(KEY[0]),
					.wr(wr),
					.address(address),
					.q1(message)
					);

main m1(.color1(SW[0]),
			.color2(SW[0]),
			.numbers(SW[3:0]),
			.clk(CLOCK_50),
			.resetn(KEY[0]),
			.go(~KEY[1]),
			.message(address)
			);
			
hex_decoder h1(.hex_digit({3'b000,SW[0]}),
					.segments(HEX4)
					);
hex_decoder h2(.hex_digit(SW[3:0]),
					.segments(HEX3)
					);
hex_decoder h3(.hex_digit({1'b0,message[6:4]}),
					.segments(HEX1)
					);
hex_decoder h4(.hex_digit(message[3:0]),
					.segments(HEX0)
					);

endmodule

module main(input color1,color2,
			input[3:0]numbers,
			input clk,resetn,go,
			output[6:0] message);

wire ld_color1,ld_color2,ld_number,ld_r;
wire[5:0]pattern;

control C1(.clk(clk),
				.resetn(resetn),
				.go(go),
				.ld_color1(ld_color1),
				.ld_color2(ld_color2),
				.ld_number(ld_number),
				.ld_r(ld_r)
				);
				
datapath d1(.color1(color1),
				.color2(color2),
				.numbers(numbers),
				.clk(clk),
				.resetn(resetn),
				.ld_color1(ld_color1),
				.ld_color2(ld_color2),
				.ld_number(ld_number),
				.ld_r(ld_r),
				.pattern(pattern)
				);
representation r(.pattern(pattern),
						.message(message)
						);
endmodule


module control(input clk,
    input resetn,
    input go,
    output reg  ld_color1, ld_color2, ld_number, ld_r
    );
	 
	reg [5:0] current_state, next_state; 
	
	 localparam  S_LOAD_C1        = 5'd0,
                S_LOAD_C1_WAIT   = 5'd1,
                S_LOAD_N        = 5'd2,
                S_LOAD_N_WAIT   = 5'd3,
                S_LOAD_C2        = 5'd4,
                S_LOAD_C2_WAIT   = 5'd5,                
					 S_DISPLAY		   =5'd6;
					 
	 // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                S_LOAD_C1: next_state = go ? S_LOAD_C1_WAIT : S_LOAD_C1; // Loop in current state until value is input
                S_LOAD_C1_WAIT: next_state = go ? S_LOAD_C1_WAIT : S_LOAD_N; // Loop in current state until go signal goes low
                S_LOAD_N: next_state = go ? S_LOAD_N_WAIT : S_LOAD_N; // Loop in current state until value is input
                S_LOAD_N_WAIT: next_state = go ? S_LOAD_N_WAIT : S_LOAD_C2; // Loop in current state until go signal goes low
                S_LOAD_C2: next_state = go ? S_LOAD_C2_WAIT : S_LOAD_C2; // Loop in current state until value is input
                S_LOAD_C2_WAIT: next_state = go ? S_LOAD_C2_WAIT : S_DISPLAY; // Loop in current state until go signal goes low
                S_DISPLAY: next_state =  S_LOAD_C1;
				default:     next_state = S_LOAD_C1;
        endcase
    end // state_table

// Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        ld_color1 = 1'b0;
        ld_color2 = 1'b0;
        ld_number = 1'b0;
         ld_r = 1'b0;
        case (current_state)
            S_LOAD_C1: begin
                ld_color1 = 1'b1;
                end
            S_LOAD_C2: begin
                ld_color2 = 1'b1;
                end
            S_LOAD_N: begin
                ld_number = 1'b1;
                end
           
				S_DISPLAY: begin
               ld_r=1'b1;
            end
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= S_LOAD_C1;
        else
            current_state <= next_state;
    end // state_FFS	 
					
	 
	 
endmodule
    

module datapath(input color1,color2,input[3:0]numbers,
	input clk,
    input resetn, 
    input ld_color1, ld_color2, ld_number,
    input ld_r,
    output reg [5:0] pattern);
	 
	 reg c1,c2;
	 reg [3:0]num;
	 
	 always@(posedge clk) begin
        if(!resetn) begin
            c1 <= 1'b0; 
            c2 <= 1'b0; 
            num <= 4'd0; 
       
        end
        else begin
            if(ld_color1)
                c1 <= color1;
            if(ld_color2)
               c2<=color2;
            if(ld_number)
                num <= numbers;
        end
    end
 
 
    // Output result register
    always@(posedge clk) begin
        if(!resetn) begin
            pattern <= 6'd0; 
        end
        else 
            if(ld_r)
                pattern <= {c1,num,c2};
    end

	 
	 
endmodule




module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;
            default: segments = 7'h7f;
        endcase
endmodule
