// (c) Technion IIT, Department of Electrical Engineering 2018 
// 
// Implements the state machine of the bomb mini-project
// FSM, with present and next states

module bomb
	(
	input logic clk, 
	input logic resetN, 
	input logic start, 
	input logic waitN, 
	input logic OneSecPulse, 
	input logic timerEnd,
	input logic duty50,
	output logic countLoadN, 
	output logic countEnable, 
	output logic lampEnable,
	output logic lampTest
   );

//-------------------------------------------------------------------------------------------

// state machine decleration 
	enum logic [2:0] {Sidle, Sarm, Srun, Spause, SlampOff, SlampOn, Slatency } pres_st, next_st;
 	
//--------------------------------------------------------------------------------------------
//  1.  syncronous code:  executed once every clock to update the current state 
always @(posedge clk or negedge resetN)
   begin
	   
   if ( !resetN )  // Asynchronic reset
		pres_st <= Sidle;
   
	else 		// Synchronic logic FSM
		pres_st <= next_st;
		
	end // always sync
	
//--------------------------------------------------------------------------------------------
//  2.  asynchornous code: logically defining what is the next state, and the ouptput 
//      							(not seperating to two different always sections)  	
always_comb // Update next state and outputs
	begin
	// set all default values 
		next_st = pres_st; 
		countEnable = 1'b0;
		countLoadN = 1'b1;
		lampEnable = 1'b1;
		lampTest = 1'b0;
			
		case (pres_st)
				
			Sidle: begin
				lampEnable = 1'b0;
				if (start == 1'b0) 
					next_st = Sarm; 
				end // idle
						
			Sarm: begin
				countLoadN = 1'b0;
				lampEnable = 1'b0;
				if(start == 1'b1)
					next_st = Srun;
				end // arm
						
			Srun: begin
				countEnable = 1'b1;
				if(timerEnd == 1'b1)
					next_st = SlampOn;
				else if(waitN == 1'b0)
					//next_st = Spause;  #time:11:51 date:11/11/2021 why: התפוצצות אחרי לחיצה על wait 
					next_st = Spause;
				end // run
					
			Spause: begin
				if(waitN == 1'b1 && OneSecPulse == 1'b1)
					//next_st = srun ; #time 12:10 11/11/2021
					next_st = Slatency;				
				end // pause
				
			Slatency: begin
				if(waitN == 1'b0)
					next_st = Spause;	
				else if(waitN == 1'b1 && OneSecPulse == 1'b1)
					next_st = Srun;	
				end // latency
						
			SlampOff: begin
				lampEnable = 1'b0;
				if(duty50 == 1'b1)
					next_st = SlampOn;						
				end // lampOff
				
			SlampOn: begin
				lampTest = 1'b1;
				if(duty50 == 1'b0)
					next_st = SlampOff;							
				end // lampOn
						
						
		endcase
	end // always comb
	
endmodule
