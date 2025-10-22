`include "defines.v"

module id (
    input wire                  i_reset,

    // from if_id
    input wire[`InstAddrBus]    i_pc_addr,      // pc address
    input wire[`InstDataBus]    i_inst_data,    // instruction at pc

    // from regs
    input wire[`RegsDataBus]    i_reg1_r_data,  // data fetched from reg1
    input wire[`RegsDataBus]    i_reg2_r_data,  // data fetched from reg2

    // to regs
    output reg[`RegsAddrBus]    o_reg1_r_addr,  // address to fetch from reg1
    output reg[`RegsAddrBus]    o_reg2_r_addr,  // address to fetch from reg2

    // to id_ex
    output reg[`InstAddrBus]    o_pc_addr,      // pc address
    output reg[`InstDataBus]    o_inst_data,    // instruction at pc
    output reg[`RegsDataBus]    o_reg1_data,    // data fetched from reg1
    output reg[`RegsDataBus]    o_reg2_data,    // data fetched from reg2
    output reg[`RegsAddrBus]    o_regd_addr,    // address of rd 
    output reg[`ImmDataBus]     o_imm_data,     // immediate
    output reg[`CtrlBus]        o_ctrl          // control bundle to tell ex what to do with the data above
);

    wire[6:0] opcode = i_inst_data[6:0];
    wire[2:0] funct3 = i_inst_data[14:12];
    wire[6:0] funct7 = i_inst_data[31:25];
    wire[4:0] rd = i_inst_data[11:7];
    wire[4:0] rs1 = i_inst_data[19:15];
    wire[4:0] rs2 = i_inst_data[24:20];

    // Control Bundles
    reg         ctrl_REG_we;
    reg         ctrl_SRC_A;
    reg[1:0]    ctrl_SRC_B;
    reg[3:0]    ctrl_ALU;
    reg[2:0]    ctrl_BRANCH;
    reg         ctrl_MemtoReg_SRC;
    reg         ctrl_MEM_we;
    reg[2:0]    ctrl_MEM_op;

    wire[`ImmDataBus] immI = {{20{i_inst_data[31]}}, i_inst_data[31:20]};
    wire[`ImmDataBus] immU = {i_inst_data[31:12], 12'b0};
    wire[`ImmDataBus] immS = {{20{i_inst_data[31]}}, i_inst_data[31:25], i_inst_data[11:7]};
    wire[`ImmDataBus] immB = {{20{i_inst_data[31]}}, i_inst_data[7], i_inst_data[30:25], i_inst_data[11:8], 1'b0};
    wire[`ImmDataBus] immJ = {{12{i_inst_data[31]}}, i_inst_data[19:12], i_inst_data[20], i_inst_data[30:21], 1'b0};
    reg[`ImmDataBus] imm;

    always @(*) begin
        case (opcode[6:2])
            5'b11001,5'b00100,5'b00000:     imm = immI;
            5'b01101,5'b00101:              imm = immU;
            5'b01000:                       imm = immS;
            5'b11000:                       imm = immB;
            5'b11011:                       imm = immJ;
            default:                        imm = `ZeroWord;
        endcase
    end

    always @(*) begin
        if (i_reset) begin
            o_reg1_r_addr = `Reg0Addr;
            o_reg2_r_addr = `Reg0Addr;
            
            o_inst_data = `ZeroWord;
            o_pc_addr = `ZeroWord;
            
            o_reg1_data = `ZeroWord;
            o_reg2_data = `ZeroWord;
            o_regd_addr = `Reg0Addr;
            
            o_imm_data = `ZeroWord;
            
            o_ctrl = `ZeroHalf;
        end
        else begin
            o_reg1_r_addr = rs1;
            o_reg2_r_addr = rs2;
            
            o_inst_data = i_inst_data;
            o_pc_addr = i_pc_addr;

            o_reg1_data = i_reg1_r_data;
            o_reg2_data = i_reg2_r_data;
            o_regd_addr = rd;
            
            o_imm_data = imm;

            
            
            case (opcode)
                `U_OPCODE_LUI: begin
                    ctrl_REG_we = `ctrl_REG_we_Enable;
                    ctrl_SRC_A = `ctrl_SRC_A_pc;   // doesn't matter in LUI
                    ctrl_SRC_B = `ctrl_SRC_B_imm;
                    ctrl_ALU = `ctrl_ALU_lui;
                    ctrl_BRANCH = `ctrl_BRANCH_none;
                    ctrl_MemtoReg_SRC = `ctrl_MemtoReg_SRC_ALU;
                    ctrl_MEM_we = `ctrl_MEM_we_Disable;
                    ctrl_MEM_op = `ctrl_MEM_op_word;
                end
                `U_OPCODE_AUIPC: begin
                    ctrl_REG_we = `ctrl_REG_we_Enable;
                    ctrl_SRC_A = `ctrl_SRC_A_pc;
                    ctrl_SRC_B = `ctrl_SRC_B_imm;
                    ctrl_ALU = `ctrl_ALU_add;
                    ctrl_BRANCH = `ctrl_BRANCH_none;
                    ctrl_MemtoReg_SRC = `ctrl_MemtoReg_SRC_ALU;
                    ctrl_MEM_we = `ctrl_MEM_we_Disable;
                    ctrl_MEM_op = `ctrl_MEM_op_word;
                end
                `I_OPCODE_OP_IMM: begin
                    ctrl_REG_we = `ctrl_REG_we_Enable;
                    ctrl_SRC_A = `ctrl_SRC_A_rs1;
                    ctrl_SRC_B = `ctrl_SRC_B_imm;
                    ctrl_BRANCH = `ctrl_BRANCH_none;
                    ctrl_MemtoReg_SRC = `ctrl_MemtoReg_SRC_ALU;
                    ctrl_MEM_we = `ctrl_MEM_we_Disable;
                    ctrl_MEM_op = `ctrl_MEM_op_word;
                    case (funct3)
                        `funct3_addi: begin
                            ctrl_ALU = `ctrl_ALU_add;
                        end
                        `funct3_slti: begin
                            ctrl_ALU = `ctrl_ALU_slt;
                        end
                        `funct3_sltiu: begin
                            ctrl_ALU = `ctrl_ALU_sltu;
                        end
                        `funct3_xori: begin
                            ctrl_ALU = `ctrl_ALU_xor;
                        end
                        `funct3_ori: begin
                            ctrl_ALU = `ctrl_ALU_or;
                        end
                        `funct3_andi: begin
                            ctrl_ALU = `ctrl_ALU_and;
                        end
                        `funct3_slli: begin
                            ctrl_ALU = `ctrl_ALU_sll;
                        end
                        `funct3_srli_srai: begin
                            ctrl_ALU = (funct7[5] == `funct7_digit6_srli) ? `ctrl_ALU_srl : `ctrl_ALU_sra;
                        end 
                        default: begin
                            ctrl_ALU = `ctrl_ALU_add;
                        end
                    endcase
                end
                `R_OPCODE: begin
                    ctrl_REG_we = `ctrl_REG_we_Enable;
                    ctrl_SRC_A = `ctrl_SRC_A_rs1;
                    ctrl_SRC_B = `ctrl_SRC_B_rs2;
                    ctrl_BRANCH = `ctrl_BRANCH_none;
                    ctrl_MemtoReg_SRC = `ctrl_MemtoReg_SRC_ALU;
                    ctrl_MEM_we = `ctrl_MEM_we_Disable;
                    ctrl_MEM_op = `ctrl_MEM_op_word;
                    case (funct3)
                        `funct3_add_sub: begin
                            ctrl_ALU = (funct7[5] == `funct7_digit6_add) ? `ctrl_ALU_add : `ctrl_ALU_sub;
                        end
                        `funct3_sll: begin
                            ctrl_ALU = `ctrl_ALU_sll;
                        end
                        `funct3_slt: begin
                            ctrl_ALU = `ctrl_ALU_slt;
                        end
                        `funct3_sltu: begin
                            ctrl_ALU = `ctrl_ALU_sltu;
                        end
                        `funct3_xor: begin
                            ctrl_ALU = `ctrl_ALU_xor;
                        end
                        `funct3_srl_sra: begin
                            ctrl_ALU = (funct7[5] == `funct7_digit6_srl) ? `ctrl_ALU_srl : `ctrl_ALU_sra;
                        end   
                        `funct3_or: begin
                            ctrl_ALU = `ctrl_ALU_or;
                        end
                        `funct3_and: begin
                            ctrl_ALU = `ctrl_ALU_and;
                        end
                        default: begin
                            ctrl_ALU = `ctrl_ALU_add;
                        end
                    endcase
                end
                `J_OPCODE_JAL: begin
                    ctrl_REG_we = `ctrl_REG_we_Enable;
                    ctrl_SRC_A = `ctrl_SRC_A_pc;
                    ctrl_SRC_B = `ctrl_SRC_B_4;
                    ctrl_ALU = `ctrl_ALU_add;
                    ctrl_BRANCH = `ctrl_BRANCH_jump;
                    ctrl_MemtoReg_SRC = `ctrl_MemtoReg_SRC_ALU;
                    ctrl_MEM_we = `ctrl_MEM_we_Disable;
                    ctrl_MEM_op = `ctrl_MEM_op_word;
                end
                `J_OPCODE_JALR: begin
                    ctrl_REG_we = `ctrl_REG_we_Enable;
                    ctrl_SRC_A = `ctrl_SRC_A_pc;
                    ctrl_SRC_B = `ctrl_SRC_B_4;
                    ctrl_ALU = `ctrl_ALU_add;
                    ctrl_BRANCH = `ctrl_BRANCH_reg_jump;
                    ctrl_MemtoReg_SRC = `ctrl_MemtoReg_SRC_ALU;
                    ctrl_MEM_we = `ctrl_MEM_we_Disable;
                    ctrl_MEM_op = `ctrl_MEM_op_word;
                end
                `B_OPCODE: begin
                    ctrl_REG_we = `ctrl_REG_we_Disable;
                    ctrl_SRC_A = `ctrl_SRC_A_rs1;
                    ctrl_SRC_B = `ctrl_SRC_B_rs2;
                    ctrl_MemtoReg_SRC = `ctrl_MemtoReg_SRC_ALU;
                    ctrl_MEM_we = `ctrl_MEM_we_Disable;
                    ctrl_MEM_op = `ctrl_MEM_op_word;
                    case (funct3)
                        `funct3_beq: begin
                            ctrl_ALU = `ctrl_ALU_slt;
                            ctrl_BRANCH = `ctrl_BRANCH_jump_eq;
                        end
                        `funct3_bne: begin
                            ctrl_ALU = `ctrl_ALU_slt;
                            ctrl_BRANCH = `ctrl_BRANCH_jump_ne;
                        end
                        `funct3_blt: begin
                            ctrl_ALU = `ctrl_ALU_slt;
                            ctrl_BRANCH = `ctrl_BRANCH_jump_l;
                        end
                        `funct3_bge: begin
                            ctrl_ALU = `ctrl_ALU_slt;
                            ctrl_BRANCH = `ctrl_BRANCH_jump_ge;
                        end
                        `funct3_bltu: begin
                            ctrl_ALU = `ctrl_ALU_sltu;
                            ctrl_BRANCH = `ctrl_BRANCH_jump_l;
                        end
                        `funct3_bgeu: begin
                            ctrl_ALU = `ctrl_ALU_sltu;
                            ctrl_BRANCH = `ctrl_BRANCH_jump_ge;
                        end
                        default: begin
                            ctrl_ALU = `ctrl_ALU_slt;
                            ctrl_BRANCH = `ctrl_BRANCH_jump_eq;
                        end
                    endcase
                end
                `I_OPCODE_LOAD: begin
                    ctrl_REG_we = `ctrl_REG_we_Enable;
                    ctrl_SRC_A = `ctrl_SRC_A_rs1;
                    ctrl_SRC_B = `ctrl_SRC_B_imm;
                    ctrl_ALU = `ctrl_ALU_add;
                    ctrl_BRANCH = `ctrl_BRANCH_none;
                    ctrl_MemtoReg_SRC = `ctrl_MemtoReg_SRC_MEM;
                    ctrl_MEM_we = `ctrl_MEM_we_Disable;
                    case (funct3)
                        `funct3_lb: begin
                            ctrl_MEM_op = `ctrl_MEM_op_byte;
                        end
                        `funct3_lh: begin
                            ctrl_MEM_op = `ctrl_MEM_op_half;
                        end
                        `funct3_lw: begin
                            ctrl_MEM_op = `ctrl_MEM_op_word;
                        end
                        `funct3_lbu: begin
                            ctrl_MEM_op = `ctrl_MEM_op_ubyte;
                        end
                        `funct3_lhu: begin
                            ctrl_MEM_op = `ctrl_MEM_op_uhalf;
                        end
                        default: begin
                            ctrl_MEM_op = `ctrl_MEM_op_word;
                        end
                    endcase
                end
                `S_OPCODE_STORE: begin
                    ctrl_REG_we = `ctrl_REG_we_Disable;
                    ctrl_SRC_A = `ctrl_SRC_A_rs1;
                    ctrl_SRC_B = `ctrl_SRC_B_imm;
                    ctrl_ALU = `ctrl_ALU_add;
                    ctrl_BRANCH = `ctrl_BRANCH_none;
                    ctrl_MemtoReg_SRC = `ctrl_MemtoReg_SRC_MEM;
                    ctrl_MEM_we = `ctrl_MEM_we_Enable;
                    case (funct3)
                        `funct3_sb: begin
                            ctrl_MEM_op = `ctrl_MEM_op_byte;
                        end
                        `funct3_sh: begin
                            ctrl_MEM_op = `ctrl_MEM_op_half;
                        end
                        `funct3_sw: begin
                            ctrl_MEM_op = `ctrl_MEM_op_word;
                        end
                        default: begin
                            ctrl_MEM_op = `ctrl_MEM_op_byte;
                        end
                    endcase
                end
                default: begin
                    ctrl_REG_we = `ctrl_REG_we_Disable;
                    ctrl_SRC_A = `ctrl_SRC_A_rs1;
                    ctrl_SRC_B = `ctrl_SRC_B_imm;
                    ctrl_ALU = `ctrl_ALU_add;
                    ctrl_BRANCH = `ctrl_BRANCH_none;
                    ctrl_MemtoReg_SRC = `ctrl_MemtoReg_SRC_ALU;
                    ctrl_MEM_we = `ctrl_MEM_we_Disable;
                    ctrl_MEM_op = `ctrl_MEM_op_word;
                end
            endcase

            o_ctrl = {ctrl_REG_we, ctrl_SRC_A, ctrl_SRC_B, ctrl_ALU, ctrl_BRANCH, ctrl_MemtoReg_SRC, ctrl_MEM_we, ctrl_MEM_op};
        end
    end    
    
endmodule
