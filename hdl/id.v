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
    
endmodule
