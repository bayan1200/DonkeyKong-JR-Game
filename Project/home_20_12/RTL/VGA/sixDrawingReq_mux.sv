
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	sixDrawingReq_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,

					input		logic darwRequest1, // two set of inputs per unit
					input		logic	[7:0] RGB1, 
		
					input		logic	darwRequest2, // two set of inputs per unit
					input		logic	[7:0] RGB2, 
					
					input		logic	darwRequest3, // two set of inputs per unit
					input		logic	[7:0] RGB3, 
					
					input		logic	darwRequest4, // two set of inputs per unit
					input		logic	[7:0] RGB4, 
					
					input		logic	darwRequest5, // two set of inputs per unit
					input		logic	[7:0] RGB5, 
					
					input		logic	darwRequest6, // two set of inputs per unit
					input		logic	[7:0] RGB6, 
					
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
			
		if (darwRequest1)   begin
			drawRequestOut <= darwRequest1;
			RGBOut <= RGB1;  //first priority 
		end
		 
		else if (darwRequest2)   begin
			drawRequestOut <= darwRequest2;
			RGBOut <= RGB2;  //second priority 
		end	
		 
		else if (darwRequest3)   begin
			drawRequestOut <= darwRequest3;
			RGBOut <= RGB3;  //third priority 
		end
		
		else if (darwRequest4) begin
			drawRequestOut <= darwRequest4;
			RGBOut <= RGB4;  //third priority 
		end
		else if (darwRequest5)   begin
			drawRequestOut <= darwRequest5;
			RGBOut <= RGB5;  //third priority 
		end
		
		else begin
			drawRequestOut <= darwRequest6;
			RGBOut <= RGB6;  //third priority 
		end
		
	end ; 
end

endmodule


