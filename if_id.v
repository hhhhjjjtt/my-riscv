`include "defines.v"

module if_id (
    input wire                  i_Clk,
    input wire                  i_reset,

    input wire[`InstDataBus]    i_inst_data,    // instruction
    input wire[`InstAddrBus]    i_inst_addr,    // pc addr

    input wire                  i_hold_flag,

    output wire[`InstDataBus]   o_inst_data,
    output wire[`InstAddrBus]   o_inst_addr
);
    
    always @(posedge i_Clk) begin
        if (i_reset == `ResetEnable) begin
            o_inst_data <= `ZeroWord;
            o_inst_addr <= `ZeroWord;
        end
        else if (i_hold_flag == `Hold_IF) begin
            o_inst_data <= `ZeroWord;
            o_inst_addr <= `ZeroWord;
        end
        else begin
            o_inst_data <= i_inst_data;
            o_inst_addr <= i_inst_addr;
        end
    end

endmodule
