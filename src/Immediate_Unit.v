/******************************************************************
* Description
*	This module performs a sign extension operation that is need with
*	in instruction like andi and constructs the immediate constant.
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

module Immediate_Unit
(   
	input [6:0] op_i,
	input [31:0]  Instruction_bus_i,
	
   output reg [31:0] Immediate_o
);

localparam R_Type				= 7'h33;
localparam I_Type_JUMP		= 7'h67;
localparam I_Type_LOADING	= 7'h03; 
localparam I_Type_LOGIC		= 7'h13;
localparam S_Type				= 7'h23;
localparam B_Type				= 7'h63;
localparam U_Type				= 7'h37;
localparam J_Type 			= 7'h6f;

always@(op_i or Instruction_bus_i) begin
	case (op_i)
		I_Type_JUMP, I_Type_LOGIC, I_Type_LOADING: // Tipo I_JP -> b1100111, Tipo I_LG -> b0110011, I_LD -> b0000011
				Immediate_o = {{20{Instruction_bus_i[31]}},Instruction_bus_i[31:20]};
		S_Type: // Tipo S -> b0100011
				Immediate_o = {{20{Instruction_bus_i[31]}},Instruction_bus_i[31:25],Instruction_bus_i[11:7]};
		B_Type: // Tipo B - b1100011
				Immediate_o = {{19{Instruction_bus_i[31]}},Instruction_bus_i[31],Instruction_bus_i[7],Instruction_bus_i[30:25],Instruction_bus_i[11:8],1'b0};
		U_Type: // Tipo U -> b0110111
				Immediate_o = {{12{Instruction_bus_i[31]}},Instruction_bus_i[31:12]};
		J_Type: // Tipo J - b1101111
				Immediate_o = {{11{Instruction_bus_i[31]}},Instruction_bus_i[31],Instruction_bus_i[19:12],Instruction_bus_i[20],Instruction_bus_i[30:21],1'b0};

		
		default: // Tipo R - b0110011
				Immediate_o = 0;
	endcase
end


endmodule // signExtend
