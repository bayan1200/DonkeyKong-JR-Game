

//mux to return the rgb of the object that want to draw in the current clk rise

module	threeDrawingReq_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,

					input		logic darwRequest1, // two set of inputs per unit
					input		logic	[7:0] RGB1, 
		
					input		logic	darwRequest2, // two set of inputs per unit
					input		logic	[7:0] RGB2, 
					
					input		logic	darwRequest3, // two set of inputs per unit
					input		logic	[7:0] RGB3, 
					
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
	
		drawRequestOut <= (darwRequest1 || darwRequest2 || darwRequest3);
		RGBOut <= 8'b0;
			
		if (darwRequest1)   begin
			RGBOut <= RGB1;  //first priority 
		end
		 
		else if (darwRequest2)   begin
			RGBOut <= RGB2;  //second priority 
		end	
		 
		else if (darwRequest3)   begin
			RGBOut <= RGB3;  //third priority 
		end
		
		
	end ; 
end

endmodule


