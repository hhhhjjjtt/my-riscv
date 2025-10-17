`include "defines.v"

module if_id (
    input wire                  i_Clk,
    input wire                  i_reset,

    input wire[`InstAddrBus]    i_pc_addr,      // input pc addr
    input wire[`InstDataBus]    i_inst_data,    // input instruction data

    input wire                  i_hold_flag,    // hold flag from ex

    output wire[`InstAddrBus]   o_pc_addr       // output pc addr
    output wire[`InstDataBus]   o_inst_data,    // output instruction data
);
    
    always @(posedge i_Clk) begin
        if (i_reset == `ResetEnable) begin
            o_inst_data <= `ZeroWord;
            o_pc_addr <= `ZeroWord;
        end
        else if (i_hold_flag == `Hold_IF) begin
            o_inst_data <= `ZeroWord;
            o_pc_addr <= `ZeroWord;
        end
        else begin
            o_inst_data <= i_inst_data;
            o_pc_addr <= i_pc_addr;
        end
    end

endmodule
