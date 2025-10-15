`include "defines.v"

module inst_rom (
    input wire                  i_ce,
    input wire                  i_Clk,

    // write
    input wire                  i_we,
    input wire[`ROMDataBus]     i_w_data,
    input wire[`ROMAddrBus]     i_w_addr,

    // read
    input wire[`ROMAddrBus]     i_r_addr,

    output reg[`ROMDataBus]     o_r_data,
    output reg[`ROMAddrBus]     o_r_addr,
);

    reg[`ROMDataBus] roms[0:`ROMNum - 1];

    initial $readmemh ( "inst_rom.data", roms);

    always @(posedge i_Clk) begin
        if (i_ce == `ChipEnable) begin
            if (i_we == `WriteEnable) begin
                roms[i_w_addr[31:2]] <= i_w_data;
            end
        end
    end

    always @ (*) begin
        if (i_ce == `ChipDisable) begin
            o_r_data = `ZeroWord;
            o_r_addr = `ZeroWord;
        end
        else begin
            /*  no address will start at 0x1, 0x2, 0xB...
                All address must be 4's multiple
                so we have i_r_addr[31:2] that only capture
                0x0, 0x4, 0x8, 0xC, 0x10...
            */
            o_r_data = roms[i_r_addr[31:2]]; 
            o_r_addr = i_r_addr;
        end
    end
    
endmodule
