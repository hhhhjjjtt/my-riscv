/*  hold control
-   recieve hold flag from ex stage
-   send corresponding hold/flush signals to pc/if_id/id_ex buffer
*/

`include "defines.v"

module hold_ctrl (
    input wire                  i_reset,

    // from ex
    input wire[`HoldTypeBus]    i_hold_type,
    input wire                  i_jump_flag,
    input wire[`InstAddrBus]    i_jump_addr,

    // to pc, if_id, and id_ex
    output reg[`HoldFlagBus]    o_hold_flag,    // [2]->pc; [1]->if_id; [0]->id_ex

    // to pc
    output reg                  o_jump_flag,
    output reg[`InstAddrBus]    o_jump_addr
);

    // o_hold_flag: {pc_hold, if_id_hold, id_ex_hold}
    always @(*) begin
        o_hold_flag = `hold_flag_none;
        o_jump_flag = i_jump_flag;
        o_jump_addr = i_jump_addr;
        // if (i_reset == `ResetEnable) begin
        //     o_hold_flag = `hold_flag_none;
        //     o_jump_flag = `JumpDisable;
        //     o_jump_addr = `ZeroWord;
        // end
        if (i_hold_type == `hold_type_none) begin
            o_hold_flag = `hold_flag_none;
            o_jump_flag = `JumpDisable;
            o_jump_addr = `ZeroWord;
        end
        else if (i_hold_type == `hold_type_branch) begin
            o_hold_flag = `hold_flag_branch;
            o_jump_flag = i_jump_flag;
            o_jump_addr = i_jump_addr;
        end
        else if (i_hold_type == `hold_type_load) begin
            o_hold_flag = `hold_flag_load;
            o_jump_flag = `JumpDisable;
            o_jump_addr = `ZeroWord;
        end
        else begin
            o_hold_flag = `hold_flag_none;
            o_jump_flag = `JumpDisable;
            o_jump_addr = `ZeroWord;
        end
    end

endmodule
