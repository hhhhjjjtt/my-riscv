`define InstAddrBus         31:0
`define InstDataBus         31:0

// reset
`define ResetEnable         1'b1
`define ResetDisable        1'b0

// ce
`define ChipEnable          1'b1
`define ChipDisable         1'b0

// we
`define WriteEnable         1'b1
`define WriteDisable        1'b0

// jump
`define JumpEnable          1'b1
`define JumpDisable         1'b0

// hold
`define NOP                 32'h00000013
`define HoldEnable          1'b1
`define HoldDisable         1'b0

`define HoldTypeBus         1:0
`define hold_type_none      2'b00
`define hold_type_branch    2'b01
`define hold_type_load      2'b10

`define HoldFlagBus         2:0
`define hold_flag_none      3'b000
`define hold_flag_branch    3'b011
`define hold_flag_load      3'b111
`define hold_pc_index       2'b10
`define hold_if_id_index    2'b01
`define hold_id_ex_index    2'b00

// regs
`define RegsAddrBus         4:0
`define RegsDataBus         31:0
`define RegsNum             32

`define Reg0Addr            5'b0
`define ZeroWord            32'b0
`define ZeroHalf            16'b0

// inst_rom 
`define ROMAddrBus          31:0
`define ROMDataBus          31:0
`define ROMNum              4096

// data_ram 
`define RAMAddrBus          31:0
`define RAMDataBus          31:0
`define RAMNum              4096

// id
`define ImmDataBus          31:0

// ----Integer Operation----
`define U_OPCODE_LUI        7'b0110111

`define U_OPCODE_AUIPC      7'b0010111

`define I_OPCODE_OP_IMM     7'b0010011
`define funct3_addi         3'b000
`define funct3_slti         3'b010
`define funct3_sltiu        3'b011
`define funct3_xori         3'b100
`define funct3_ori          3'b110
`define funct3_andi         3'b111
`define funct3_slli         3'b001
`define funct3_srli_srai    3'b101
`define funct7_digit6_srli  1'b0
`define funct7_digit6_srai  1'b1

`define R_OPCODE            7'b0110011
`define funct3_add_sub      3'b000
`define funct7_digit6_add   1'b0
`define funct7_digit6_sub   1'b1
`define funct3_sll          3'b001
`define funct3_slt          3'b010
`define funct3_sltu         3'b011
`define funct3_xor          3'b100
`define funct3_srl_sra      3'b101
`define funct7_digit6_srl   1'b0
`define funct7_digit6_sra   1'b1
`define funct3_or           3'b110
`define funct3_and          3'b111

// ----Control Transfer Operation----
`define J_OPCODE_JAL        7'b1101111

`define J_OPCODE_JALR       7'b1100111

`define B_OPCODE            7'b1100011
`define funct3_beq          3'b000
`define funct3_bne          3'b001
`define funct3_blt          3'b100
`define funct3_bge          3'b101
`define funct3_bltu         3'b110
`define funct3_bgeu         3'b111

// ----Memory Access Operation----
`define I_OPCODE_LOAD       7'b0000011
`define funct3_lb           3'b000
`define funct3_lh           3'b001
`define funct3_lw           3'b010
`define funct3_lbu          3'b100
`define funct3_lhu          3'b101

`define S_OPCODE_STORE      7'b0100011
`define funct3_sb           3'b000
`define funct3_sh           3'b001
`define funct3_sw           3'b010

// ----Control Bundle----
`define CtrlBus                 15:0

// write enable to rd
`define ctrl_REG_we_Enable      1'b1
`define ctrl_REG_we_Disable     1'b0

// input A
`define ctrl_SRC_A_rs1          1'b0
`define ctrl_SRC_A_pc           1'b1

// input B 
`define ctrl_SRC_B_rs2          2'b00
`define ctrl_SRC_B_imm          2'b01
`define ctrl_SRC_B_4            2'b10

// ALU ops
`define ctrl_ALU_add            4'b0000
`define ctrl_ALU_sub            4'b0001
`define ctrl_ALU_slt            4'b0010
`define ctrl_ALU_sltu           4'b0011
`define ctrl_ALU_xor            4'b0100
`define ctrl_ALU_or             4'b0101
`define ctrl_ALU_and            4'b0110
`define ctrl_ALU_sll            4'b0111
`define ctrl_ALU_srl            4'b1000
`define ctrl_ALU_sra            4'b1001
`define ctrl_ALU_lui            4'b1010

// Branch Conditions
`define ctrl_BRANCH_none        3'b000      // no jump
`define ctrl_BRANCH_jump        3'b001      // unconditional jump to pc+imm
`define ctrl_BRANCH_reg_jump    3'b010      // unconditional jump to reg+imm
`define ctrl_BRANCH_jump_eq     3'b100      // conditioanl jump equal
`define ctrl_BRANCH_jump_ne     3'b101      // conditional jump not equal
`define ctrl_BRANCH_jump_l      3'b110      // conditional jump less than
`define ctrl_BRANCH_jump_ge     3'b111      // conditional jump greater than

// rd write source
`define ctrl_MemtoReg_SRC_ALU   1'b0        // write to rd from ALU
`define ctrl_MemtoReg_SRC_MEM   1'b1        // write to rd from data RAM

// write enable to data RAM
`define ctrl_MEM_we_Disable     1'b0        // disable write to data RAM
`define ctrl_MEM_we_Enable      1'b1        // Enable weitew to data RAM

// w/r formate
`define ctrl_MEM_op_byte        3'b000      // 1 byte, signed
`define ctrl_MEM_op_half        3'b001      // 2 bytes, signed
`define ctrl_MEM_op_word        3'b010      // 4 bytes
`define ctrl_MEM_op_ubyte       3'b100      // 1 byte, unsigned
`define ctrl_MEM_op_uhalf       3'b101      // 2 bytes, unsigned



