`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:08:50 12/24/2018
// Design Name:   Master_Slave
// Module Name:   D:/Courses/Digital/KOLIA/PCI/testdata.v
// Project Name:  PCI
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Master_Slave
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testdata;

	// Inputs
	reg GNT;
	reg IDsel;
   reg CLK;
	wire done;
	reg force_en;
	reg IRDY;
	reg TRDY;
	reg data_c;
	// Outputs
	wire S_M;
	wire Frame;
	wire count_done;

	// Instantiate the Unit Under Test (UUT)
	Master_Slave uut (
		.GNT(GNT), 
		.IDsel(IDsel), 
		.S_M(S_M), 
		.CLK(CLK), 
		.done(done), 
		.force_en(force_en), 
		.Frame(Frame), 
		.count_done(count_done)
	);

reg [1:0] CBE;
dataphaseCount data1 (
    .IRDY(IRDY), 
    .TRDY(TRDY), 
    .data_c(data_c), 
    .CBE(CBE), 
    .clk(CLK), 
    .done(done), 
    .count_done(count_done)
    );




endmodule