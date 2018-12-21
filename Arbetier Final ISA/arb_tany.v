
module arbiter_2
( 
input clk,
input REQ_A, 
input REQ_B, 
input REQ_C,
input REQ_D,
input frame_low,
input IRDY,
output reg GNT_A, 
output reg GNT_B, 
output reg GNT_C,
output reg GNT_D
);
//////////////////////////////////////////////Active looooooooooooooooooowhhhhhhhhhhhhhhhhhhhhhhh
reg [1:0] next_master;// the next one to get the bus
reg [0:0] mem [0:3]; // queue the requests
reg check ; // this to check if frame asserted and any device have GNT 
always @(posedge clk)
begin
	if (frame_low == 1'b0)
	begin
		if ( (GNT_A == 1'b0) || (GNT_B == 1'b0) || (GNT_C == 1'b0) || (GNT_D == 1'b0) )
		begin
			check <= 1'b1; // make All GNT to HIGH "Deassert all GNT"
		end
	end
	
	else 
	begin
		check <= 1'b0; // No need to Deassert all GNTs
	end

	// Start Reading the Requests 
	if(REQ_A==0)
	begin
		mem[0][0]<=REQ_A;
	end


	if(REQ_B==0)
	begin
		mem[1][0]<=REQ_B;
	end


	if(REQ_C==0)
	begin
		mem[2][0]<=REQ_C;
	end


	if(REQ_D==0)
	begin
		mem[3][0]<=REQ_D;
	end

	if ( !(mem[0][0] & 1'b1)  )
	begin
	next_master<=0;
	
	end

	else if ( !(mem[1][0] & 1'b1) )
        begin
        next_master<=1;
	
        end

        else if ( !(mem[2][0] & 1'b1) )
	begin
        next_master<=2;
	end

	else if ( !(mem[3][0] & 1'b1) )
	begin
        next_master<=3;
	end
	else 
	begin
	next_master<=2'bzz;
	end
	// bit we take next master then we clear it so that it can request in next cycle "if it wants"
    	mem[next_master][0]<=1'b1; 


end

always@(negedge clk)
begin 

if ( check )
	begin
		GNT_A <= 1;
		GNT_B <= 1;
		GNT_C <= 1;
		GNT_D <= 1; 
	

	
	case(next_master)
	0: begin 
		GNT_A <= 0;
		GNT_B <= 1;
		GNT_C <= 1;
		GNT_D <= 1; 
		//mem[0][0]<=1'b1;
	end

	1: begin
		GNT_A <= 1;
		GNT_B <= 0;
		GNT_C <= 1;
		GNT_D <= 1;
		//mem[1][0]<=1'b1;
        
	end

	2: begin
		GNT_A <= 1;
		GNT_B <= 1;
		GNT_C <= 0;
		GNT_D <= 1;
		//mem[2][0]<=1'b1;
	end

	3: begin
		GNT_A <= 1;
		GNT_B <= 1;
		GNT_C <= 1;
		GNT_D <= 0;
		//mem[3][0]<=1'b1; 
	end
	endcase
	//check <= 1'b0;
	end

if(frame_low && IRDY)
begin 
	case(next_master)
	0: begin 
		GNT_A <= 0;
		GNT_B <= 1;
		GNT_C <= 1;
		GNT_D <= 1; 
		//mem[0][0]<=1'b1;
	end

	1: begin
		GNT_A <= 1;
		GNT_B <= 0;
		GNT_C <= 1;
		GNT_D <= 1;
		//mem[1][0]<=1'b1;
        
	end

	2: begin
		GNT_A <= 1;
		GNT_B <= 1;
		GNT_C <= 0;
		GNT_D <= 1;
		//mem[2][0]<=1'b1;
	end

	3: begin
		GNT_A <= 1;
		GNT_B <= 1;
		GNT_C <= 1;
		GNT_D <= 0;
		//mem[3][0]<=1'b1;
	end
	endcase
	end // if bus idle

end // end always

endmodule

