
module	Hit(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	drawing_request_monkey,
			input	logic	drawing_request_boarders,	//boarders
			input	logic	drawing_request_ground,	//ground	
			input	logic	drawing_request_rope,	//rope
			input	logic	drawing_request_fruit1,	//fruit
			input	logic	drawing_request_fruit2,	//fruit
			input	logic	drawing_request_fruit3,	//fruit
			input	logic	drawing_request_fruit4,	//fruit
			input	logic	drawing_request_fruit5,	//fruit
			input	logic	drawing_request_fruit6,	//fruit
			input	logic	drawing_request_fruit7,	//fruit
			input	logic	drawing_request_fruit8,	//fruit
			input	logic	drawing_request_fruit9,	//fruit
			input	logic	drawing_request_fruit10,	//fruit
			input	logic	drawing_request_monster,	//monsters
			input	logic	drawing_request_key,	//key

			output logic monkey_boarders_coll, // active in case of collision between two objects
			output logic monkey_ground_coll,
			output logic monkey_rope_coll,
			output logic monkey_fruit1_coll,
			output logic monkey_fruit2_coll,
			output logic monkey_fruit3_coll,
			output logic monkey_fruit4_coll,
			output logic monkey_fruit5_coll,
			output logic monkey_fruit6_coll,
			output logic monkey_fruit7_coll,
			output logic monkey_fruit8_coll,
			output logic monkey_fruit9_coll,
			output logic monkey_fruit10_coll,
			output logic monkey_monster_coll,
			output logic monkey_key_coll
);
 
 

assign monkey_boarders_coll = (drawing_request_monkey &&  drawing_request_boarders); 
assign monkey_ground_coll = (drawing_request_monkey &&  drawing_request_ground );
assign monkey_rope_coll = (drawing_request_monkey &&  drawing_request_rope );
assign monkey_fruit1_coll = (drawing_request_monkey &&  drawing_request_fruit1 );
assign monkey_fruit2_coll = (drawing_request_monkey &&  drawing_request_fruit2 );
assign monkey_fruit3_coll = (drawing_request_monkey &&  drawing_request_fruit3 );
assign monkey_fruit4_coll = (drawing_request_monkey &&  drawing_request_fruit4 );
assign monkey_fruit5_coll = (drawing_request_monkey &&  drawing_request_fruit5 );
assign monkey_fruit6_coll = (drawing_request_monkey &&  drawing_request_fruit6 );
assign monkey_fruit7_coll = (drawing_request_monkey &&  drawing_request_fruit7 );
assign monkey_fruit8_coll = (drawing_request_monkey &&  drawing_request_fruit8 );
assign monkey_fruit9_coll = (drawing_request_monkey &&  drawing_request_fruit9 );
assign monkey_fruit10_coll = (drawing_request_monkey &&  drawing_request_fruit10 );
assign monkey_monster_coll = (drawing_request_monkey &&  drawing_request_monster );
assign monkey_key_coll = (drawing_request_monkey &&  drawing_request_key );


endmodule 