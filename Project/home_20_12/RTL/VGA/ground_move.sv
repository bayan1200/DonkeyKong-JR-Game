//moving the ground in a speciffic speed and places

module	ground_move(
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 

					output	 logic signed 	[10:0]	topLeftX, // output the top left corner 
					output	 logic signed	[10:0]	topLeftY  // can be negative , if the object is partliy outside 		
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 360;
parameter int INITIAL_Y = 226;
parameter int INITIAL_Y_SPEED = 30;
parameter int INITIAL_X_SPEED = 0;
parameter int  MAX_P = 385;
parameter int  MIN_P = 90;



const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportion


int Xspeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint; // local parameters 

//////////--------------------------------------------------------------------------------------------------------------=
//  calculation of X Axis speed using and position calculate regarding X_direction key or colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		Xspeed	<= INITIAL_X_SPEED;
		topLeftX_FixedPoint	<= INITIAL_X * FIXED_POINT_MULTIPLIER;
	end
	else begin	
	// collisions with the sides 			
				if (topLeftX_FixedPoint < (MAX_P * FIXED_POINT_MULTIPLIER) && topLeftX_FixedPoint <= (MIN_P * FIXED_POINT_MULTIPLIER)) begin  
					if (Xspeed < 0 ) // while moving left
							Xspeed <= -Xspeed ; // positive move right 
				end
			
				if (topLeftX_FixedPoint >= (MAX_P * FIXED_POINT_MULTIPLIER) && topLeftX_FixedPoint > (MIN_P * FIXED_POINT_MULTIPLIER)) begin  // hit right border of brick  
					if (Xspeed > 0 ) //  while moving right
							Xspeed <= -Xspeed  ;  // negative move left    
				end	
		   
			
		if (startOfFrame == 1'b1 )
	
				  topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed;
				
	end
end


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
				if (topLeftY_FixedPoint < (MAX_P * FIXED_POINT_MULTIPLIER) && topLeftY_FixedPoint <= (MIN_P * FIXED_POINT_MULTIPLIER)) begin  
					if (Yspeed < 0 ) // while moving up
							Yspeed <= -Yspeed ; // positive move down 
				end
			
				if (topLeftY_FixedPoint >= (MAX_P * FIXED_POINT_MULTIPLIER) && topLeftY_FixedPoint > (MIN_P * FIXED_POINT_MULTIPLIER)) begin  // hit right border of brick  
					if (Yspeed > 0 ) //  while moving down
							Yspeed <= -Yspeed  ;  // negative move up    
				end	
		   
			
		if (startOfFrame == 1'b1 )
	
				  topLeftY_FixedPoint  <= topLeftY_FixedPoint + Yspeed;
			
					
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
