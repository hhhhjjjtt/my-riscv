/*  data ram
-   4096 * 32bit addresses
-   store data
*/

`include "defines.v"

module data_ram (
    input wire                  i_Clk,
    input wire                  i_reset,

    input wire[1:0]             i_mem_len, 

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

    localparam RAM_BASE = 32'h0000_4000;
    localparam RAM_TOP = 32'h0000_8000;
    wire[`RAMAddrBus] w_addr = (i_w_addr >= RAM_BASE) && (i_w_addr < RAM_TOP) ? (i_w_addr - RAM_BASE) : i_w_addr;
    wire[`RAMAddrBus] r_addr = (i_r_addr >= RAM_BASE) && (i_r_addr < RAM_TOP) ? (i_r_addr - RAM_BASE) : i_r_addr;

    reg[`RAMDataBus] rams[0:`RAMNum - 1];

    // initialize
    integer i;
    initial begin
        for (i = 0; i < `RAMNum; i = i + 1) begin
            rams[i] = `ZeroWord;
        end
        $readmemh ( "data_ram.mem", rams);
    end

    // Write
    always @(posedge i_Clk) begin
        if (i_we == `WriteEnable) begin
            case (i_mem_len)
                `mem_len_word: begin    // word
                    rams[w_addr[31:2]] <= i_w_data;
                end
                `mem_len_half: begin    // half
                    if (w_addr[1] == `mem_half_index_0) begin
                        rams[w_addr[31:2]] <= {rams[w_addr[31:2]][31:16], i_w_data[15:0]};
                    end
                    else begin
                        rams[w_addr[31:2]] <= {i_w_data[15:0], rams[w_addr[31:2]][15:0]};
                    end
                end
                `mem_len_byte: begin    // byte
                    case (w_addr[1:0])
                        `mem_byte_index_0: begin    // index 0
                            rams[w_addr[31:2]] <= {rams[w_addr[31:2]][31:8], i_w_data[7:0]};
                        end
                        `mem_byte_index_1: begin    // index 1
                            rams[w_addr[31:2]] <= {rams[w_addr[31:2]][31:16], i_w_data[7:0], rams[w_addr[31:2]][7:0]};
                        end
                        `mem_byte_index_2: begin    // index 2
                            rams[w_addr[31:2]] <= {rams[w_addr[31:2]][31:24], i_w_data[7:0], rams[w_addr[31:2]][15:0]};
                        end
                        `mem_byte_index_3: begin    // index 3
                            rams[w_addr[31:2]] <= {i_w_data[7:0], rams[w_addr[31:2]][23:0]};
                        end
                        default: begin  // index 0
                            rams[w_addr[31:2]] <= {rams[w_addr[31:2]][31:8], i_w_data[7:0]};
                        end
                    endcase
                end
                default: begin  // word
                    rams[w_addr[31:2]] <= i_w_data;
                end
            endcase
        end
    end

    // always @ (posedge i_Clk) begin
    //     if (i_reset == `ResetEnable) begin
    //         o_r_data <= `ZeroWord;
    //         o_r_addr <= `ZeroWord;
    //     end
    //     else begin
    //         case (i_mem_len)
    //             2'b00: begin    // word
    //                 o_r_data <= rams[i_r_addr[31:2]];
    //             end
    //             2'b01: begin    // half
    //                 if (i_r_addr[1] == 1'b0) begin
    //                     o_r_data <= {16{0}, rams[i_r_addr[31:2]][15:0]};
    //                 end
    //                 else begin
    //                     o_r_data <= {16{0}, rams[i_r_addr[31:2]][31:16]};
    //                 end
    //             end
    //             2'b10: begin    // byte
    //                 case (i_r_addr[1:0])
    //                     2'b00: begin    // index 0
    //                         o_r_data <= {24{0}, rams[i_r_addr[31:2]][7:0]};
    //                     end
    //                     2'b01: begin    // index 1
    //                         o_r_data <= {24{0}, rams[i_r_addr[31:2]][15:8]};
    //                     end
    //                     2'b10: begin    // index 2
    //                         o_r_data <= {24{0}, rams[i_r_addr[31:2]][23:16]};
    //                     end
    //                     2'b11: begin    // index 3
    //                         o_r_data <= {24{0}, rams[i_r_addr[31:2]][31:24]};
    //                     end
    //                     default: begin  // index 0
    //                         o_r_data <= {24{0}, rams[i_r_addr[31:2]][7:0]};
    //                     end
    //                 endcase
    //             end
    //             default: begin
    //                 o_r_data <= rams[i_r_addr[31:2]];
    //             end
    //         endcase
    //         o_r_addr <= i_r_addr;
    //     end
    // end
    
    // always @(posedge i_Clk) begin
    //     if (i_we == `WriteEnable) begin
    //         rams[i_w_addr[31:2]] <= i_w_data;
    //     end
    // end

    // Read
    always @ (posedge i_Clk or posedge i_reset) begin
        if (i_reset == `ResetEnable) begin
            o_r_data <= `ZeroWord;
            o_r_addr <= `ZeroWord;
        end
        else begin
            /*  no address will start at 0x1, 0x2, 0xB...
                All address must be 4's multiple
                so we have i_r_addr[31:2] that only capture
                0x0, 0x4, 0x8, 0xC, 0x10...
            */
            o_r_data <= rams[r_addr[31:2]];    
            o_r_addr <= i_r_addr;
        end
    end
    
endmodule
