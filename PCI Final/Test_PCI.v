




module Test_PCI();



wire IDSEL_A,IDSEL_B,IDSEL_C;

wire [3:0]OUT;
reg clk;


assign IDSEL_A=OUT[3];
assign IDSEL_B=OUT[2];
assign IDSEL_C=OUT[1];

wire [31:0] AD;


wire [1:0]IN ;
wire enable;
wire [3:0]C_BE ;

assign IN= AD[1:0];

assign enable= (AD[31:2] == 30'd0) ? (C_BE[1:0]==2'b00)? 1'b1: 1'b0 : 1'b0;


wire REQ_A,REQ_B,REQ_C,GNT_A,GNT_B,GNT_C,frame_low;

wire Frame_A,Frame_B,Frame_C; 


assign frame_low=Frame_A & Frame_B & Frame_C ;

wire IRDY;
wire TRDY;
wire DEVSEL;
wire frame_reader;

assign DEVSEL = (OUT == 4'b1111)? 1'b1: 1'bz;
assign TRDY = (OUT == 4'b1111)? 1'b1: 1'bz;


reg [31:0] AD_TO_C_A;
reg [3:0] CBE_TO_C_A;
reg forced_en_A;

reg [31:0] AD_TO_C_B;
reg [3:0] CBE_TO_C_B;
reg forced_en_B;

reg [31:0] AD_TO_C_C;
reg [3:0] CBE_TO_C_C;
reg forced_en_C;


//Decoder
Decoder Decoder_1(
    .IN(IN), 
    .OUT(OUT), 
    .enable(enable),
	 .frame(frame_low)
    );


//wire AD_A;
//wire IRDY_A;

//Device A
PCI_DEV Dev_A(
    .AD(AD), 
    .C_BE(C_BE), 
    .Frame(Frame_A), 
    .TRDY(TRDY), 
    .IRDY(IRDY), 
    .DEVSEL(DEVSEL), 
    .IDSEL(IDSEL_A), 
    .CLK(clk), 
    .GNT(GNT_A), 
    .REQ(REQ_A), 
    .AD_TO_C(AD_TO_C_A), 
    .forced_en(forced_en_A), 
    .CBE_TO_C(CBE_TO_C_A),
    .frame_reader(frame_reader)
	 );


//Device B
PCI_DEV Dev_B(
    .AD(AD), 
    .C_BE(C_BE), 
    .Frame(Frame_B), 
    .TRDY(TRDY), 
    .IRDY(IRDY), 
    .DEVSEL(DEVSEL), 
    .IDSEL(IDSEL_B), 
    .CLK(clk), 
    .GNT(GNT_B), 
    .REQ(REQ_B), 
    .AD_TO_C(AD_TO_C_B), 
    .forced_en(forced_en_B), 
    .CBE_TO_C(CBE_TO_C_B),
	 .frame_reader(frame_reader)
    );



//Device C
PCI_DEV Dev_C (
    .AD(AD), 
    .C_BE(C_BE), 
    .Frame(Frame_C), 
    .TRDY(TRDY), 
    .IRDY(IRDY), 
    .DEVSEL(DEVSEL), 
    .IDSEL(IDSEL_C), 
    .CLK(clk), 
    .GNT(GNT_C), 
    .REQ(REQ_C), 
    .AD_TO_C(AD_TO_C_C), 
    .forced_en(forced_en_C), 
    .CBE_TO_C(CBE_TO_C_C),
    .frame_reader(frame_reader)
    );



// Arbiter
arbiter Arbiter1 (
    .clk(clk), 
    .REQ_A(REQ_A), 
    .REQ_B(REQ_B), 
    .REQ_C(REQ_C), 
    .REQ_D(REQ_D), 
    .frame_low(frame_low), 
    .IRDY(IRDY), 
    .GNT_A(GNT_A), 
    .GNT_B(GNT_B), 
    .GNT_C(GNT_C), 
    .GNT_D(GNT_D),
    .frame_reader(frame_reader)
    );

	initial
		begin
				clk = 0;
				#200
				
				forced_en_A = 0;
				#100
				forced_en_A = 1 ;
				#200
				AD_TO_C_A = 32'h00000001; 
				CBE_TO_C_A = 4'b1100; 
				#100
				CBE_TO_C_A = 4'b0011;
				AD_TO_C_A = 32'hAAAAAAAA;
				
				#300
				
				forced_en_B = 0;
				#100
				forced_en_B = 1 ;
				#200
				AD_TO_C_B = 32'h00000000; 
				CBE_TO_C_B = 4'b1100; 
				#100
				CBE_TO_C_B = 4'b0011;
				AD_TO_C_B = 32'hBBBBBBBB;
				
				#300
				
				forced_en_A = 1'b0;
				forced_en_C = 1'b0;
				#100
				forced_en_A = 1'b1;
				#100
				forced_en_C = 1'b1;
				#100
				AD_TO_C_A = 32'h00000002; 
				CBE_TO_C_A = 4'b1000; 
				#100
				AD_TO_C_A = 32'hAAAAAAAA; 
				CBE_TO_C_A = 4'b0011;
				#400
				AD_TO_C_C = 32'h00000000; 
				CBE_TO_C_C = 4'b0100;
				#100
				AD_TO_C_C = 32'hCCCCCCCC; 
				CBE_TO_C_C = 4'b0011;
				#200
				AD_TO_C_C = 32'b0000_0000_0000_0000_0000_0000_0000_00zz; 
				CBE_TO_C_C = 4'b0100;
				#50
				AD_TO_C_C = 32'h00000001; 
				#100
				AD_TO_C_C = 32'hCCCCCCCC; 
				CBE_TO_C_C = 4'b0011;
		end 


always 
	begin
	#50 
	clk = ~clk;
	end


endmodule