
module FRAME_deassert (clk, data_num, frame);
input clk;
input [3 : 0] data_num;
output reg[3 : 0] frame;
reg [3 : 0] counter;

initial // fe moshkela hena en kol clk cycle be3mel initialization for the counter 
begin
assign counter = data_num;
end

always @ (posedge clk) // kol clock el-data num will decrease
begin
counter <= counter - 1;
if (counter == 1)
begin
frame <= 1;
end 
end

endmodule

////////////////////////////////////////////////////////////////////
module BYTE_ENABLE (clk, c_be, R_W, irdy, AD, AD_modified);
input clk, irdy, R_W;
input [3 : 0] c_be;
input [31 : 0] AD;
output reg [31 : 0] AD_modified;

always @ (posedge clk)
begin
	if (irdy == 0)
	begin
		case (R_W)
		0 : // read
		begin
			case (c_be)
			4'b0000 : AD_modified <= 32'h00;
			4'b0001 : AD_modified <= {24'h00, AD[7 : 0]}; // first byte
			4'b0010 : AD_modified <= {16'h00, AD[15 : 8]}; // second byte
			4'b0100 : AD_modified <= {24'h00, AD[23 : 16]}; // third byte
			4'b1000 : AD_modified <= {24'h00, AD[31 : 24]}; // fourth byte

			4'b0011 : AD_modified <= {16'h00, AD[15 : 0]}; // first and second byte
			4'b0101 : AD_modified <= {16'h00, AD[23 : 16], AD[7 : 0]}; // first and third byte
			4'b1001 : AD_modified <= {16'h00, AD[31 : 24], AD[7 : 0]}; // first and fourth byte

			4'b0110 : AD_modified <= {16'h00, AD[23 : 8]}; // second and third byte
			4'b1010 : AD_modified <= {16'h00, AD[31 : 24], AD[15 : 8]}; // second and fourth byte
			
			4'b1100 : AD_modified <= {16'h00, AD[31 : 16]}; // third and fourth byte

			4'b1111 : AD_modified <= AD;
			endcase
		end 
		1 : //write
		begin
			case (c_be)
			4'b0000 : AD_modified <= 32'h00;
			4'b0001 : AD_modified <= {24'h00, AD[7 : 0]};
			4'b0010 : AD_modified <= {24'h00, AD[15 : 8]};
			4'b0100 : AD_modified <= {24'h00, AD[23 : 16]};
			4'b1000 : AD_modified <= {24'h00, AD[31 : 24]};
			4'b1111 : AD_modified <= AD; // write 32 bits
			endcase
		end
		endcase
	end
end

endmodule
