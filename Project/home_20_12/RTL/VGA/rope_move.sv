//moving the rope


module	rope_move(
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					//input logic collision,  //collision if smiley hits an object
					//input	logic	[3:0] HitEdgeCode, //one bit per edge 

					output	 logic signed 	[10:0]	topLeftX, // output the top left corner 
					output	 logic signed	[10:0]	topLeftY,  // can be negative , if the object is partliy outside 
					output	 logic signed  [10:0]   widthX
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 450;
parameter int INITIAL_Y = 226;
parameter int INITIAL_X_SPEED = 40;
parameter int INITIAL_WIDTH = 123;
parameter int  MAX_X = 544;
parameter int  MIN_X = 400;



const int	FIXED_POINT_MULTIPLIER	=	128;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions


int Xspeed, topLeftX_FixedPoint, widthX_Fixed; // local parameters 

//////////--------------------------------------------------------------------------------------------------------------=
//  calculation of X Axis speed using and position calculate regarding X_direction key or colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		Xspeed	<= INITIAL_X_SPEED;
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
		widthX_Fixed <= INITIAL_WIDTH * FIXED_POINT_MULTIPLIER;
	end
	else begin	
	// collisions with the sides 			
				if (topLeftX_FixedPoint < (MAX_X * FIXED_POINT_MULTIPLIER) && topLeftX_FixedPoint <= (MIN_X * FIXED_POINT_MULTIPLIER)) begin  
					if (Xspeed < 0 ) // while moving left
							Xspeed <= -Xspeed ; // positive move right 
				end
			
				if (topLeftX_FixedPoint >= (MAX_X * FIXED_POINT_MULTIPLIER) && topLeftX_FixedPoint > (MIN_X * FIXED_POINT_MULTIPLIER)) begin  // hit right border of brick  
					if (Xspeed > 0 ) //  while moving right
							Xspeed <= -Xspeed  ;  // negative move left    
				end	
		   
			
		if (startOfFrame == 1'b1 )//&& Yspeed != 0) 
		begin
			 topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed;
			 widthX_Fixed <= widthX_Fixed - Xspeed;
		end  
			
					
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = INITIAL_Y ;    
assign	widthX = widthX_Fixed / FIXED_POINT_MULTIPLIER;

endmodule
