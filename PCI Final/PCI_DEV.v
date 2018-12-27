`timescale 1ns / 1ps

module PCI_DEV(
inout [31:0] AD,
inout [3:0] C_BE,
output Frame,
inout TRDY,
inout IRDY,
inout DEVSEL,
input IDSEL,
input CLK,
input GNT,
output REQ,
input [31:0] AD_TO_C,
input forced_en,
input [3:0] CBE_TO_C,
input frame_reader
    );
	 
	 
assign REQ = forced_en;
wire S_M, done, R_W,gnt, frame,irdy,trdy,devsel,clk,idsel, req,Data_count;
wire irdymemory;

wire [31:0]  AD_to_memory;
wire [31:0]	 AD_C;
assign clk = CLK;
assign AD_C =AD_TO_C;
assign Frame = frame;
assign gnt = GNT;
assign idsel = IDSEL;
assign req = REQ;


wire [3:0] CBE_C;
assign CBE_C = CBE_TO_C;

wire [3:0] c_be;
wire [31:0] ad_in;
wire [31:0] ad_out;


wire force_en;
wire count_done;
wire frame_read;


assign frame_read=frame_reader;


assign force_en = forced_en;
//check if this device is master or slave
Master_Slave MASTER_SLAVE_MODE (
    .GNT(gnt), 
    .IDsel(idsel), 
    .S_M(S_M), 
    .CLK(clk), 
    .done(done), 
	 .force_en(force_en), 
    .Frame(frame),
	 .count_done(count_done),
	 .frame_reader(frame_read)
    );
//check the C_BE for the control word  	 
Write_Read WRITE_READ_MODE (
    .C_BE(c_be), 
    .C_BE_Contact(CBE_C), 
    .S_M(S_M), 
    .R_W(R_W), 
    .Data_count(Data_count), 
    .devsel(devsel), 
    .clk(clk), 
    .IRDY(irdy)
    );

//choose the direction of the AD input or output
address_buffer AD_Control (
    .AD_IN(ad_in), 
    .AD_OUT(ad_out),
    .AD_to_memory(AD_to_memory), 
    .Address_To_Contact(AD_C), 
    .R_W(R_W)
    );
wire [1:0] CBE;
assign CBE =(c_be[1:0] == 2'b00)?  c_be [3:2] : CBE ;
//count how many data phase to be transimited
dataphaseCount PHASE_COUNTER(
    .IRDY(irdymemory), 
    .TRDY(trdy), 
    .data_c(Data_count), 
    .CBE(CBE), 
    .clk(clk), 
    .done(done),
	 .count_done(count_done)
    );


//if master device master IRDY is output the irdy signal from write and read block
// urdymemory is signal assigned to the all irdy ports in input mode only 
// if master irdymemory is input from irdy small if master come from IRDy port

assign IRDY = {S_M}? irdy : 1'bz;
assign irdymemory = {S_M}? irdy : IRDY;


assign TRDY = (S_M)? 1'bz :(idsel) ? 1'bz : irdy;
assign trdy =  {S_M}? TRDY : irdy;

assign devsel = (S_M)? DEVSEL : idsel;
assign  DEVSEL =  (S_M)? 1'bz : (idsel) ? 1'bz : devsel;

assign C_BE = (S_M)? c_be : 4'bzzzz;
assign c_be = (S_M)? 4'bzzzz : C_BE;


assign AD = (R_W)? ad_out : 32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;
assign ad_in = (R_W)? 32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz : AD;

//memory to store the data
memory MEMORY (
    .IRDY(irdymemory), 
    .TRDY(trdy), 
    .clk(clk), 
    .C_BE(c_be), 
    .data(AD_to_memory)
    );

endmodule
