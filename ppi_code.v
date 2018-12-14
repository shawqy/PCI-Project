module PPI(PORTA, PORTB, PORTC, DATA, Reset, RD_low, WR_low, CS_low, PortSelect);

input wire Reset, RD_low, WR_low, CS_low; // _low means active low
input [1:0] PortSelect;

inout wire [7:0] PORTA, PORTB, PORTC, DATA;

reg Mode;
reg [7:0] A,B,C,D,control_reg;

// As the output is latch >> register //
assign PORTA=(RD_low==1 && WR_low==0 && PortSelect==0) ? A : 8'bzzzz_zzzz;
assign PORTB=(RD_low==1 && WR_low==0 && PortSelect==1) ? B : 8'bzzzz_zzzz;
assign PORTC=((RD_low==1 && WR_low==0 && PortSelect==2)||(control_reg[7]==0 && PortSelect==3)) ? C : 8'bzzzz_zzzz;
assign DATA=(RD_low==0 && WR_low==1 && PortSelect!=3) ? D : 8'bzzzz_zzzz;

always @(Reset, RD_low, WR_low, CS_low, PortSelect,DATA,control_reg)
begin

// Reset high >> All ports are input and control register is cleared.
if(Reset==1)
begin
A <= 8'bzzzz_zzzz;
B <= 8'bzzzz_zzzz;
C <= 8'bzzzz_zzzz;
control_reg <= 8'b0000_0000;
end
// end of Reset = 1 //


else if(Reset==0)
begin

if(CS_low==0)
begin
// control register is assigned to determine mode //
if(PortSelect==3)
begin

if (RD_low == 0 && WR_low == 1)
begin
D <= 8'bxxxx_xxxx;
end

else if (RD_low == 1 && WR_low == 0)
begin
control_reg<= DATA;
if(control_reg[7]==0)
begin
Mode<=1;  // BSR MODE
end
else if(control_reg[7]==1)
begin
Mode<=0;  // MODE 0
end
end 	//////// end of setting mode ////

else if (RD_low == 1 && WR_low == 1)
begin
D <= 8'bzzzz_zzzz;
end
end 	// end of PortSelect = 3 //

case(Mode)
//////////////////CHECK MODE EITHER BSR OR MODE0 ////////////////////////////////
0:	// MODE ZERO //
begin

case (PortSelect)
0:
begin
if (RD_low == 0 && WR_low == 1)
begin
D <= PORTA;
end

else if (RD_low == 1 && WR_low == 0)
begin
A <= DATA;
end

else if (RD_low == 1 && WR_low == 1)
begin
D <= 8'bzzzz_zzzz;
end
end 	/////// end of ( PortSelect = 0 ) PORTA /////


1:
begin
if (RD_low ==0 && WR_low == 1)
begin
D <= PORTB;
end

else if (RD_low == 1 && WR_low == 0)
begin
B <= DATA;
end

else if (RD_low == 1 && WR_low == 1)
begin
D <= 8'bzzzz_zzzz;
end
end 	/////// end of ( PortSelect = 1 ) PORTB /////


2:
begin
if (RD_low == 0 && WR_low == 1)
begin
D <= PORTC;
end

else if (RD_low == 1 && WR_low == 0)
begin
C <=DATA;
end

else if (RD_low == 1 && WR_low == 1)
begin
D <= 8'bzzzz_zzzz;
end

end 	///// end of ( PortSelect = 2 ) PORTC /////
endcase 	// End of PortSelect //
end
//////////////////////// End of MODE 0 //////////////////////////////

1:		// MODE BSR //
begin
C[DATA[3:1]]<=DATA[0];
end

endcase
end 
/////////////////////////  end of chip operation /////////////////////////////

// ALL CHIP IS NOT ENABLED //
else if(CS_low==1)
begin
D <= 8'bzzzz_zzzz;
end 	// end of CS_low = 1 //
end 	// end of RESET = 0 //
end 	// end of always block //

endmodule

////////////////////////////////////////////////////////// END OF MODULE //////////////////////////////////////////////////////



module testbench2 ();

reg Reset;
reg RD_low, WR_low, CS_low; // _low means active low
reg[1:0] PortSelect;

wire [7:0] PORTA,PORTB,PORTC,DATA;

PPI p1 (PORTA, PORTB, PORTC, DATA, Reset, RD_low, WR_low, CS_low, PortSelect); 

reg [7:0] test, test1, test2, test3;

assign DATA  = test;
assign PORTA = test1;
assign PORTB = test3;
assign PORTC = test2;

initial
begin

$monitor ("PORTC=%b PORTB=%b PORTA=%b SEL=%d   DATA=%b  Reset=%b  test2=%b test3=%b test1=%b test= %b", PORTC,PORTB,PORTA,PortSelect, DATA, Reset, test2,test3,test1, test);
// Data saved in control register to detect mode //
test=8'b1000_0011; // DATA  = test
Reset=0;
CS_low= 0;
PortSelect=3;
RD_low=1;
WR_low=0;

////////////////////////////////////////// FOR MODE 0 (I/O) ////////////////////////////////////////////

// From PortC to Data bus //
#30
test=8'bzzzz_zzzz;  // DATA  = test
test2=8'b1000_1100; // PORTC = test2
Reset=0;
CS_low=0;
PortSelect=2;
RD_low=0;
WR_low=1;
// ... //

// From Data bus to PortC //
#30
test=8'b0011_1100;  // DATA  = test
test2=8'bzzzz_zzzz; // PORTC = test2
Reset=0;
CS_low=0;
PortSelect=2;
RD_low=1;
WR_low=0;
// ... //

// From Data bus to PortB //
#30
test=8'b1100_0011;  // DATA  = test
test3=8'bzzzz_zzzz; // PORTB = test3
Reset=0;
CS_low=0;
PortSelect=1;
RD_low=1;
WR_low=0;
// ... //

// From PortB to Data bus //
#30
test=8'bzzzzz_zzzz; // DATA  = test
test3=8'b1001_1001; // PORTB = test3
Reset=0;
CS_low=0;
PortSelect=1;
RD_low=0;
WR_low=1;
// ... //

// From Data bus to PortA //
#30
test=8'b1010_0100;  // DATA  = test
test1=8'bzzzz_zzzz; // PORTA = test1
Reset=0;
CS_low=0;
PortSelect=0;
RD_low=1;
WR_low=0;
// ... //

// From PortA to Data bus //
#30
test=8'bzzzz_zzzz;  // DATA  = test
test1=8'b1111_1111; // PORTA = test1
Reset=0;
CS_low=0;
PortSelect=0;
RD_low=0;
WR_low=1;
// ... //

////////////////////////////////////// END OF MODE 0 ///////////////////////////////////

// Data saved in control register to detect mode //
#30
test=8'b00011_0001; // DATA  = test
Reset=0;
CS_low=0;
PortSelect=3;
RD_low=1;
WR_low=0;

//////////////////////////////////////// FOR BSR MODE ///////////////////////////////////////////

// Set Bit Zero in PortC //
#30
test=8'b0000_0001; // DATA  = test
Reset=0;
CS_low=0;
// ... //

// Reset Bit THREE in PortC //
#30
test=8'b0000_0110; // DATA  = test
Reset=0;
CS_low=0;
// ... //

/////////////////////////////////////// End of BSR MODE /////////////////////////////////////////////

#30
Reset=1;
PortSelect=2'bzz;

#30
Reset=0;
CS_low=1;
PortSelect=2'bzz;



end

endmodule
