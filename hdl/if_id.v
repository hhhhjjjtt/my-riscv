`include "defines.v"

module if_id (
    input wire                  i_Clk,
    input wire                  i_reset,

    input wire[`InstAddrBus]    i_pc_addr,      // input pc addr
    input wire[`InstDataBus]    i_inst_data,    // input instruction data

    input wire                  i_hold_flag,    // hold flag from ex

    output reg[`InstAddrBus]    o_pc_addr,      // output pc addr
    output reg[`InstDataBus]    o_inst_data     // output instruction data
);

    // reg[`InstAddrBus] r_pc_addr;
    // reg[`InstDataBus] r_inst_data;

    always @(posedge i_Clk or posedge i_reset) begin
        if (i_reset == `ResetEnable) begin
            o_inst_data <= `ZeroWord;
            o_pc_addr <= `ZeroWord;
        end
        else if (i_hold_flag == `HoldEnable) begin
            o_inst_data <= `NOP;
            o_pc_addr <= `Reg0Addr;
        end
        else begin
            o_inst_data <= i_inst_data;
            o_pc_addr <= i_pc_addr;
        end
    end

    // always @(*) begin
    //     o_inst_data = r_inst_data;
    //     o_pc_addr = r_pc_addr;
    // end

endmodule
