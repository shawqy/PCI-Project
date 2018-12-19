`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:46:09 12/12/2018 
// Design Name: 
// Module Name:    address_buffer 
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
module address_buffer(

input  [31 : 0] AD_IN, 
output [31 : 0] AD_OUT,
output [31 : 0] AD_to_memory,
input [31 : 0] Address_To_Contact,
input R_W // one for  wtite 
// zero for read 
    );

//wire I_O_read, I_O_write;
//assign I_O_read = ((~CB [3]) & (~ CB[2]) & (~ CB[0]) & (CB [1]) );
//assign I_O_write = ((~CB [3]) & (~ CB[2]) & ( CB[0]) & (CB [1]) );
/*
assign AD = (R_W)? Address_To_Contact: 8'hzz;
assign AD_to_memory =(!R_W)?  AD : 8'hzz ;
*/

assign AD_OUT = (R_W)? Address_To_Contact:8'bzzzz_zzzz ; 
assign AD_to_memory =(!R_W)?  AD_IN : 8'hzz ;


endmodule
