
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	fourFruitType_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,

					input		logic	[7:0] fruit1,
					input		logic	darwRequest1, // two set of inputs per unit
		
					input		logic	[7:0] fruit2,
					input		logic	darwRequest2, // two set of inputs per unit
					
					input		logic	[7:0] fruit3,
					input		logic	darwRequest3, // two set of inputs per unit
				
					input		logic	[7:0] fruit4,
					input		logic	darwRequest4, // two set of inputs per unit
		
					output	logic	[7:0] fruit_type,
					output	logic	drawRequestOut
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			drawRequestOut <= 1'b0;
			fruit_type <= 7'b0;
	end
	
	else begin
		drawRequestOut <= (darwRequest1 || darwRequest2 || darwRequest3 || darwRequest4);
		fruit_type <= 7'b0;
		
		if (darwRequest1 == 1'b1 )   begin
			fruit_type <= fruit1;
		 end
		 
		 else if(darwRequest2 == 1'b1) begin
			fruit_type <= fruit2;
		end			
		else if(darwRequest3 == 1'b1) begin
			fruit_type <= fruit3;
		end	
		else if(darwRequest4 == 1'b1) begin
			fruit_type <= fruit4;
		end	
	end ; 
end

endmodule


