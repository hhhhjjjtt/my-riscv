/*  if_id buffer
-   hold instruction fetched in if stage for 1 beat, 
    then pass info to id stage
-   upon IF_ID_flush, output NOP 
-   upon IF_ID_hold, hold on to current value
*/

`include "defines.v"

module if_id (
    input wire                  i_Clk,
    input wire                  i_reset,

    input wire[`InstAddrBus]    i_pc_addr,      // input pc addr

    input wire[1:0]             i_hold_flag,    // hold flag from ex

    output reg[`InstAddrBus]    o_pc_addr,      // output pc addr
    output reg[`InstDataBus]    o_inst_data     // output instruction data
);

    wire[`InstDataBus] w_inst_data_rom;
    wire[`InstAddrBus] w_pc_addr_rom;

    inst_rom inst_rom_0(
        .i_Clk(i_Clk),
        .i_reset(i_reset),
        .i_we(),
        .i_w_data(),
        .i_w_addr(),
        .i_r_addr(i_pc_addr),
        .o_r_data(w_inst_data_rom),
        .o_r_addr(w_pc_addr_rom)
        );
    
    reg[1:0] hold_flag;

    always @(posedge i_Clk or posedge i_reset) begin
        if (i_reset == `ResetEnable) begin
            hold_flag <= 2'b0;
        end
        else begin
            hold_flag <= i_hold_flag;
        end
    end

    always @(*) begin
        // if (i_reset == `ResetEnable) begin
        //     o_inst_data = `ZeroWord;
        //     o_pc_addr = `ZeroWord;
        // end
        if (hold_flag == `IF_ID_flush) begin
            o_inst_data = `NOP;
            o_pc_addr = `Reg0Addr;
        end
        else if (hold_flag == `IF_ID_hold) begin
            o_inst_data = o_inst_data;
            o_pc_addr = o_pc_addr;
        end
        else begin
            o_inst_data = w_inst_data_rom;
            o_pc_addr = w_pc_addr_rom;
        end
    end

    // always @(posedge i_Clk or posedge i_reset) begin
    //     if (i_reset == `ResetEnable) begin
    //         o_inst_data <= `ZeroWord;
    //         o_pc_addr <= `ZeroWord;
    //     end
    //     else if (i_hold_flag == `IF_ID_flush) begin
    //         o_inst_data <= `NOP;
    //         o_pc_addr <= `Reg0Addr;
    //     end
    //     else if (i_hold_flag == `IF_ID_hold) begin
    //         o_inst_data <= o_inst_data;
    //         o_pc_addr <= o_pc_addr;
    //     end
    //     else begin
    //         o_inst_data <= w_inst_data_rom;
    //         o_pc_addr <= w_pc_addr_rom;
    //     end
    // end

    // always @(*) begin
    //     if (i_reset == `ResetEnable) begin
    //         o_inst_data = `ZeroWord;
    //         o_pc_addr = `ZeroWord;
    //     end
    //     else if (i_hold_flag == `IF_ID_flush) begin
    //         o_inst_data = `NOP;
    //         o_pc_addr = `Reg0Addr;
    //     end
    //     else if (i_hold_flag == `IF_ID_hold) begin
    //         o_inst_data = o_inst_data;
    //         o_pc_addr = o_pc_addr;
    //     end
    //     else begin
    //         o_inst_data = w_inst_data_rom;
    //         o_pc_addr = w_pc_addr_rom;
    //     end
    // end

endmodule
