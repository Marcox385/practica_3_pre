/******************************************************************
* Description
*	This is the verifaction envioroment for testeting the basic RISC-V
*	Microprocesor.
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

`timescale 1ps/1ps
module RISC_V_Single_Cycle_TB;
reg clk_tb = 0;
reg reset_tb = 0;  
  
  
RISC_V_Single_Cycle
DUV
(
	.clk(clk_tb),
	.reset(reset_tb)

);
/*********************************************************/
initial // Clock generator
  begin
    forever #2 clk_tb = !clk_tb;
  end
/*********************************************************/
initial begin // reset generator
	#5 reset_tb = 1;
end


/*********************************************************/

endmodule