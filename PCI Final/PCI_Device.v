`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:43:16 12/12/2018 
// Design Name: 
// Module Name:    PCI_Device 
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
module PCI_Device(RST, CLK, AD, C_BE, FRAME, TRDY, IRDY, DEVSEL, REQ, GNT);
input RST, CLK, GNT;
output REQ;
inout [31 : 0] AD;
inout [3 : 0] C_BE;
inout TRDY, IRDY, FRAME, DEVSEL;

parameter DEV_ADD = 2'b11;
reg turn_around_cycle = 0; // by default the initiator writes data
reg [31 : 0] target_data;
reg [31 : 0] initiator_data;
reg [31 : 0] mem [0 : 9]; // intrnal memory
assign AD = (turn_around_cycle) ? target_data : initiator_data;//if turn_around_cycle == 1 so target writes data else initiator does

always @ (posedge clk or RST)
begin
	if (RST == 0)
	begin
		//initialize everything
	end
	else
	begin
		if (GNT == 0) // initiator
		begin
			FRAME <= 0;
			//send address
			//
			if(!DEVSEL) begin
			
			IRDY <= 0; // either the initiator put valid data (WRITE) or it's ready to recieve data (READ)

			case (C_BE)
			4'b0010 : begin turn_around_cycle <= 1;  end//initiator read
			4'b0011 : ;//initiator write
			endcase
			
			end
		end
		if (IRDY == 0)
		begin
			if (DEV_ADD == AD) // target
			begin
				DEVSEL <= 0;
				turn_around_cycle <= 1;
				case (C_BE)
				4'b0010 : target_data <= mem[][] ;//initiator reads
				4'b0011 : ;//initiator writes
				endcase
			end
		end
		
	end
end


endmodule
