

//return a constant number according to the parameter from outside
module constNumber(
	output logic [10:0]number
);

parameter logic [10:0] number_value = 0; 

assign number = number_value;
	
endmodule 