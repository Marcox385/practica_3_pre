/******************************************************************
* Description
*	This is an 32-bit arithetic logic unit that can execute the next set of operations:
*		add

* This ALU is written by using behavioral description.
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

module ALU 
(
	input [3:0] ALU_Operation_i,
	input signed [31:0] A_i,
	input signed [31:0] B_i,
	input [31:0] pc_plus_4,
	
	output reg Zero_o,
	output reg jalr_flag_o,
	output reg [31:0] ALU_Result_o
);

localparam ADD		= 4'b0000;	// Cubre ADDI, LW y SW también
localparam AND 	= 4'b0110;  // Cubre ANDI también
localparam BEQ		= 4'b1010;	// Complementario con módulos para señales estilo JAL (resultados de un bit)
localparam BGE 	= 4'b1101; 
localparam BLT		= 4'b1100;
localparam BNE		= 4'b1011;
localparam JAL 	= 4'b1110;
localparam JALR	= 4'b1111;
localparam LUI		= 4'b0001;
localparam OR		= 4'b0010;	// Cubre ORI también
localparam SLL 	= 4'b1001;
localparam SLLI	= 4'b0011;
localparam SRL 	= 4'b1000;
localparam SRLI 	= 4'b0100;
localparam SUB		= 4'b0101;
localparam XOR		= 4'b0111;	// Cubre XORI también
   
always @ (A_i or B_i or ALU_Operation_i)
	begin
		case (ALU_Operation_i)
			ADD:
				ALU_Result_o = A_i + B_i;
			AND: 
				ALU_Result_o = A_i & B_i;
			BEQ:	//	if(rs1 == rs2) PC += imm
				ALU_Result_o = (A_i == B_i) ? 1'b1 : 1'b0;
			BGE:  // if(rs1 >= rs2) PC += imm
				ALU_Result_o = (A_i >= B_i) ? 1'b1 : 1'b0;
			BLT:	// if(rs1 < rs2) PC += imm
				ALU_Result_o = (A_i < B_i) ? 1'b1 : 1'b0;
			BNE:	//	if(rs1 != rs2) PC += imm
				ALU_Result_o = (A_i != B_i) ? 1'b1 : 1'b0;
			JAL:
				ALU_Result_o = pc_plus_4;
			JALR:
				ALU_Result_o = A_i + B_i;
			LUI:
				ALU_Result_o = {B_i[19:0],12'b0};
			OR:
				ALU_Result_o = A_i | B_i;
			SLL:
				ALU_Result_o = A_i << B_i[30:0];
			SLLI:
				ALU_Result_o = A_i << B_i[4:0];
			SRL:
				ALU_Result_o = A_i >> B_i[30:0];
			SRLI:
				ALU_Result_o = A_i >> B_i[4:0];
			SUB:
				ALU_Result_o = A_i - B_i;
			XOR:
				ALU_Result_o = A_i ^ B_i;
			default:
				ALU_Result_o = 0;
		endcase // case(control)
		
		jalr_flag_o = (ALU_Operation_i == JALR) ? 1'b1 : 1'b0;

		Zero_o = (ALU_Result_o == 0) ? 1'b1 : 1'b0;
	end // always @ (A or B or control)
endmodule // ALU
