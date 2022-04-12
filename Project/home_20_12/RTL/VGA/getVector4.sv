
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	getVector10	(	
//		--------	Clock Input	 	
					input		logic	clk,
					input		logic	resetN,

					input		logic	[3:0] input1,		
					input		logic [5:0] input2,
		
					output	logic	[9:0] outputVec
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			outputVec <= 10'b0;
	end
	
	else begin
		
		outputVec[0] = input1[0];
		outputVec[1] = input1[1];
		outputVec[2] = input1[2];
		outputVec[3] = input1[3];
		outputVec[4] = input2[0];
		outputVec[5] = input2[1];
		outputVec[6] = input2[2];
		outputVec[7] = input2[3];
		outputVec[8] = input2[4];
		outputVec[9] = input2[5];

		
	end ; 
end

endmodule


