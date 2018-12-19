`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:23:21 12/12/2018 
// Design Name: 
// Module Name:    Master_Slave 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
 module Master_Slave(
	
	input GNT,
	input IDsel,
	output reg S_M, // 1 for master 0 for slave
	input CLK,
	input  done,
	output reg Frame
	);


always@ ( posedge CLK)
begin

if ( GNT == 0 && IDsel == 1)
	begin
		S_M <= 1'b1;
		Frame <= 1'b0;

	end
else if( GNT == 1 && IDsel == 0)
	begin
		S_M <= 1'b0;
		Frame <= 1'b1;

	end
else
begin
		S_M <= 1'bz;

end
end


always @(done)
begin

if ( done == 1'b1)
begin
Frame <= 1'b1;
end
else 
begin
Frame <= 1'b1;
end

end





endmodule
