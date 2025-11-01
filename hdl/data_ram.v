`include "defines.v"

module data_ram (
    input wire                  i_Clk,
    input wire                  i_reset,

    // write
    input wire                  i_we,
    input wire[`RAMDataBus]     i_w_data,
    input wire[`RAMAddrBus]     i_w_addr,

    // read
    input wire[`RAMAddrBus]     i_r_addr,

    // read result
    output reg[`RAMDataBus]     o_r_data,
    output reg[`RAMAddrBus]     o_r_addr
);

    reg[`RAMDataBus] rams[0:`RAMNum - 1];

    integer i;
    initial begin
        for (i = 0; i < `RAMNum; i = i + 1) begin
            rams[i] = `ZeroWord;
        end
    end

    always @(posedge i_Clk) begin
        if (i_we == `WriteEnable) begin
            rams[i_w_addr[31:2]] <= i_w_data;
        end
    end

    always @ (posedge i_Clk) begin      // always @ (*) begin
        if (i_reset == `ResetEnable) begin
            o_r_data = `ZeroWord;
            o_r_addr = `ZeroWord;
        end
        else begin
            /*  no address will start at 0x1, 0x2, 0xB...
                All address must be 4's multiple
                so we have i_r_addr[31:2] that only capture
                0x0, 0x4, 0x8, 0xC, 0x10...
            */
            o_r_data = rams[i_r_addr[31:2]];    
            o_r_addr = i_r_addr;
        end
    end
    
endmodule
