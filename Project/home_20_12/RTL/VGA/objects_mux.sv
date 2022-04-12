
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	objects_mux	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,
		   // smiley 
					input		logic	monkeyDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] monkeyRGB, 
					     
		  // add the box here 
					input		logic	ropeDrawingRequest, // two set of inputs per unit
					input		logic	[7:0] ropeRGB, 
			  
		  // background 
					input    logic groundDrawingRequest, // box of numbers
					input		logic	[7:0] groundRGB,  
				
					input    logic fruitDrawingRequest, // box of numbers
					input		logic	[7:0] fruitRGB, 
			
					input    logic monsterDrawingRequest, // box of numbers
					input		logic	[7:0] monsterRGB,  		
					
					input logic heartDR,
					input logic [7:0] heartRGB,
					
					input logic keyDR,
					input logic [7:0] keyRGB,
					
					input	logic	startDR,
					input	logic	[7:0] startRGB,   					
					
					input	logic	OverDR, 
					input	logic	[7:0] OverRGB,   
					
					input	logic	winDR,
					input	logic	[7:0] winRGB,   
					
					input		logic	[7:0] backGroundRGB, 
			  
				   output	logic	[7:0] RGBOut
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
		 if (OverDR == 1'b1)
						RGBOut <= OverRGB;	
		else if (startDR == 1'b1)
						RGBOut <= startRGB;
						
		else if (winDR == 1'b1)
						RGBOut <= winRGB;
		
		else if (heartDR == 1'b1 )   
			RGBOut <= heartRGB;   
				
		else if (monsterDrawingRequest == 1'b1 )   
			RGBOut <= monsterRGB;   
		 
		else if (monkeyDrawingRequest == 1'b1 )   
			RGBOut <= monkeyRGB;  //first priority 
		 
		 else if(fruitDrawingRequest == 1'b1)
					RGBOut <= fruitRGB;
		 
		else if(ropeDrawingRequest == 1'b1)
					RGBOut <= ropeRGB;
		
		else if(keyDR == 1'b1)
					RGBOut <= keyRGB;
		 
		else if (groundDrawingRequest == 1'b1)
						RGBOut <= groundRGB;
		else
				RGBOut <= backGroundRGB ; // last priority 
		end ; 
	end

endmodule


