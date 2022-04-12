
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	getFruitsType_6	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,

					input		logic	[7:0] fruit1_t,		
					input		logic	[7:0] fruit2_t,
					input		logic	[7:0] fruit3_t,
					input		logic	[7:0] fruit4_t,
					input		logic	[7:0] fruit5_t,
					input		logic	[7:0] fruit6_t,

		
					output	logic	[5:0] fruits_t
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			fruits_t <= 6'b0;
	end
	
	else begin
		
		fruits_t[0] = fruit1_t % 3;
		fruits_t[1] = fruit2_t % 3;
		fruits_t[2] = fruit3_t % 3;
		fruits_t[3] = fruit4_t % 3;
		fruits_t[4] = fruit5_t % 3;
		fruits_t[5] = fruit6_t % 3;
		
	end ; 
end

endmodule


