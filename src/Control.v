/******************************************************************
* Description
*	This is control unit for the RISC-V Microprocessor. The control unit is 
*	in charge of generation of the control signals. Its only input 
*	corresponds to opcode from the instruction bus.
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

module Control
(
	input [6:0]OP_i,
	
	
	output Branch_o,
	output Mem_Read_o,
	output Mem_to_Reg_o,
	output Mem_Write_o,
	output ALU_Src_o,
	output Reg_Write_o,
	output [2:0]ALU_Op_o
);

localparam R_Type				= 7'h33;	// ADD, AND, OR, SLL, SRL, SUB, XOR
localparam I_Type_JUMP		= 7'h67;	// JALR
localparam I_Type_LOADING	= 7'h03; // LW
localparam I_Type_LOGIC		= 7'h13; // ADDI, ANDI, ORI, SLLI, SRLI, XORI
localparam S_Type				= 7'h23; // SW
localparam B_Type				= 7'h63; // BEQ, BNE, BLT, BGE
localparam U_Type				= 7'h37; // LUI
localparam J_Type 			= 7'h6f; // JAL

reg [8:0] control_values;

always@(OP_i) begin
	case(OP_i)//                           876_54_3_210
		R_Type: 			 control_values = 9'b001_00_0_000;
		I_Type_JUMP:	 control_values = 9'b101_00_1_011;
		I_Type_LOADING: control_values = 9'b011_10_1_010;
		I_Type_LOGIC:	 control_values = 9'b001_00_1_001;
		S_Type:			 control_values = 9'b000_01_1_100;
		B_Type:			 control_values = 9'b100_00_0_101;
		U_Type:			 control_values = 9'b001_00_1_010;
		J_Type:			 control_values = 9'b101_00_1_110;
		
		default:
			control_values= 9'b000_00_000;
		endcase
end	

assign Branch_o = control_values[8];

assign Mem_to_Reg_o = control_values[7];

assign Reg_Write_o = control_values[6];

assign Mem_Read_o = control_values[5];

assign Mem_Write_o = control_values[4];

assign ALU_Src_o = control_values[3];

assign ALU_Op_o = control_values[2:0];	

endmodule


