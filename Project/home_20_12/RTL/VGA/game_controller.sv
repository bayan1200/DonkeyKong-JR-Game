
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 						
			input logic enterIsPressed, 
			input logic timer_end,
			input logic [1:0] livesCounter, 
			input logic [3:0] scoreCounter,
			input logic [3:0] fruitsCounter,
			input logic key_collision,
	
			output logic startGameEnable, 
			output logic GameOverEnable,
			output logic winGameEnable,
			output logic game_on,
			output logic got_key,
			output logic SingleHitPulse // critical code, generating A single pulse in a frame 
);


	// state machine decleration 
enum logic [3:0] {Sidle, Sstart, SgotKey, SgameOver, SwinGame } pres_st, next_st;
	
always_ff @(posedge clk or negedge resetN)
begin

   if (!resetN ) begin // Asynchronic reset
		pres_st <= Sidle; 
	end	
	else begin	// Synchronic logic FSM
		pres_st <= next_st;                  
					
	end // always sync
	end
	
	
always_comb // Update next state and outputs
begin
	// set all default values 
		next_st = pres_st; 
		startGameEnable = 1'b0;
		GameOverEnable = 1'b0;
		winGameEnable = 1'b0;
		game_on = 1'b0;
		got_key = 1'b0;

				
		case (pres_st)
				
			Sidle: begin
				startGameEnable = 1'b1;
				if (enterIsPressed == 1'b1) 
					next_st = Sstart; 
				end // idle
						
			Sstart: begin
				game_on = 1'b1;
				if (livesCounter == 2'b11 || timer_end || (scoreCounter < 4'b1100 && fruitsCounter == 4'b1010)) // when player collide with monsters or gets hurt by 3 monsters missles 
					next_st = SgameOver;
				if(key_collision) 
					next_st = SgotKey;
			end
				
			SgotKey: begin
				got_key = 1'b1;
				game_on = 1'b1;
				if(scoreCounter >= 4'b1100)
					next_st = SwinGame;
				else if (livesCounter == 2'b11 || timer_end || (scoreCounter < 4'b1100 && fruitsCounter == 4'b1010)) // when player collide with monsters or gets hurt by 3 monsters missles 
					next_st = SgameOver;
				end
						
			SgameOver: begin          
				GameOverEnable = 1'b1;
				/*if (enterIsPressed == 1'b1) 
					next_st = Sidle; */
			end 
				
			SwinGame: begin				
				winGameEnable=1'b1;
			end	
		endcase
end // always comb	
 

					
/*						
logic flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		SingleHitPulse <= 1'b0 ; 
	end 
	else begin 

			SingleHitPulse <= 1'b0 ; // default 
			if(startOfFrame) 
				flag = 1'b0 ; // reset for next time  

				
//		change the section below  to collision between number and smiley


if ( ( drawing_request_Ball &&  drawing_request_2 )  && (flag == 1'b0)) begin 
			flag	<= 1'b1; // to enter only once 
			SingleHitPulse <= 1'b1 ; 
		end ; 
	end 
end
*/
endmodule


