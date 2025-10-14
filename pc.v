/*  pc
- Jump to i_jump_addr if i_jump_flag is active
- Hold on to current position if i_hold is active
- Otherwise, increment address by 4 (4 byte, or 32bit) 
    on each clock cycle
*/
`include "defines.v"

module pc (
    input wire                  i_Clk,
    input wire                  i_reset,
    
    // jump flag
    input wire                  i_jump_flag,
    input wire[`InstAddrBus]    i_jump_addr,
    
    // hold flag
    input wire[`HoldFlagBus]    i_hold_flag,

    // output pc counter
    output reg[`InstAddrBus]    o_pc
);
    
    always @(posedge i_Clk) begin
        if (i_reset == `ResetEnable) begin
            o_pc <= 32'h0; 
        end
        else if (i_jump_flag == `JumpEnable) begin
            o_pc <= i_jump_addr;
        end
        else if (i_hold_flag == `Hold_PC) begin
            o_pc <= o_pc;
        end
        else begin
            o_pc <= o_pc + 32'h4;
        end
    end

endmodule
