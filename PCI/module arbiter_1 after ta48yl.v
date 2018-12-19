module arbiter_1
( 
input clk,
input REQ_A, 
input REQ_B, 
input REQ_C,
input REQ_D,
input frame_low,
output reg GNT_A, 
output reg GNT_B, 
output reg GNT_C,
output reg GNT_D
);
//////////////////////////////////////////////Active looooooooooooooooooowhhhhhhhhhhhhhhhhhhhhhhh
reg [1:0] next_master;// the next one to get the bus
reg [0:0] mem [0:3]; // queue the requests

always @(posedge clk)//negedge
begin
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

if(frame_low==1) // bit we take next master then we clear it
begin 
mem[next_master][0]<=1'b1;
end
end

always@(negedge clk)
begin 
if(frame_low)
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
end
end


endmodule

