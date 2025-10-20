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

    // to pc
    output reg                  o_hold_flag,
    output reg                  o_jump_flag,
    output reg[`InstAddrBus]    o_jump_addr
);

    // decode ctrl bundle
    wire         ctrl_REG_we = i_ctrl[15];
    wire         ctrl_SRC_A = i_ctrl[14];
    wire[1:0]    ctrl_SRC_B = i_ctrl[13:12];
    wire[3:0]    ctrl_ALU = i_ctrl[11:8];
    wire[2:0]    ctrl_BRANCH = i_ctrl[7:5];
    wire         ctrl_MemtoReg_SRC = i_ctrl[4];
    wire         ctrl_MEM_we = i_ctrl[3];
    wire[2:0]    ctrl_MEM_op = i_ctrl[2:0];

endmodule
