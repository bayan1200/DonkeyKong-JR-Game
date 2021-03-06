

module	square_object_with_width	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic signed	[10:0] pixelX_w,// current VGA pixel 
					input 	logic signed	[10:0] pixelY_w,
					input 	logic signed	[10:0] topLeftX_w, //position on the screen 
					input 	logic	signed [10:0] topLeftY_w,   // can be negative , if the object is partliy outside 
					input		logic signed [10:0] widthX,
					
					output 	logic	[10:0] offsetX_w,// offset inside bracket from top left position 
					output 	logic	[10:0] offsetY_w,
					output	logic	drawingRequest_w, // indicates pixel inside the bracket
					output	logic	[7:0]	 RGBout_w //optional color output for mux 
);

parameter  int OBJECT_HEIGHT_Y = 100;
parameter  logic [7:0] OBJECT_COLOR = 8'h5b ; 
localparam logic [7:0] TRANSPARENT_ENCODING = 8'hFF ;// bitmap  representation for a transparent pixel 
 
int rightX ; //coordinates of the sides  
int bottomY ;
logic insideBracket ; 

//////////--------------------------------------------------------------------------------------------------------------=
// Calculate object right  & bottom  boundaries
assign rightX	= (topLeftX_w + widthX);
assign bottomY	= (topLeftY_w + OBJECT_HEIGHT_Y);
assign	insideBracket  = 	 ( (pixelX_w  >= topLeftX_w) &&  (pixelX_w < rightX) // math is made with SIGNED variables  
						   && (pixelY_w  >= topLeftY_w) &&  (pixelY_w < bottomY) )  ; // as the top left position can be negative
		


//////////--------------------------------------------------------------------------------------------------------------=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout_w			<=	8'b0;
		drawingRequest_w	<=	1'b0;
	end
	else begin 
		// DEFUALT outputs
	      RGBout_w <= TRANSPARENT_ENCODING ; // so it will not be displayed 
			drawingRequest_w <= 1'b0 ;// transparent color 
			offsetX_w	<= 0; //no offset
			offsetY_w	<= 0; //no offset
	
 
		if (insideBracket) // test if it is inside the rectangle 
		begin 
			RGBout_w  <= OBJECT_COLOR ;	// colors table 
			drawingRequest_w <= 1'b1 ;
			offsetX_w	<= (pixelX_w - topLeftX_w); //calculate relative offsets from top left corner allways a positive number 
			offsetY_w	<= (pixelY_w - topLeftY_w);
		end 
		

		
	end
end 
endmodule 