/*  id_ex buffer
-   hold decoded info produced in id stage for 1 beat, 
-   then pass info to ex stage
-   upon ID_EX_flush, output NOP 
*/

`include "defines.v"

module id_ex (
    input wire                  i_Clk,
    input wire                  i_reset,

    input wire[`InstAddrBus]    i_pc_addr,      // pc address
    input wire[`InstDataBus]    i_inst_data,    // instruction at pc
    input wire[`RegsDataBus]    i_reg1_data,    // data fetched from reg1
    input wire[`RegsDataBus]    i_reg2_data,    // data fetched from reg2
    input wire[`RegsAddrBus]    i_regd_addr,    // address of rd 
    input wire[`ImmDataBus]     i_imm_data,     // immediate
    input wire[`CtrlBus]        i_ctrl,         // control bundle

    input wire                  i_hold_flag,    // hold flag from ex

    output reg[`InstAddrBus]    o_pc_addr,      // pc address
    output reg[`InstDataBus]    o_inst_data,    // instruction at pc
    output reg[`RegsDataBus]    o_reg1_data,    // data fetched from reg1
    output reg[`RegsDataBus]    o_reg2_data,    // data fetched from reg2
    output reg[`RegsAddrBus]    o_regd_addr,    // address of rd 
    output reg[`ImmDataBus]     o_imm_data,     // immediate
    output reg[`CtrlBus]        o_ctrl          // control bundle
);

    always @(posedge i_Clk or posedge i_reset) begin
        if (i_reset == `ResetEnable) begin
            o_pc_addr <= `Reg0Addr;
            o_inst_data <= `ZeroWord;
            o_reg1_data <= `ZeroWord;
            o_reg2_data <= `ZeroWord;
            o_regd_addr <= `Reg0Addr;
            o_imm_data <= `ZeroWord;
            o_ctrl <= `ZeroHalf;
        end
        else if (i_hold_flag == `ID_EX_flush) begin
            o_pc_addr <= `Reg0Addr;
            o_inst_data <= `NOP;
            o_reg1_data <= `ZeroWord;
            o_reg2_data <= `ZeroWord;
            o_regd_addr <= `ZeroWord;
            o_imm_data <= `ZeroWord;
            o_ctrl <= `ZeroHalf;
        end
        else begin
            o_pc_addr <= i_pc_addr;
            o_inst_data <= i_inst_data;
            o_reg1_data <= i_reg1_data;
            o_reg2_data <= i_reg2_data;
            o_regd_addr <= i_regd_addr;
            o_imm_data <= i_imm_data;
            o_ctrl <= i_ctrl;
        end
    end

endmodule
