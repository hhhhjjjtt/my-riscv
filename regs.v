/*  rom
- 32 registers, each with 32 bits
*/

`include "defines.v"

module regs (
    input wire                  i_Clk,
    input wire                  i_reset,
    
    // from ex
    input wire                  i_we,
    input wire[`RegsAddrBus]    i_w_addr,
    input wire[`RegsDataBus]    i_w_data,

    // from id
    input wire[`RegsAddrBus]    i_r_addr1, 
    input wire[`RegsAddrBus]    i_r_addr2,

    // to id 
    output reg[`RegsDataBus]    o_r_data1,
    output reg[`RegsDataBus]    o_r_data2,
);
    reg[`RegsDataBus] regs[0:`RegsNum - 1];

    // write
    always @(posedge i_Clk) begin
        if (i_reset == `ResetDisable) begin
            if (i_we == `WriteEnable && i_w_addr != `Reg0Addr) begin
                regs[i_w_addr] <= i_w_data;
            end
        end
    end

    // read reg1
    always @(*) begin
        if (i_r_addr1 == `Reg0Addr) begin
            o_r_data1 <= `ZeroWord;
        end
        else if ((i_we == `WriteEnable) && (i_r_addr1 == i_w_addr)) begin
            o_r_data1 <= i_w_data;
        end
        else begin
            o_r_data1 <= regs[i_r_addr1];
        end
    end

    // read reg2
    always @(*) begin
        if (i_r_addr2 == `Reg0Addr) begin
            o_r_data2 <= `ZeroWord;
        end
        else if ((i_we == `WriteEnable) && (i_r_addr2 == i_w_addr)) begin
            o_r_data2 <= i_w_data;
        end
        else begin
            o_r_data2 <= regs[i_r_addr2];
        end
    end

endmodule