/*  regs
- 32 registers, each with 32 bits
*/

`include "defines.v"

module regs (
    input wire                  i_Clk,
    input wire                  i_reset,
    
    // from ex
    input wire                  i_we,           // write enable
    input wire[`RegsAddrBus]    i_w_addr,       // write addr 1
    input wire[`RegsDataBus]    i_w_data,       // write data

    // from id
    input wire[`RegsAddrBus]    i_r_addr1,      // read addr 1
    input wire[`RegsAddrBus]    i_r_addr2,      // read addr 2

    // to id 
    output reg[`RegsDataBus]    o_r_data1,      // read data 1
    output reg[`RegsDataBus]    o_r_data2       // read data 2
);
    reg[`RegsDataBus] regs[0:`RegsNum - 1];
    integer i;
    // write
    always @(posedge i_Clk or posedge i_reset) begin
        if (i_reset == `ResetEnable) begin
            for (i = 0; i < `RegsNum; i = i + 1) begin
                regs[i] <= `ZeroWord;
            end
        end
        else if ((i_we == `WriteEnable) && (i_w_addr != `Reg0Addr)) begin
            regs[i_w_addr] <= i_w_data;
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
