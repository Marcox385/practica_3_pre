/******************************************************************
* Description
*	This is the top-level of a RISC-V Microprocessor that can execute the next set of instructions:
*		add
*		addi
* This processor is written Verilog-HDL. It is synthesizabled into hardware.
* Parameter MEMORY_DEPTH configures the program memory to allocate the program to
* be executed. If the size of the program changes, thus, MEMORY_DEPTH must change.
* This processor was made for computer organization class at ITESO.
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

module RISC_V_Single_Cycle
#(
	parameter PROGRAM_MEMORY_DEPTH = 64,
	parameter DATA_MEMORY_DEPTH = 256,
	parameter DATA_MEMORY_WLEN = 32
)

(
	// Inputs
	input clk,
	input reset,

	output [31:0] alu_result_o
);
//******************************************************************/
//******************************************************************/

//******************************************************************/
//******************************************************************/
/* Signals to connect modules*/

/**Control**/
wire alu_src_w;
wire reg_write_w;
wire mem_to_reg_w;
wire mem_write_w;
wire mem_read_w;
wire [2:0] alu_op_w;
wire branch_read_w; 	// Para leer señal de salto

/** Program Counter**/
wire [31:0] pc_plus_4_w;
wire [31:0] pc_w;
wire [31:0] pc_plus_imm_w;
wire [31:0] mux_sum_alu_w;

/**DATA MEMORY**/
wire [31:0] data_mem_w;

/** Multiplexer MEM **/
wire [31:0] mux_mem_w;

/** Multiplexer MEM_PC4 **/
wire [31:0] mux_mem_or_pc4_w;

/**Register File**/
wire [31:0] read_data_1_w;
wire [31:0] read_data_2_w;

/**Inmmediate Unit**/
wire [31:0] immediate_data_w;

/**ALU**/
wire [31:0] alu_result_w;
wire alu_jalr_flag;
wire zero_flag_w;

/**Multiplexer MUX_DATA_OR_IMM_FOR_ALU**/
wire [31:0] read_data_2_or_imm_w;

/**ALU Control**/
wire [3:0] alu_operation_w;

/**Instruction Bus**/	
wire [31:0] instruction_bus_w;

/**AUX SIGNALS**/
wire and_branch;
wire [31:0] mux_imm_or_pc4_w;

//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Control
CONTROL_UNIT
(
	/****/
	.OP_i(instruction_bus_w[6:0]),
	/** outputs**/
	.Branch_o(branch_read_w),
	.ALU_Op_o(alu_op_w),
	.ALU_Src_o(alu_src_w),
	.Reg_Write_o(reg_write_w),
	.Mem_to_Reg_o(mem_to_reg_w),
	.Mem_Read_o(mem_read_w),
	.Mem_Write_o(mem_write_w)
);

PC_Register
PROGRAM_COUNTER
(
	.clk(clk),
	.reset(reset),
	.Next_PC(mux_sum_alu_w),
	
	.PC_Value(pc_w)
);

Data_Memory 
#(
	 .MEMORY_DEPTH(DATA_MEMORY_DEPTH),
    .DATA_WIDTH(DATA_MEMORY_WLEN)
)
DATA_MEMORY
(
    .clk(clk),
    .Mem_Write_i(mem_write_w),
    .Mem_Read_i(mem_read_w),
    .Write_Data_i(read_data_2_w),
    .Address_i(alu_result_w),

    .Read_Data_o(data_mem_w)
);

Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_MEM // Seleccionar entre dato de ALU o de memoria
(
	.Selector_i(mem_to_reg_w),
	.Mux_Data_0_i(alu_result_w),
	.Mux_Data_1_i(data_mem_w),

	.Mux_Output_o(mux_mem_w)
);

Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_MEM_4 // Seleccionar entre pc+4 o dato de mux anterior
(
	.Selector_i(alu_jalr_flag),
	.Mux_Data_0_i(mux_mem_w),
	.Mux_Data_1_i(pc_plus_4_w),
	
	.Mux_Output_o(mux_mem_or_pc4_w)
);


Program_Memory
#(
	.MEMORY_DEPTH(PROGRAM_MEMORY_DEPTH)
)
PROGRAM_MEMORY
(
	.Address_i(pc_w),
	.Instruction_o(instruction_bus_w)
);


Adder_32_Bits
PC_PLUS_4
(
	.Data0(pc_w),
	.Data1(4),
	
	.Result(pc_plus_4_w)
);

Adder_32_Bits
PC_PLUS_IMM
(
	.Data0(pc_w),
	.Data1(immediate_data_w),
	
	.Result(pc_plus_imm_w)
);

Aux_AND
BRANCH_AND
(
	.A_i(branch_read_w),
	.B_i(zero_flag_w),
	
	.result(and_branch)
);

Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_IMM_4 // Seleccionar entre inmediato o pc+4 (auxiliar para branch)
(
	.Selector_i(and_branch),
	.Mux_Data_0_i(pc_plus_4_w),
	.Mux_Data_1_i(pc_plus_imm_w),
	
	.Mux_Output_o(mux_imm_or_pc4_w)
);

Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_SUM_ALU // Seleccionar entre resultado mux anterior o resultado de alu (auxiliar para jalr)
(
	.Selector_i(alu_jalr_flag),
	.Mux_Data_0_i(mux_imm_or_pc4_w),
	.Mux_Data_1_i(alu_result_w),
	
	.Mux_Output_o(mux_sum_alu_w)
);


//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/


Register_File
REGISTER_FILE_UNIT
(
	.clk(clk),
	.reset(reset),
	.Reg_Write_i(reg_write_w),
	.Write_Register_i(instruction_bus_w[11:7]),
	.Read_Register_1_i(instruction_bus_w[19:15]),
	.Read_Register_2_i(instruction_bus_w[24:20]),
	.Write_Data_i(mux_mem_or_pc4_w), // Auxiliar para escritura de memoria
	.Read_Data_1_o(read_data_1_w),
	.Read_Data_2_o(read_data_2_w)

);


Immediate_Unit
IMM_UNIT
(  .op_i(instruction_bus_w[6:0]),
   .Instruction_bus_i(instruction_bus_w),
   .Immediate_o(immediate_data_w)
);


Multiplexer_2_to_1
#(
	.NBits(32)
)
MUX_DATA_OR_IMM_FOR_ALU
(
	.Selector_i(alu_src_w),
	.Mux_Data_0_i(read_data_2_w),
	.Mux_Data_1_i(immediate_data_w),
	
	.Mux_Output_o(read_data_2_or_imm_w)

);


ALU_Control
ALU_CONTROL_UNIT
(
	.funct7_i(instruction_bus_w[30]),
	.ALU_Op_i(alu_op_w),
	.funct3_i(instruction_bus_w[14:12]),
	.ALU_Operation_o(alu_operation_w)

);


ALU
ALU_UNIT
(
	.ALU_Operation_i(alu_operation_w),
	.A_i(read_data_1_w),
	.B_i(read_data_2_or_imm_w),
	.pc_plus_4(pc_plus_4_w),
	
	.Zero_o(zero_flag_w),
	.jalr_flag_o(alu_jalr_flag),
	.ALU_Result_o(alu_result_w)
);



assign alu_result_o = alu_result_w;

endmodule

