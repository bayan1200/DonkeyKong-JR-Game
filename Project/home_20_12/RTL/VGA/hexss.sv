// (c) Technion IIT, Department of Electrical Engineering 2018 

// Implements the hexadecimal to 7Segment conversion unit
// by using a two-dimensional array

module hexss 
	(
	input logic [3:0] hexin, // Data input: hex numbers 0 to f
	input logic darkN, 
	input logic LampTest, 	// Aditional inputs
	output logic [6:0] ss 	// Output for 7Seg display
	);

// Declaration of two-dimensional array that holds the 7seg codes

		logic [0:15] [6:0] SevenSeg =	
				{	7'h40, //0
					7'h79, //1
					7'h24, //2
					7'h30, //3
					7'h19, //4
					7'h12, //5
					7'h2, //6
					7'h78, //7
					7'h0, //8
					7'h10, //9
					7'h8, //10
					7'h3, //11
					7'h46, //12
					7'h21, //13
					7'h6, //14
					7'hE //15
				};

	always_comb
	begin
		
		if( !darkN ) begin
			ss = 7'b1111111;
		end
		
		else if( LampTest == 1'b1 ) begin
			ss = 7'b0;
		end
		
		else begin
			ss = SevenSeg[hexin][6:0];
		end
		
	end

endmodule


