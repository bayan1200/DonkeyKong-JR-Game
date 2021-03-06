
//mux to choose between two object to draw

module	ground_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,

					input		logic	darwRequest1, // two set of inputs per unit
					input		logic	[7:0] RGBrope1, 
		
					input		logic	darwRequest2, // two set of inputs per unit
					input		logic	[7:0] RGBrope2,
				
					input 	logic enable,  // enable to draw
		
					output	logic	drawRequestOut,
				   output	logic	[7:0] RGB_Out
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			drawRequestOut <= 1'b0;
			RGB_Out <= 8'b0;
	end
	
	else begin
	
		drawRequestOut <= 1'b0;
		RGB_Out <= 8'b0;
		
		if(enable) begin
			if (darwRequest1 == 1'b1 )   begin
				drawRequestOut <= darwRequest1;
				RGB_Out <= RGBrope1;  //first priority 
			end
		 
			else if(darwRequest2 == 1'b1) begin
				drawRequestOut <= darwRequest2;
				RGB_Out <= RGBrope2;  //second priority 	
			end			
		 end
		 
	end ; 
end

endmodule


