
module arbiter /////////// DON'T FORGET TO ADD START AND NUMOFTRANSACTION SIGNALS TO DEVICE ///////////////
( 
input clk,
input REQ_A, 
input REQ_B, 
input REQ_C,
input REQ_D,
input frame_low,
input IRDY,
input start,// to initalize the number of transaction without inital block to make it synthizable
output reg GNT_A, 
output reg GNT_B, 
output reg GNT_C,
output reg GNT_D,
output reg turn_around_mode, // to check if this is a turn round  or not.
output reg [1:0] NumOfTrans_A, // number  of tranzaction for device A
output reg [1:0] NumOfTrans_B, // number  of tranzaction for device B
output reg [1:0] NumOfTrans_C, // number  of tranzaction for device C
output reg [1:0] NumOfTrans_D // number  of tranzaction for device D

);
//////////////////////////////////////////////Active looooooooooooooooooowhhhhhhhhhhhhhhhhhhhhhhh
reg [1:0] next_master;// the next one to get the bus
reg [0:0] mem [0:3]; // queue the requests
reg check1,check2,check3,check4 ; // this to check if frame asserted and any device have GNT S
reg [1:0] NumOfTrans [0:3]; // to count how many tranzaction
always @(posedge clk)
begin
	turn_around_mode<=0;
	if(!IRDY==1 && frame_low==1)
	begin
	turn_around_mode<=1;// input in the device by an if and else with normal already written code
	end

	if (start==1) //inital the the number of tranzaction
	begin
		NumOfTrans [0] <= 2'b00;
		NumOfTrans [1] <= 2'b00;
		NumOfTrans [2] <= 2'b00;
		NumOfTrans [3] <= 2'b00;
	end

	if (frame_low == 1'b0)
	begin
		if  (GNT_A == 1'b0)  
		begin
			check1 <= 1'b1; // make  GNT_A to HIGH "Deassert  GNT_A as it assert frame so has the bus"
			check2 <= 1'b0;
			check3 <= 1'b0;
			check4 <= 1'b0;
		end

		else if  (GNT_B == 1'b0)  
		begin
			check1 <= 1'b0; 
			check2 <= 1'b1; // make  GNT_B to HIGH "Deassert  GNT_B as it assert frame so has the bus"
			check3 <= 1'b0;
			check4 <= 1'b0;
		end
		
		else if  (GNT_C == 1'b0)  
		begin
			check1 <= 1'b0; 
			check2 <= 1'b0;
			check3 <= 1'b1; // make  GNT_C to HIGH "Deassert  GNT_C as it assert frame so has the bus"
			check4 <= 1'b0;
		end

		else if  (GNT_D == 1'b0)  
		begin
			check1 <= 1'b0; 
			check2 <= 1'b0;
			check3 <= 1'b0;
			check4 <= 1'b1; // make  GNT_D to HIGH "Deassert  GNT_D as it assert frame so has the bus"
		end
		
			
	end
	
		
	// Start Reading the Requests 
	if(REQ_A==0)
	begin
		mem[0][0]<=REQ_A; //Make A next master
		NumOfTrans [0] <= NumOfTrans [0] + 1; // make +1 for nunber  of tranzaction
	end
          
        else
        begin
                NumOfTrans_A <= NumOfTrans [0]; //if A is no longer requesting then take number of tranzaction and put it in output NumOfTrans_A
        end

	if(REQ_B==0)
	begin
		mem[1][0]<=REQ_B;
		NumOfTrans [1] <= NumOfTrans [1] + 1;
	end

	else
	begin
		NumOfTrans_B <= NumOfTrans [1];
	end

	if(REQ_C==0)
	begin
		mem[2][0]<=REQ_C;
		NumOfTrans [2] <= NumOfTrans [2] + 1;
	end
	
	else
	begin
		NumOfTrans_C <= NumOfTrans [2];
	end

	if(REQ_D==0)
	begin
		mem[3][0]<=REQ_D;
		NumOfTrans [3] <= NumOfTrans [3] + 1;
	end

	else
	begin
		NumOfTrans_D <= NumOfTrans [3];
	end

/*---------------------------------------------------------------------------------*/
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
/*------------------------------------------------------------------------------------------*/
always@(negedge clk)
begin 
/* we need to check if some device has a GNT signal and assert frame then it take the bus */
if ( check1 )
	begin
		GNT_A <= 1;
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
	end
 else if (check2)
	begin
		GNT_B <= 1;
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
	end
 else if (check3)
	begin
		GNT_C <= 1;
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
	end
 else if (check4)
	begin
		GNT_D <=1;
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
	end	

	
	
	//check <= 1'b0;
	

/* IDEL BUS */
if(frame_low==1 && IRDY==1)
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