/******************************************************************
* Description
*	This is a register of 32-bit that corresponds to the PC counter. 
*	This register does not have an enable signal.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	16/08/2021
*
* Modified by:
*	IS727550 - Diaz Aguayo; IS727272 - Cordero Hernandez
******************************************************************/

module PC_Register
#(
	parameter N=32
)
(
	input clk,
	input reset,
	input  [N-1:0] Next_PC,
	
	
	output reg [N-1:0] PC_Value
);

localparam PC = 32'h003fc000;

always@(negedge reset or posedge clk) begin
	if(reset==0)
		PC_Value <= PC;
	else	
		PC_Value<= Next_PC;
end

endmodule
