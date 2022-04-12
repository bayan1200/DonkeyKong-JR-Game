
//choose which rope to draw

module	movingRope_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,

					input		logic	[10:0] offsetX1, // three set of inputs per unit
					input		logic	[10:0] offsetY1, 
					input		logic	drawRequest1, 
					
					input		logic	[10:0] offsetX2, // three set of inputs per unit
					input		logic	[10:0] offsetY2, 
					input		logic	drawRequest2, 
					
					output	logic	[10:0] outOffsetX, // three set of inputs per unit
					output	logic	[10:0] outOffsetY, 
					output	logic	outDrawRequest 
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			outOffsetX <= 11'b0;
			outOffsetY <= 11'b0;
			outDrawRequest <= 1'b0;
	end
	
	else begin
		if (drawRequest1 == 1'b1 )   begin
			outOffsetX <= offsetX1;
			outOffsetY <= offsetY1;
			outDrawRequest <= drawRequest1;
		 end
		 else if(drawRequest2 == 1'b1) begin
			outOffsetX <= offsetY2;
			outOffsetY <= offsetX2;
			outDrawRequest <= drawRequest2;
		end			
		else begin
			outOffsetX <= 11'b0;
			outOffsetY <= 11'b0;
			outDrawRequest <= 1'b0;
		end
	end ; 
end

endmodule


