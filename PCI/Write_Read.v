`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:34:49 12/12/2018 
// Design Name: 
// Module Name:    Write_Read 
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

module Write_Read(
    inout [3:0] C_BE,
    input [3:0] C_BE_Contact,
	 input S_M,
    output reg R_W,
	 output reg Data_count,
	 input devsel,
	 input clk,
	 output  IRDY
    );


assign C_BE = (S_M)? C_BE_Contact : 8'hzz;

assign IRDY = devsel ? 1'b1 : 1'b0 ;




always @(posedge clk)
begin
	if (devsel == 1'b1)
	begin
	if (S_M == 1'b1)
	begin
		casez (C_BE)
		4'bzz00 : begin
		Data_count <= 1'b1 ;
		R_W <= 1'b1 ;
		end
		//write
		4'b0011: begin
		Data_count <= 1'b0 ;
		R_W <= 1'b1 ;
		end
		//read
		4'b0010: begin
		Data_count <= 1'b0 ;
		R_W <= 1'b0 ;
		end
		
		endcase
		
	end
	else
		begin
		casez (C_BE)
		
		//write
		4'b0011: begin
		Data_count <= 1'b0 ;
		R_W <= 1'b0 ;
		end
		//read
		4'b0010: begin
		Data_count <= 1'b0 ;
		R_W <= 1'b1 ;
		end
		
		endcase
		
		end
	
	end
	
end 

endmodule
