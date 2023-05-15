/******************************************************************
* Description
*	Auxiliary AND module for Type B instructions and JAL(R);
*	Additional auxiliary module for program counter
*	1.0
* Author(s):
*	IS727550 - Diaz Aguayo; IS727272 - Cordero Hernandez
******************************************************************/

module Aux_AND
(
	input A_i,
	input B_i,
	
	output reg result
);

always @ (A_i or B_i or result) 
	begin
		result = (A_i && B_i) ? 1'b1 : 1'b0;
	end
	
endmodule