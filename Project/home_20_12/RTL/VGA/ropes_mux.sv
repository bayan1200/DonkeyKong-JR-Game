
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	ropes_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,

					input		logic	darwRequest1, // two set of inputs per unit
					input		logic	[7:0] RGBrope1, 
		
					input		logic	darwRequest2, // two set of inputs per unit
					input		logic	[7:0] RGBrope2, 
					
					input		logic	darwRequest3, // two set of inputs per unit
					input		logic	[7:0] RGBrope3,
				
					input		logic	darwRequest4, // two set of inputs per unit
					input		logic	[7:0] RGBrope4,	
		
					output	logic	drawRequestOut,
				   output	logic	[7:0] RGBOut
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			drawRequestOut <= 1'b0;
			RGBOut <= 8'b0;
	end
	
	else begin
		if (darwRequest1 == 1'b1 )   begin
			drawRequestOut <= darwRequest1;
			RGBOut <= RGBrope1;  //first priority 
		 end
		 
		 else if(darwRequest2 == 1'b1) begin
			drawRequestOut <= darwRequest2;
			RGBOut <= RGBrope2;  //first priority 	
		end			
		else if(darwRequest3 == 1'b1) begin
			drawRequestOut <= darwRequest3;
			RGBOut <= RGBrope3;  //first priority 	
		end	
		else if(darwRequest4 == 1'b1) begin
			drawRequestOut <= darwRequest4;
			RGBOut <= RGBrope4;  //first priority 	
		end	
		else begin
			drawRequestOut <= 1'b0;
			RGBOut <= 8'b0;
		end
	end ; 
end

endmodule


