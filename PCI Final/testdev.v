`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:26:25 12/19/2018
// Design Name:   PCI_DEV
// Module Name:   D:/Courses/Digital/KOLIA/PCI/testdev.v
// Project Name:  PCI
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: PCI_DEV
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testdev;

	// Inputs
	reg IDSEL;
	reg CLK;
	reg GNT;
	reg [31:0] AD_TO_C;
	reg forced_en;
	reg [3:0] CBE_TO_C;

	// Outputs
	wire Frame;
	wire REQ;

	// Bidirs
	wire [31:0] AD;
	wire [3:0] C_BE;
	wire TRDY;
	wire IRDY;
	wire DEVSEL;

	// Instantiate the Unit Under Test (UUT)
	PCI_DEV uut (
		.AD(AD), 
		.C_BE(C_BE), 
		.Frame(Frame), 
		.TRDY(TRDY), 
		.IRDY(IRDY), 
		.DEVSEL(DEVSEL), 
		.IDSEL(IDSEL), 
		.CLK(CLK), 
		.GNT(GNT), 
		.REQ(REQ), 
		.AD_TO_C(AD_TO_C), 
		.forced_en(forced_en), 
		.CBE_TO_C(CBE_TO_C)
	);

	initial begin
		// Initialize Inputs
		IDSEL = 0;
		CLK = 0;
		GNT = 0;
		AD_TO_C = 0;
		forced_en = 0;
		CBE_TO_C = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

