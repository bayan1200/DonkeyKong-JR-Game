
//mux to choose beween two objects which one to draw and get their offsets

module	twoDRwithOffsets_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,

					input		logic	[10:0] offsetX1,
					input		logic	[10:0] offsetY1,
					input		logic	darwRequest1, // two set of inputs per unit
		
					input		logic	[10:0] offsetX2,
					input		logic	[10:0] offsetY2,
					input		logic	darwRequest2, // two set of inputs per unit
		
					output	logic	[10:0] offset_x,
					output	logic	[10:0] offset_y,
					output	logic	drawRequestOut
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			drawRequestOut <= 1'b0;
			offset_x <= 11'b0;
			offset_y <= 11'b0;
	end
	
	else begin
		drawRequestOut <= (darwRequest1 || darwRequest2);
		offset_x <= 11'b0;
		offset_y <= 11'b0;
		
		if (darwRequest1 == 1'b1 )   begin
			offset_x <= offsetX1;
			offset_y <= offsetY1;
		 end
		 
		 else if(darwRequest2 == 1'b1) begin
			offset_x <= offsetX2;
			offset_y <= offsetY2;
		end			
	end ; 
end

endmodule


