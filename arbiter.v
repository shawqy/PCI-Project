module arbiter 
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
////////////////////////////////////////////Active looooooooooooooooooowhhhhhhhhhhhhhhhhhhhhhhh
reg [1:0] next_master;// the next one to get the bus
integer i; // counter in for loop
reg [0:0] mem [0:3]; // queue the requests

always @ (posedge clk)
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

for(i=0;i<4;i=i+1)
begin
 if(mem[i][0]==0)
  begin
    next_master<=i;
    mem[i][0]<=1;
  end
end

end


always @ (negedge clk)
begin
if(frame_low==1)
begin
 if(REQ_A==0)
  begin
  GNT_A<=0;
  end

 if(REQ_B==0)
  begin
  GNT_B<=0;
  end

 if(REQ_C==0)
  begin
  GNT_C<=0;
  end

 if(REQ_D==0)
  begin
  GNT_D<=0;
  end

end
end

always @ (posedge frame_low)
begin
case(next_master)
0: GNT_A <= 0;
1: GNT_B <= 0;
2: GNT_C <= 0;
3: GNT_D <= 0;
endcase

end

endmodule
