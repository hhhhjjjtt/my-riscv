`include "defines.v"

module ex (
    input wire                  i_reset,

    input wire[`InstAddrBus]    i_pc_addr,      // pc address
    input wire[`InstDataBus]    i_inst_data,    // instruction at pc
    input wire[`RegsDataBus]    i_reg1_data,    // data fetched from reg1
    input wire[`RegsDataBus]    i_reg2_data,    // data fetched from reg2
    input wire[`RegsAddrBus]    i_regd_addr,    // address of rd 
    input wire[`ImmDataBus]     i_imm_data,     // immediate
    input wire[`CtrlBus]        i_ctrl,         // control bundle

    // from data_ram
    input wire[`RAMDataBus]     i_mem_r_data,   // data fetched from data ram

    // to regs
    output reg                  o_regd_we,      // rd write enable
    output reg[`RegsAddrBus]    o_regd_w_addr,  // rd write address
    output reg[`RegsDataBus]    o_regd_w_data,  // rd write data

    // to data_ram
    output reg                  o_mem_we,       // data ram write enable
    output reg[`RAMAddrBus]     o_mem_r_addr,   // read address of data ram
    output reg[`RAMAddrBus]     o_mem_w_addr,   // write address of data ram
    output reg[`RAMDataBus]     o_mem_w_data,   // write data of data ram

    // to hold_ctrl
    output reg[`HoldTypeBus]    o_hold_type,
    output reg                  o_jump_flag,
    output reg[`InstAddrBus]    o_jump_addr
);

    // decode ctrl bundle
    wire        ctrl_REG_we = i_ctrl[15];
    wire        ctrl_SRC_A = i_ctrl[14];
    wire[1:0]   ctrl_SRC_B = i_ctrl[13:12];
    wire[3:0]   ctrl_ALU = i_ctrl[11:8];
    wire[2:0]   ctrl_BRANCH = i_ctrl[7:5];
    wire        ctrl_MemtoReg_SRC = i_ctrl[4];
    wire        ctrl_MEM_we = i_ctrl[3];
    wire[2:0]   ctrl_MEM_op = i_ctrl[2:0];

    reg         branch_en;
    reg         load_en;

    // ALU input A
    reg[`RegsDataBus] alu_SRC_A;
    always @(*) begin
        case (ctrl_SRC_A)
            `ctrl_SRC_A_rs1: begin
                alu_SRC_A = i_reg1_data;
            end
            `ctrl_SRC_A_pc: begin
                alu_SRC_A = i_pc_addr;
            end
            default: begin
                alu_SRC_A = i_reg1_data;
            end
        endcase
    end

    // ALU input B
    reg[`RegsDataBus] alu_SRC_B;
    always @(*) begin
        case (ctrl_SRC_B)
            `ctrl_SRC_B_rs2: begin
                alu_SRC_B = i_reg2_data;
            end
            `ctrl_SRC_B_imm: begin
                alu_SRC_B = i_imm_data;
            end
            `ctrl_SRC_B_4: begin
                alu_SRC_B = 32'd4;
            end
            default: begin
                alu_SRC_B = i_reg2_data;
            end
        endcase
    end

    // equal flag
    wire equal_flag = (alu_SRC_A == alu_SRC_B);

    // ALU Result
    reg[`RegsDataBus] alu_result;
    always @(*) begin
        case (ctrl_ALU)
            `ctrl_ALU_add: begin
                alu_result = alu_SRC_A + alu_SRC_B;
            end
            `ctrl_ALU_sub: begin
                alu_result = alu_SRC_A - alu_SRC_B;
            end
            `ctrl_ALU_slt: begin
                alu_result = $signed(alu_SRC_A) < $signed(alu_SRC_B) ? 32'd1 : 32'd0;
            end
            `ctrl_ALU_sltu: begin
                alu_result = alu_SRC_A < alu_SRC_B ? 32'd1 : 32'd0;
            end
            `ctrl_ALU_xor: begin
                alu_result = alu_SRC_A ^ alu_SRC_B;
            end
            `ctrl_ALU_or: begin
                alu_result = alu_SRC_A | alu_SRC_B;
            end
            `ctrl_ALU_and: begin
                alu_result = alu_SRC_A & alu_SRC_B;
            end
            `ctrl_ALU_sll: begin
                alu_result = alu_SRC_A << alu_SRC_B[4:0];
            end
            `ctrl_ALU_srl: begin
                alu_result = alu_SRC_A >> alu_SRC_B[4:0];
            end
            `ctrl_ALU_sra: begin
                alu_result = $signed(alu_SRC_A) >>> alu_SRC_B[4:0];
            end
            `ctrl_ALU_lui: begin
                alu_result = alu_SRC_B;
            end
            default: begin
                alu_result = `ZeroWord;
            end
        endcase
    end

    // branch & branch hazard control
    always @(*) begin
        if (i_reset == `ResetEnable) begin
            // o_hold_type = `hold_type_none;
            branch_en = `branch_disable;
            o_jump_flag = `JumpDisable;
            o_jump_addr = `ZeroWord;
        end
        else begin
            case (ctrl_BRANCH)
                `ctrl_BRANCH_none: begin
                    // o_hold_type = `hold_type_none;
                    branch_en = `branch_disable;
                    o_jump_flag = `JumpDisable;
                    o_jump_addr = `ZeroWord;
                end
                `ctrl_BRANCH_jump: begin
                    // o_hold_type = `hold_type_branch;
                    branch_en = `branch_enable;
                    o_jump_flag = `JumpEnable;
                    o_jump_addr = i_pc_addr + i_imm_data;
                end
                `ctrl_BRANCH_reg_jump: begin
                    // o_hold_type = `hold_type_branch;
                    branch_en = `branch_enable;
                    o_jump_flag = `JumpEnable;
                    o_jump_addr =  (i_reg1_data + i_imm_data) & ~32'd1;
                end
                `ctrl_BRANCH_jump_eq: begin
                    // o_hold_type = equal_flag ? `hold_type_branch : `hold_type_none;
                    branch_en = equal_flag ? `branch_enable : `branch_disable;
                    o_jump_flag = equal_flag ? `JumpEnable : `JumpDisable;
                    o_jump_addr = i_pc_addr + i_imm_data;
                end
                `ctrl_BRANCH_jump_ne: begin
                    // o_hold_type = equal_flag ? `hold_type_none : `hold_type_branch;
                    branch_en = equal_flag ? `branch_disable : `branch_enable;
                    o_jump_flag = equal_flag ? `JumpDisable : `JumpEnable;
                    o_jump_addr = i_pc_addr + i_imm_data;
                end
                `ctrl_BRANCH_jump_l: begin      // slt: A < B
                    // o_hold_type = (alu_result == 1) ? `hold_type_branch : `hold_type_none;
                    branch_en = (alu_result == 1) ? `branch_enable : `branch_disable;
                    o_jump_flag = (alu_result == 1) ? `JumpEnable : `JumpDisable;
                    o_jump_addr = i_pc_addr + i_imm_data;
                end
                `ctrl_BRANCH_jump_ge: begin     // slt: ~(A < B)
                    // o_hold_type = (alu_result == 1) ? `hold_type_none : `hold_type_branch;
                    branch_en = (alu_result == 1) ? `branch_disable : `branch_enable;
                    o_jump_flag = (alu_result == 1) ? `JumpDisable : `JumpEnable;
                    o_jump_addr = i_pc_addr + i_imm_data;
                end
                default: begin
                    // o_hold_type = `hold_type_none;
                    branch_en = `branch_disable;
                    o_jump_flag = `JumpDisable;
                    o_jump_addr = i_pc_addr + 32'd4;
                end
            endcase
        end 
    end

    // data ram operation length
    reg[`RegsDataBus] mem_r_result;             // data ram fetch result
    always @(*) begin
        if (i_reset == `ResetEnable) begin
            o_mem_we = `WriteDisable;
            o_mem_r_addr = `ZeroWord;
            o_mem_w_addr = `ZeroWord;
            o_mem_w_data = `ZeroWord;
        end
        else begin
            o_mem_we = ctrl_MEM_we;             // data ram write enable
            o_mem_r_addr = alu_result;          // data ram read address
            o_mem_w_addr = alu_result;          // data ram write address

            case (ctrl_MEM_op)
                `ctrl_MEM_op_byte: begin
                    mem_r_result = {{24{i_mem_r_data[7]}}, i_mem_r_data[7:0]};
                    o_mem_w_data = {{24{i_reg2_data[7]}}, i_reg2_data[7:0]};
                end
                `ctrl_MEM_op_half: begin
                    mem_r_result = {{16{i_mem_r_data[15]}}, i_mem_r_data[15:0]};
                    o_mem_w_data = {{16{i_reg2_data[15]}}, i_reg2_data[15:0]};
                end
                `ctrl_MEM_op_word: begin
                    mem_r_result = i_mem_r_data;
                    o_mem_w_data = i_reg2_data;
                end
                `ctrl_MEM_op_ubyte: begin
                    mem_r_result = {24'b0, i_mem_r_data[7:0]};
                    o_mem_w_data = i_reg2_data;
                end
                `ctrl_MEM_op_uhalf: begin
                    mem_r_result = {16'b0, i_mem_r_data[15:0]};
                    o_mem_w_data = i_reg2_data;
                end
                default: begin
                    mem_r_result = i_mem_r_data;
                    o_mem_w_data = i_reg2_data;
                end
            endcase
        end
    end

    // load hazard control
    always @(*) begin
        if (i_reset == `ResetEnable) begin
            load_en = `load_disable;
        end
        else begin
            load_en = (ctrl_MemtoReg_SRC == `ctrl_MemtoReg_SRC_MEM) &&
                      (ctrl_REG_we == `ctrl_REG_we_Enable) &&
                      (i_regd_addr != `Reg0Addr);
        end
    end

    // hold control
    always @(*) begin
        o_hold_type = {load_en, branch_en};
    end

    // rd write
    always @(*) begin
        if (i_reset == `ResetEnable) begin
            o_regd_we = `WriteDisable;
            o_regd_w_addr = `Reg0Addr;
            o_regd_w_data = `ZeroWord;
        end
        else begin
            o_regd_we = ctrl_REG_we;                // rd write enable
            o_regd_w_addr = i_regd_addr;            // rd addr

            case (ctrl_MemtoReg_SRC)                // ALU or mem result to be written to rd
                `ctrl_MemtoReg_SRC_ALU: begin
                    o_regd_w_data = alu_result;
                end 
                `ctrl_MemtoReg_SRC_MEM: begin
                    o_regd_w_data = mem_r_result;
                end 
                default: begin
                    o_regd_w_data = alu_result;
                end
            endcase
        end
    end

endmodule
