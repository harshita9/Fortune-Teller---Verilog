

module writeMemory(input clk,resetn,wr,input[7:0]address,output[6:0]q1);

reg wren;
reg[7:0]addr;
reg[6:0]dat;


milestone q0(.address(addr),
				.clock(clk),
				.data(dat),
				.wren(wren),
				.q(q1)
				);
				
always@(posedge clk)
begin
	if(!resetn)
	begin
		addr<=0;
		dat<=0;
		wren<=1'b1;
	end
	else
	begin
		if(dat==7'd40)
		begin
			wren<=1'b0;
			addr<=address;
			
		end
		else
		begin
			wren<=1'b1;
			addr<=addr+1;
			dat<=dat+1;
		end
	end
end




endmodule



