

module livesScoresCounter_Block ( 
		input	logic  clk,
		input	logic  resetN, 
		input logic	 startOfFrame,
		input logic  collision_with_monster,
		input logic  coll_fruit1,
		input logic  coll_fruit2,
		input logic  coll_fruit3,
		input logic  coll_fruit4,
		input logic  coll_fruit5,
		input logic  coll_fruit6,
		input logic  coll_fruit7,
		input logic  coll_fruit8,
		input logic  coll_fruit9,
		input logic  coll_fruit10,


		output logic unsigned [1:0] current_lives,
		output logic unsigned [3:0] score_L,
		output logic unsigned [3:0] score_H,
		output logic unsigned [3:0] score,
		output logic unsigned [3:0] fruit_cntr
);

// Generating a random number by latching a fast Counter with the rising edge of an input ( e.g. key pressed )
  
parameter unsigned  MIN_VAL = 0;  //set the min and max values 
parameter unsigned  MAX_VAL = 3;

logic [1:0] counter;
logic [3:0] score_cntL;
logic [3:0] score_cntH;
logic [3:0] score_cnt;
logic [3:0] cntr;
logic flag_lives, flag_hit_fruits;

always_ff @(posedge clk or negedge resetN) begin
	if (!resetN) begin
		counter <= MIN_VAL;
		score_cnt <= 4'b0;
		flag_lives <= 1'b1;
		flag_hit_fruits <= 1'b1;
		cntr <= 4'b0;
	end
		
	else begin
		if (collision_with_monster) begin
				if (counter == MAX_VAL) 
					counter <= MIN_VAL;
				flag_lives <= 0;	
				if (flag_lives) begin
					counter <= counter + 1;
					if(score_cnt < 5)
						score_cnt <= 4'b0;
					else
						score_cnt <= score_cnt - 5;
				end
		end
		
		if(coll_fruit1 || coll_fruit2 || coll_fruit3 || coll_fruit4 || coll_fruit5 ||
			coll_fruit6 ||	coll_fruit7 || coll_fruit8 || coll_fruit9 ||	coll_fruit10) begin		
					flag_hit_fruits <= 0;
					if (flag_hit_fruits) begin
						score_cnt <= score_cnt + 2;
						cntr <= cntr + 1;
					end
		end
		
		if (startOfFrame) begin
				flag_lives <= 1'b1;	
				flag_hit_fruits <= 1'b1;
		end
	end
end

assign current_lives = counter;
assign score_L = score_cnt % 10;
assign score_H = score_cnt / 10;
assign score = score_cnt;
assign fruit_cntr = cntr;

endmodule

