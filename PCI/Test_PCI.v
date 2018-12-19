`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:38:07 12/19/2018
// Design Name:   PCI_DEV
// Module Name:   D:/Courses/Digital/KOLIA/PCI/Test_PCI.v
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


// Clock Module
module Clock(output reg clk);
initial 
clk=0;
always 
#5 clk=~clk;
endmodule


//Test Becnh
module Test_PCI;


// Inputs
wire CLK;
	
	
//Buses
wire TRDY;
wire IRDY;
wire DEVSEL;
wire [31:0] AD;
wire [3:0] C_BE;
wire Frame;

//Device A
   wire Frame_A;
	wire IRDY_A;
   wire TRDY_A;
	wire Devsel_A;
	reg [31:0] AD_TO_C_A;
	reg [3:0] CBE_TO_C_A;
   wire GNT_A; 
   wire REQ_A;
   reg forced_en_A;
   wire IDSEL_A;
//Device B
   wire Frame_B;
   wire IRDY_B;
   wire TRDY_B;
	wire Devsel_B;
	reg [31:0] AD_TO_C_B;
	reg [3:0] CBE_TO_C_B;
   wire GNT_B; 
	wire REQ_B;
	reg forced_en_B;
   wire IDSEL_B;

//Device C
   wire Frame_C;
   wire IRDY_C;
   wire TRDY_C;
	wire Devsel_C;
	reg [31:0] AD_TO_C_C;
	reg [3:0] CBE_TO_C_C;
   wire GNT_C; 
   wire REQ_C;
	reg forced_en_C;
   wire IDSEL_C;

//Device D
   wire Frame_D;
   wire IRDY_D;
   wire TRDY_D;
	wire Devsel_D;
	reg [31:0] AD_TO_C_D;
	reg [3:0] CBE_TO_C_D;
   wire GNT_D; 
   wire REQ_D;
	reg forced_en_D;
   wire IDSEL_D;
	
  //Decoder Ins & Outs
  reg enable;
  wire [4:0]IDSEL_MAIN;
  wire AD_Decoder=AD[0:1];
  
  
assign TRDY = TRDY_A & TRDY_B & TRDY_C & TRDY_D ;  

assign IRDY = IRDY_A & IRDY_B & IRDY_C & IRDY_D ;    
  
 
assign DEVSEL = Devsel_A & Devsel_B & Devsel_C & Devsel_D ;  
 
assign Frame = Frame_A & Frame_B & Frame_C & Frame_D;
 
assign IDSEL_A=IDSEL_MAIN[0];

assign IDSEL_B=IDSEL_MAIN[1];

assign IDSEL_C=IDSEL_MAIN[2];

assign IDSEL_D=IDSEL_MAIN[3]; 
  
 //Clock Instance
 Clock c1(
  CLK
  );  
  
  
  //Decode Instance
  Decoder D1(
    .IN(AD_TO_C_A[1:0]), 
    .OUT(IDSEL_MAIN), 
    .enable(enable)
    );


//Device A Instance
	PCI_DEV A (
		.AD(AD), 
		.C_BE(C_BE), 
		.Frame(Frame_A), 
		.TRDY(TRDY_A),
		.IRDY(IRDY_A), 
		.DEVSEL(Devsel_A), 
		.IDSEL(IDSEL_A), 
		.CLK(CLK), 
		.GNT(GNT_A), 
		.REQ(REQ_A), 
		.AD_TO_C(AD_TO_C_A), 
		.forced_en(forced_en_A), 
		.CBE_TO_C(CBE_TO_C_A)
	);


	 
//Device B Instance
PCI_DEV  B (
    .AD(AD), 
    .C_BE(C_BE), 
    .Frame(Frame_B), 
    .TRDY(TRDY_B), 
    .IRDY(IRDY_B), 
    .DEVSEL(Devsel_B), 
    .IDSEL(IDSEL_B), 
    .CLK(CLK), 
    .GNT(GNT_B), 
    .REQ(REQ_B), 
    .AD_TO_C(AD_TO_C_B), 
    .forced_en(forced_en_B), 
    .CBE_TO_C(CBE_TO_C_B)
    );	



//Device C Instance
PCI_DEV  C (
    .AD(AD), 
    .C_BE(C_BE), 
    .Frame(Frame_C), 
    .TRDY(TRDY_C), 
    .IRDY(IRDY_C), 
    .DEVSEL(Devsel_C), 
    .IDSEL(IDSEL_C), 
    .CLK(CLK), 
    .GNT(GNT_C), 
    .REQ(REQ_C), 
    .AD_TO_C(AD_TO_C_C), 
    .forced_en(forced_en_C), 
    .CBE_TO_C(CBE_TO_C_C)
    );
	 
//Device D Instance
PCI_DEV  D (
    .AD(AD), 
    .C_BE(C_BE), 
    .Frame(Frame_D), 
    .TRDY(TRDY_D), 
    .IRDY(IRDY_D), 
    .DEVSEL(Devsel_D), 
    .IDSEL(IDSEL_D), 
    .CLK(CLK), 
    .GNT(GNT_C_D), 
    .REQ(REQ_C_D), 
    .AD_TO_C(AD_TO_C_D), 
    .forced_en(forced_en_D), 
    .CBE_TO_C(CBE_TO_C_D)
    );	 


//arbiter Instance
arbiter_1  Arbiter(
    .clk(CLK), 
    .REQ_A(REQ_A), 
    .REQ_B(REQ_B), 
    .REQ_C(REQ_C), 
    .REQ_D(REQ_D), 
    .frame_low(Frame), 
    .GNT_A(GNT_A), 
    .GNT_B(GNT_B), 
    .GNT_C(GNT_C), 
    .GNT_D(GNT_D)
    );




initial 
begin

enable=1'b1;
forced_en_A=1;
#3
forced_en_A=0;
#8
forced_en_A=1;
#10
AD_TO_C_A=32'h0000_0001;
CBE_TO_C_A=0100;








end



  
endmodule

