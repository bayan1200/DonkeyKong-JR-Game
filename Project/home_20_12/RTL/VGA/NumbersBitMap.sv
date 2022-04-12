//
// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2021
// generating a number bitmap 



module NumbersBitMap	(	
					input		logic	clk,
					input		logic	resetN,
					input 	logic	[10:0] offsetX,// offset from top left  position 
					input 	logic	[10:0] offsetY,
					input		logic	InsideRectangle, //input that the pixel is within a bracket 
					input 	logic	[3:0] digit, // digit to display
					
					output	logic				drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0]		RGBout
					//output	logic	[3:0] HitEdgeCode //one bit per edge 

);
// generating a smily bitmap 

parameter  logic	[7:0] digit_color = 8'h00 ; //set the color of the digit 


bit [0:31][0:31] [7:0] object_colors  = {
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hd1,8'hd1,8'hd1,8'h88,8'hd0,8'hd1,8'h91,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hd2,8'hd9,8'h90,8'h88,8'hd0,8'h90,8'h91,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'h91,8'hd1,8'hd0,8'hd0,8'hd1,8'h89,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hdb,8'hda,8'hd1,8'hd0,8'h90,8'h90,8'h88,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hdb,8'hda,8'hd1,8'hd1,8'hd1,8'h88,8'h88,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'hd1,8'hd9,8'h88,8'hd0,8'h48,8'h88,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hd2,8'hd9,8'h91,8'h88,8'hd0,8'h88,8'h91,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'hd9,8'hd1,8'h88,8'hd0,8'h90,8'h89,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'hd1,8'hd1,8'h90,8'hd1,8'hd0,8'h88,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hdb,8'hd1,8'hd1,8'h90,8'hd0,8'h90,8'h40,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hdb,8'hda,8'hd1,8'hd0,8'hd1,8'h90,8'h40,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hdb,8'hd9,8'hd1,8'h90,8'hd1,8'h88,8'h88,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'hd1,8'hd1,8'h48,8'hd0,8'h90,8'h91,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'hd9,8'hd1,8'h90,8'hd0,8'hd0,8'h88,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'hd9,8'hd1,8'hd1,8'hd1,8'hd0,8'h88,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'h91,8'hd9,8'hd1,8'h90,8'hd0,8'h40,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'hda,8'hd1,8'hd1,8'hd1,8'hd1,8'h40,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'hd9,8'hd2,8'h90,8'hd0,8'h91,8'h88,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'hda,8'hda,8'h48,8'hd0,8'h88,8'h89,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hd2,8'hd1,8'hd9,8'h88,8'hd0,8'hd0,8'h88,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hd2,8'hd9,8'hd1,8'hd0,8'hd1,8'hd0,8'h88,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'h91,8'hd1,8'hd1,8'hd1,8'hd0,8'h48,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'hda,8'hd9,8'hd1,8'h88,8'hd0,8'h40,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'hd9,8'hd1,8'hd1,8'hd1,8'hd0,8'h40,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'hd9,8'hda,8'h90,8'hd1,8'h88,8'h88,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hd2,8'hda,8'hd9,8'h88,8'hd1,8'h90,8'h89,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hd2,8'hd9,8'hd1,8'h90,8'hd1,8'h88,8'h88,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'hd1,8'hd1,8'hd1,8'hd1,8'hd0,8'h40,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'hd1,8'hd9,8'hd0,8'h90,8'h90,8'h40,8'h00,8'h49,8'h92,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'hda,8'hd9,8'hd1,8'hd1,8'hd1,8'h48,8'h00,8'h49,8'h92,8'hdb,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hda,8'hda,8'hd9,8'h88,8'hd1,8'h88,8'h88,8'h00,8'h49,8'h92,8'hdb,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00},
	{8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hd1,8'hda,8'hda,8'h88,8'h90,8'h90,8'h88,8'h00,8'h49,8'h92,8'hdb,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00}};

																	
	


// pipeline (ff) to get the pixel color from the array 	 

always_ff@(posedge clk or negedge resetN) 
begin 
	if(!resetN) begin 
		RGBout <=	8'h00; 
		//HitEdgeCode <= 4'h0; 
	end 
	else begin 
		RGBout <= digit_color ; // default  
		//HitEdgeCode <= 4'h0; 
 
		if (InsideRectangle == 1'b1 ) 
		begin // inside an external bracket  
			//HitEdgeCode <= hit_colors[offsetY >> 3][offsetX >> 3 ]; // get hitting edge from the colors table
			RGBout <= object_colors[offsetY][offsetX]; 
		end  	 
		 
	end 
end 
assign drawingRequest = (RGBout != digit_color ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule