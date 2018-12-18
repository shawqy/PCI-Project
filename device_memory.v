module memory (
input IRDY,
input TRDY,
input clk,
input [3:0] C_BE,
input [31:0] data
); 

reg [3:0] pointer;
reg [31:0] mem [0:9];
reg [31:0] Rbyte;



always @ (posedge clk)
begin

if ( !IRDY && !TRDY )
begin

mem [ pointer ] <= {  {8{C_BE[0]}},  {8{C_BE[1]}},  {8{C_BE[2]}}, 
           {8{C_BE[3]}}   } & data;
if(pointer==4'b1001)
begin
pointer<=4'b0000;
end
else
pointer <= pointer + 1;
end

else
pointer <= 0;
end

endmodule
