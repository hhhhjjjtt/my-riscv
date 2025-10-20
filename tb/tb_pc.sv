`timescale 1ns/1ps
`include "defines.v"

module tb_pc ();
    reg r_Clk;
    reg r_reset;
    reg r_hold_flag;
    reg r_jump_flag;
    reg[`InstAddrBus] r_jump_addr;

    wire[`InstAddrBus] wire_pc_addr;

    parameter CLK_PERIOD = 40;

    pc pc_0(
        .i_Clk(r_Clk),
        .i_reset(r_reset),
        .i_hold_flag(r_hold_flag),
        .i_jump_flag(r_jump_flag),
        .i_jump_addr(r_jump_addr),

        .o_pc_addr(wire_pc_addr)
    );

    reg r_ce;
    reg r_we;
    reg[`ROMDataBus] r_w_data;
    reg[`ROMAddrBus] r_w_addr;

    wire[`ROMDataBus] wire_r_data;
    wire[`ROMAddrBus] wire_r_addr;
    inst_rom inst_rom_0(
        .i_ce(r_ce),
        .i_Clk(r_Clk),
        .i_we(r_we),
        .i_w_data(r_w_data),
        .i_w_addr(r_w_addr),
        .i_r_addr(wire_pc_addr),

        .o_r_data(wire_r_data),
        .o_r_addr(wire_r_addr)
    );

    initial begin
        r_Clk = 0;
        forever begin
            #(CLK_PERIOD/2);
            r_Clk = ~r_Clk;
        end
    end
        
     initial begin
        r_reset = 1;
        r_hold_flag = 0;
        r_jump_flag = 0;
        r_jump_addr = 32'd0;

        r_ce = 1;
        r_we = 0;
        r_w_data = `ZeroWord;
        r_w_addr = `ZeroWord;

        #(CLK_PERIOD);
        
        r_reset = 0;
        r_we = 1;
        r_w_data = 32'h1010;
        r_w_addr = 32'h10;
        #(CLK_PERIOD);
        
        r_w_data = 32'h1010;
        r_w_addr = 32'h18;
        #(CLK_PERIOD);
        
        r_w_data = 32'h1010;
        r_w_addr = 32'h2c;
        #(CLK_PERIOD);
        
        r_we = 0;
        r_w_data = `ZeroWord;
        r_w_addr = `ZeroWord;
        #(CLK_PERIOD*50);

        $finish(0);
     end

endmodule