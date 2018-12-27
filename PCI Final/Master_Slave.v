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
	input force_en,
	output reg Frame,
	output count_done,
	input frame_reader
	);
reg [2:0] transactions ;
assign count_done = done;

always@ (CLK, done)
begin
if (CLK)
begin
if ( GNT == 0 && IDsel == 1 && frame_reader==1'b1)
	begin
		S_M <= 1'b1;
		Frame <= 1'b0;

	end
else if( GNT == 1 && IDsel == 0)
	begin
		S_M <= 1'b0;
		Frame <= 1'b1;

	end
if(!force_en)
begin

transactions <= transactions +2;
end
end

if(done)
begin

//S_M <= 1'b0;
transactions <= transactions-1;
 

end

if(transactions == 3'b000)
begin

	Frame <= 1'b1;
		S_M <= 1'b0;

end


if (transactions === 3'bXXX)
begin
transactions <= 3'b000;

end



end



endmodule
