
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	ropeAndFruit_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,

					input		logic	ropeDarwRequest, // two set of inputs per unit
					input		logic	[7:0] RGBRope, 
					input 	logic ropeHitEdge[3:0],
		
					input		logic	fruitDrawRequest, // two set of inputs per unit
					input		logic	[7:0] RGBFruit, 
					input 	logic fruitHitEdge[3:0],
					
					output	logic	drawRequestOut,
				   output	logic	[7:0] RGBOut,
					output 	logic HitEdgeCode[3:0]

);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			drawRequestOut <= 1'b0;
			RGBOut <= 8'b0;
	end
	
	else begin
		if (fruitDrawRequest == 1'b1 )   begin
			drawRequestOut <= fruitDrawRequest;
			RGBOut <= RGBFruit;  //first priority 
			HitEdgeCode <= ropeHitEdge;
		 end
		 
		 else if(ropeDarwRequest == 1'b1) begin
			drawRequestOut <= ropeDarwRequest;
			RGBOut <= RGBRope;  //first priority 	
			HitEdgeCode <= fruitHitEdge;
		end			
		else begin
			drawRequestOut <= 1'b0;
			RGBOut <= 8'b0;
	    	HitEdgeCode <= fruitHitEdge;
		end
	end ; 
end

endmodule


