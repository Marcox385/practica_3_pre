/******************************************************************
* Description
*	This is the control unit for the ALU. It receves a signal called 
*	ALUOp from the control unit and signals called funct7 and funct3  from
*	the instruction bus.
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

module ALU_Control
(
	input funct7_i, 
	input [2:0] ALU_Op_i,
	input [2:0] funct3_i,
	

	output [3:0] ALU_Operation_o
);


localparam R_Type_ADD 		= 7'b0_000_000; // Funct7: 0, Control: R_Type[2:0], 	 Funct3: 0 
localparam I_Type_ADDI 		= 7'bx_001_000; // Funct7: -, Control: I_LG_Type[2:0], Funct3: 0
localparam R_Type_AND 		= 7'b0_000_111; // Funct7: 0, Control: R_Type[2:0], 	 Funct3: 7
localparam I_Type_ANDI 		= 7'bx_001_111; // Funct7: -, Control: I_LG_Type[2:0], Funct3: 7
localparam B_Type_BEQ		= 7'bx_101_000; // Funct7: -, Control: B_Type[2:0], 	 Funct3: 0
localparam B_Type_BGE		= 7'bx_101_101; // Funct7: -, Control: B_Type[2:0], 	 Funct3: 5
localparam B_Type_BLT		= 7'bx_101_100; // Funct7: -, Control: B_Type[2:0], 	 Funct3: 4
localparam B_Type_BNE		= 7'bx_101_001; // Funct7: -, Control: B_Type[2:0], 	 Funct3: 1
localparam J_Type_JAL 		= 7'bx_110_xxx; // Funct7: -, Control: J_Type[2:0], 	 Funct3: -
localparam I_Type_JALR 		= 7'bx_011_000; // Funct7: -, Control: I_JP_Type[2:0], Funct3: 0
localparam U_Type_LUI		= 7'bx_111_xxx; // Funct7: -, Control: U_Type[2:0], 	 Funct3: -
localparam I_Type_LW			= 7'bx_010_010; // Funct7: -, Control: I_LD_Type[2:0], Funct3: 2
localparam R_Type_OR			= 7'b0_000_110; // Funct7: 0, Control: R_Type[2:0], 	 Funct3: 6 
localparam I_Type_ORI		= 7'bx_001_110; // Funct7: -, Control: I_LG_Type[2:0], Funct3: 6
localparam R_Type_SLL		= 7'b0_000_001; // Funct7: 0, Control: R_Type[2:0], 	 Funct3: 1
localparam I_Type_SLLI		= 7'b0_001_001; // Funct7: 0, Control: I_LG_Type[2:0], Funct3: 1
localparam R_Type_SRL		= 7'b0_000_101; // Funct7: 0, Control: R_Type[2:0], 	 Funct3: 5
localparam I_Type_SRLI		= 7'b0_001_101; // Funct7: 0, Control: I_LG_Type[2:0], Funct3: 5
localparam R_Type_SUB		= 7'b1_000_000; // Funct7: 2, Control: R_Type[2:0], 	 Funct3: 0
localparam S_Type_SW			= 7'bx_100_010; // Funct7: -, Control: S_Type[2:0], 	 Funct3: 2
localparam R_Type_XOR		= 7'b0_000_100; // Funct7: 0, Control: R_Type[2:0], 	 Funct3: 4 
localparam I_Type_XORI		= 7'bx_001_100; // Funct7: -, Control: I_LG_Type[2:0], Funct3: 4 

reg [3:0] alu_control_values;
wire [6:0] selector;

assign selector = {funct7_i, ALU_Op_i, funct3_i};

/* Instrucciones a implementar
		add, addi, lw, sw				0 - 4'b0000
		sub								5 - 4'b0101
		and, andi						6 - 4'b0110
		or, ori							2 - 4'b0010
		xor, xori						7 - 4'b0111
		lui								1 - 4'b0001
		srl								8 - 4'b1000
		srli								4 - 4'b0100
		sll								9 - 4'b1001
		slli								3 - 4'b0011
		beq					  		  10 - 4'b1010
		bne					  		  11 - 4'b1011
		blt					  		  12 - 4'b1100
		bge					  		  13 - 4'b1101
		jal					  		  14 - 4'b1110
		jalr							  15 - 4'b1111
*/

always@(selector)begin
	casex(selector)
		R_Type_ADD:			alu_control_values	=	4'b0000;
		I_Type_ADDI:		alu_control_values	=	4'b0000;
		R_Type_AND: 		alu_control_values 	=	4'b0110;
		I_Type_ANDI: 		alu_control_values 	=	4'b0110;
		B_Type_BEQ:			alu_control_values 	=	4'b1010;
		B_Type_BGE: 		alu_control_values 	= 	4'b1101;
		B_Type_BLT:			alu_control_values 	=	4'b1100;
		B_Type_BNE:			alu_control_values	=	4'b1011;
		J_Type_JAL: 		alu_control_values	=	4'b1110;
		I_Type_JALR: 		alu_control_values	=	4'b1111;
		U_Type_LUI:			alu_control_values	=	4'b0001;
		I_Type_LW:			alu_control_values	=	4'b0000;
		R_Type_OR:			alu_control_values	=	4'b0010;
		I_Type_ORI:			alu_control_values	=	4'b0010;
		R_Type_SLL: 		alu_control_values	=	4'b1001;
		I_Type_SLLI:		alu_control_values	=	4'b0011;
		R_Type_SRL: 		alu_control_values	=	4'b1000;
		I_Type_SRLI:		alu_control_values	=	4'b0100;
		R_Type_SUB:			alu_control_values	=	4'b0101;
		S_Type_SW:			alu_control_values	=	4'b0000;
		R_Type_XOR:			alu_control_values	=	4'b0111;
		I_Type_XORI:		alu_control_values	=	4'b0111;

		default: alu_control_values = 4'b00_00;
	endcase
end


assign ALU_Operation_o = alu_control_values;



endmodule
