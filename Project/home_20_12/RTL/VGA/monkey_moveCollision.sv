module	monkey_moveCollision	(	
 
					input	logic	clk,
					input	logic	resetN,
					input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
					input	logic	jump,  //change the direction in Y to up 
					input logic move_up,      //change the direction in Y to up
					input	logic	move_down,    //change the direction in Y to down 
					input	logic	move_left, 	  //change the direction in X to left 
					input	logic	move_right,   //change the direction in X to right
					input logic collision_with_rope,
					input logic collision_with_ground,
					input	logic	[3:0] HitEdgeCode, //one bit per edge 

					output logic signed 	[10:0]	topLeftX, // output the top left corner 
					output logic signed	[10:0]	topLeftY  // can be negative , if the object is partliy outside 
);

parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 185;
parameter int INITIAL_X_SPEED = 30;
parameter int INITIAL_Y_SPEED = 30;
parameter int JUMP_SPEED = 90;
const int FREE_FALL = 90;

const int	FIXED_POINT_MULTIPLIER	=	64;

int Xspeed, topLeftX_FixedPoint; // local parameters 
int Yspeed, topLeftY_FixedPoint;
logic flagX, flagY, ON_rope , free_fall;
logic flag , jump_flag, ON_ground;

//////////--------------------------------------------------------------------------------------------------------------=
//  calculation 0f Y Axis speed using gravity or colision
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		Yspeed <= 0;
		topLeftY_FixedPoint <= INITIAL_Y * FIXED_POINT_MULTIPLIER;
		flagY <= 1'b0;
		ON_rope <= 1'b0;
		free_fall<=1'b0;
		flag <= 1'b1;
		jump_flag <= 1'b0;
		ON_ground <= 1'b0;
	end 
	else begin
	
	
		if(collision_with_ground && HitEdgeCode[0] && !HitEdgeCode[1] && !HitEdgeCode[3]) begin
			ON_ground <=1;
			flag<=1;
			if (jump && !move_up && !move_down)begin 
				Yspeed <= 3*INITIAL_Y_SPEED;
			end
			else
				Yspeed <= 0;
		end
		
		
		
		else if(collision_with_rope && (HitEdgeCode[0] || HitEdgeCode[2] || HitEdgeCode[1] || HitEdgeCode[3] ))begin
			Yspeed <= INITIAL_Y_SPEED;
			ON_rope <= 1'b1;
			flagY <= 1'b0;
		end
		

		
		else if(collision_with_ground && HitEdgeCode[2] && !HitEdgeCode[1] && !HitEdgeCode[3]) begin
			topLeftY_FixedPoint <= topLeftY_FixedPoint + 3*INITIAL_Y_SPEED;
			if(ON_rope) begin
				flag<=0;
				Yspeed <= INITIAL_Y_SPEED;
			end
			else if (flag)begin 
				Yspeed <= INITIAL_Y_SPEED;
			end
			else begin
				Yspeed <= 0;
				flagY <= 1'b1;
			end
			
		end
		
		
		
		else begin 
			free_fall<=1;
		end
	
		
		if (startOfFrame == 1'b1) begin
			if(move_up && !flagY && !jump)
				topLeftY_FixedPoint <= topLeftY_FixedPoint - Yspeed;
			else if(move_down && !jump)
				topLeftY_FixedPoint <= topLeftY_FixedPoint + Yspeed;
			else if(jump)begin 
				topLeftY_FixedPoint <= topLeftY_FixedPoint - 3*Yspeed;
			end
			else if(free_fall)
				topLeftY_FixedPoint <= topLeftY_FixedPoint + 3*Yspeed ;
			else
				topLeftY_FixedPoint <= topLeftY_FixedPoint ;
				
			
		end
		
		
		
	end
end 


//////////--------------------------------------------------------------------------------------------------------------=
//  calculation of X Axis speed using and position calculate regarding X_direction key or colision

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		Xspeed <= 0;
		topLeftX_FixedPoint <= INITIAL_X * FIXED_POINT_MULTIPLIER;
		flagX <= 1'b0;
	end 
	else begin
		
		if ((topLeftX_FixedPoint<=36* FIXED_POINT_MULTIPLIER) || (topLeftX_FixedPoint>=540* FIXED_POINT_MULTIPLIER))begin
			if (move_left && HitEdgeCode[0] && collision_with_ground && (topLeftX_FixedPoint>=540* FIXED_POINT_MULTIPLIER))begin
				Xspeed<= INITIAL_X_SPEED;
				topLeftX_FixedPoint <= topLeftX_FixedPoint - Xspeed;
			end
			else if (move_right && HitEdgeCode[0] && collision_with_ground && (topLeftX_FixedPoint<=36* FIXED_POINT_MULTIPLIER))begin
				Xspeed<= INITIAL_X_SPEED;
				topLeftX_FixedPoint <= topLeftX_FixedPoint + Xspeed;
			end
			else begin
				Xspeed<=0;
				topLeftX_FixedPoint <= topLeftX_FixedPoint + Xspeed;
			end
			
		end
		
		else begin 
		if(collision_with_ground && HitEdgeCode[0] && !HitEdgeCode[1] && !HitEdgeCode[3]) begin
			if (jump)begin
				Xspeed<=3*INITIAL_X_SPEED;
			end
			else
				Xspeed <= INITIAL_X_SPEED;
		end
		
		if(collision_with_ground && HitEdgeCode[2] && !HitEdgeCode[1] && !HitEdgeCode[3]) begin
			Xspeed <= 0;
		end
		
		if(collision_with_rope && (HitEdgeCode[0] || HitEdgeCode[2]) && (HitEdgeCode[1] || HitEdgeCode[3])) begin
			if (jump)begin 
				Xspeed<=3*INITIAL_X_SPEED;
			end
			else
				Xspeed <= 0;
		end
		
		if(collision_with_ground && collision_with_rope && HitEdgeCode[2] && !HitEdgeCode[1] && !HitEdgeCode[3]) begin
			Xspeed <= 0;
			flagX <= 1'b1;
		end
		
		if (startOfFrame == 1'b1) begin
			if(move_left)
				topLeftX_FixedPoint <= topLeftX_FixedPoint - Xspeed;
			else if( move_right)
				topLeftX_FixedPoint <= topLeftX_FixedPoint + Xspeed;
			else
				topLeftX_FixedPoint <= topLeftX_FixedPoint ;

		end
		
		end
		
		
	end
end



//get a better (64 times) resolution using integer   
assign 	topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    

endmodule