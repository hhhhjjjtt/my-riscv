/*  pc pointer
-   Jump to i_jump_addr if i_jump_flag is active
-   Hold on to current position if i_hold is active
-   Otherwise, increment address by 4 (4 byte, or 32bit) 
    on each clock cycle
*/

`include "defines.v"

module pc (
    input wire                  i_Clk,
    input wire                  i_reset,
    
    // from hold_ctrl
    input wire                  i_hold_flag,    // hold flag
    input wire                  i_jump_flag,    // jump flag
    input wire[`InstAddrBus]    i_jump_addr,    // jump addr

    // to if_id
    output reg[`InstAddrBus]    o_pc_addr       // pc addr 
);

    always @(posedge i_Clk or posedge i_reset) begin
        if (i_reset == `ResetEnable) begin
            o_pc_addr <= 32'h0; 
        end
        else if (i_jump_flag == `JumpEnable) begin
            o_pc_addr <= i_jump_addr;
        end
        else if (i_hold_flag == `PC_hold) begin
            o_pc_addr <= o_pc_addr;
        end
        else begin
            o_pc_addr <= o_pc_addr + 32'h4;
        end
    end

endmodule
