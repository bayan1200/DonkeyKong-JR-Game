// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021


module	smileyface_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	jump,  //change the direction in Y to up 
					input logic move_up,      //change the direction in Y to up
					input	logic	move_down,    //change the direction in Y to down 
					input	logic	move_left, 	  //change the direction in X to left 
					input	logic	move_right,   //change the direction in X to right
					input logic collision_with_boarders,  //collision if smiley hits an object
					input logic collision_with_rope,
					input logic collision_with_ground,
					input	logic	[3:0] HitEdgeCode, //one bit per edge 

					output	 logic signed 	[10:0]	topLeftX, // output the top left corner 
					output	 logic signed	[10:0]	topLeftY  // can be negative , if the object is partliy outside 
					
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 185;
parameter int INITIAL_X_SPEED = 40;
parameter int INITIAL_Y_SPEED = 60;
parameter int JUMP_SPEED = 90;


const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
const int	x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int	y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int	bracketOffset =	30;
const int   OBJECT_WIDTH_X = 64;

int Xspeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint;
int flag;


//////////--------------------------------------------------------------------------------------------------------------=
//  calculation 0f Y Axis speed using gravity or colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		Yspeed	<= INITIAL_Y_SPEED;
		topLeftY_FixedPoint	<= INITIAL_Y * FIXED_POINT_MULTIPLIER;
		flag <= 1'b0;
	end 
	else begin
	// colision Calcultaion 
			
		//hit bit map has one bit per edge:  Left-Top-Right-Bottom	 
		
		if (collision_with_boarders && HitEdgeCode [2] == 1) begin  
				Yspeed <= INITIAL_Y_SPEED;
				if (jump)
				Yspeed <= INITIAL_Y_SPEED;
			//if (Yspeed < 0 ) begin // while moving left
				//Yspeed <= 0 ; // positive move right 
			//end
		end
			
		if (collision_with_boarders && HitEdgeCode [0] == 1 ) begin  // hit bottom border of brick  
				if(jump)
					Yspeed <= -JUMP_SPEED;
				else 
					Yspeed <= 0 ;  // negative move left -disaper  

		end	
	
		//if (collision_with_rope)begin  // hit top border of brick  
				/*if (move_down)begin
					Yspeed <= INITIAL_Y_SPEED ;
				end	
				else if (Yspeed < 0) begin// while moving up
				/	Yspeed <= 0 ; 
					//end
			end
			//else begin
				if ((collision && HitEdgeCode [0] == 1 )) begin // hit bottom border of brick  
					/*if (move_up)begin
						Yspeed <= -INITIAL_Y_SPEED ;
					end	
					else if (Yspeed > 0)begin // while moving down
					/	Yspeed <= 0 ;
					//end 	
				end	
				if (!(collision && (HitEdgeCode [0] == 1 || HitEdgeCode [2] == 1 ))) begin
					if (move_down)
						Yspeed <= INITIAL_Y_SPEED ; 
					else
						Yspeed <= -INITIAL_Y_SPEED ; 
					//end
				end
		*/
			
		// perform  position and speed integral only 30 times per second 

		if (startOfFrame == 1'b1) begin 
		//if(jump)
				//topLeftY_FixedPoint <= topLeftY_FixedPoint - 2*Yspeed;
				//else
				topLeftY_FixedPoint <= topLeftY_FixedPoint + 2*Yspeed; // position interpolation 

			/*if(move_up)
				topLeftY_FixedPoint <= topLeftY_FixedPoint - Yspeed; // position interpolation 
			else if(move_down)
				topLeftY_FixedPoint <= topLeftY_FixedPoint + Yspeed;
			else*/ 
		end
	end
end 

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
	if (collision_with_boarders && HitEdgeCode [3] == 1) begin
			Xspeed <= 0;
	end
				
			
	if (collision_with_boarders && HitEdgeCode [1] == 1 ) begin  // hit right border of brick  
			Xspeed <= 0;	
	end	
		   
			
		if (startOfFrame == 1'b1 && Yspeed != 0) 
			 topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed;
		
		if (startOfFrame == 1'b1)
			if(move_left)
				 topLeftX_FixedPoint  <= topLeftX_FixedPoint - Xspeed;
			else if(move_right)
				 topLeftX_FixedPoint  <= topLeftX_FixedPoint + Xspeed;
			
					
	end
end

//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule
