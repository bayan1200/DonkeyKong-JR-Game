// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	fruit_move(
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					
					output	 logic signed	[10:0]	topLeftY  // can be negative , if the object is partliy outside 
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_Y = 226;
parameter int INITIAL_Y_SPEED = 40;
parameter int  MAX_Y = 544;
parameter int  MIN_Y = 400;



const int	FIXED_POINT_MULTIPLIER	=	128;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions


int Yspeed, topLeftY_FixedPoint; // local parameters 

//////////--------------------------------------------------------------------------------------------------------------=
//  calculation of Y Axis speed using and position calculate regarding X_direction key or colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		Yspeed	<= INITIAL_Y_SPEED;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
	end
	else begin	
	// collisions with the sides 			
				if (topLeftY_FixedPoint < (MAX_Y * FIXED_POINT_MULTIPLIER) && topLeftY_FixedPoint <= (MIN_Y * FIXED_POINT_MULTIPLIER)) begin  
					if (Yspeed < 0 ) // while moving left
							Yspeed <= -Yspeed ; // positive move right 
				end
			
				if (topLeftY_FixedPoint >= (MAX_Y * FIXED_POINT_MULTIPLIER) && topLeftY_FixedPoint > (MIN_Y * FIXED_POINT_MULTIPLIER)) begin  // hit right border of brick  
					if (Yspeed > 0 ) //  while moving right
							Yspeed <= -Yspeed  ;  // negative move left    
				end	
				
			
		if (startOfFrame == 1'b1 )//&& Yspeed != 0) 
		begin
			topLeftY_FixedPoint  <= topLeftY_FixedPoint + Yspeed;
					
		end  
			
					
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER  ;    

endmodule
