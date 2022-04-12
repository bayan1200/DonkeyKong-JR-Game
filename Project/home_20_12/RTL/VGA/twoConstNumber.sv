

//return a constant number according to the parameter from outside
module twoConstNumber(
	output logic [10:0] number1,
	output logic [10:0] number2
);

parameter logic [10:0] number_value1 = 0; 
parameter logic [10:0] number_value2 = 0; 


assign number1 = number_value1;
assign number2 = number_value2;

	
endmodule 