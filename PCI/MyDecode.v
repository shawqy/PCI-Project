`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:08:32 12/19/2018 
// Design Name: 
// Module Name:    MyDecode 
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
//Decoder

module Decoder(
input [1:0] IN,
output reg [3:0] OUT,
input enable
);

always @(IN, enable)
begin
if(enable)
begin
if(IN==2'b00)
begin
OUT<=4'b0111;
end
else if(IN==2'b01)
begin
OUT<=4'b1011;
end
else if(IN==2'b10)
begin
OUT<=4'b1101;
end
else if(IN==2'b11)
begin
OUT<=4'b1110;
end
else
begin
OUT<=4'bzzzz;
end
end
end
endmodule
