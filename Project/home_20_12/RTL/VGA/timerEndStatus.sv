

module timerEndStatus(
	input  logic clk, 
	input  logic resetN, 
	input  logic tc, 
	
	output logic timerStatus
   );

logic flag ; // a semaphore to set the output only once each time the count has ended 


always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin 
		flag <= 1'b0;
		timerStatus <= 1'b0 ; 
	end 
	
	else begin
		timerStatus <= 1'b0 ; // default 
		if (!tc) 
			flag = 1'b0 ; // reset for next time 
		else if (tc && (flag == 1'b0)) begin 
			flag <= 1'b1; // to enter only once 
			timerStatus <= 1'b1 ; 
		end 		
	end
end

endmodule