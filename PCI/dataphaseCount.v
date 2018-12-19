`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:32:09 12/18/2018 
// Design Name: 
// Module Name:    dataphaseCount 
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
module dataphaseCount(
input IRDY,
input TRDY,
input data_c,
input [1:0] CBE,
input clk,
output reg done
    );

reg [1:0] counter;

always @ ( clk)
begin
if (clk)
	begin
	if (data_c)
	begin
	counter <= CBE;

	end //if
	else 
	begin
		if((~IRDY) && (~TRDY))
			begin
			if(counter!=1'b0)
			begin
			counter <= counter - 1;
			end
			end
		else 
			begin
			done <= 1'b0;
			end

	end //else
end
else 
begin

		if (counter == 1)
		begin
		done <= 1'b1;
		end 
	
end 
end // always


endmodule
