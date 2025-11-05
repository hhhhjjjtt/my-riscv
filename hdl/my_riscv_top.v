module my_riscv_top (
    input wire      i_Clk,
    input wire      i_reset
);

    // pc    
    wire[`InstAddrBus]      w_pc_o_pc_addr;
    pc pc_0(
        .i_Clk(i_Clk),
        .i_reset(i_reset),

        // from ex
        .i_hold_flag(w_hold_ctrl_o_hold_flag[3]),
        .i_jump_flag(w_hold_ctrl_o_jump_flag),
        .i_jump_addr(w_hold_ctrl_o_jump_addr),

        // to inst_rom and if_id
        .o_pc_addr(w_pc_o_pc_addr)
    ); 

    // if_id
    wire[`InstAddrBus]      w_if_id_o_pc_addr;
    wire[`InstDataBus]      w_if_id_o_inst_data;
    if_id if_id_0(
        .i_Clk(i_Clk),
        .i_reset(i_reset),

        .i_pc_addr(w_pc_o_pc_addr),

        .i_hold_flag(w_hold_ctrl_o_hold_flag[2:1]),

        .o_pc_addr(w_if_id_o_pc_addr),
        .o_inst_data(w_if_id_o_inst_data)
    );

    // id
    wire[`RegsAddrBus]    w_id_o_reg1_r_addr;
    wire[`RegsAddrBus]    w_id_o_reg2_r_addr; 
    wire[`InstAddrBus]    w_id_o_pc_addr;
    wire[`InstDataBus]    w_id_o_inst_data;
    wire[`RegsDataBus]    w_id_o_reg1_data;
    wire[`RegsDataBus]    w_id_o_reg2_data;
    wire[`RegsAddrBus]    w_id_o_regd_addr;
    wire[`ImmDataBus]     w_id_o_imm_data;
    wire[`CtrlBus]        w_id_o_ctrl;
    id id_0(
        .i_reset(i_reset),
        
        // from if_id
        .i_pc_addr(w_if_id_o_pc_addr),
        .i_inst_data(w_if_id_o_inst_data),

        // from regs
        .i_reg1_r_data(w_regs_o_r_data1),
        .i_reg2_r_data(w_regs_o_r_data2),

        // to regs
        .o_reg1_r_addr(w_id_o_reg1_r_addr),
        .o_reg2_r_addr(w_id_o_reg2_r_addr),

        // to id_ex
        .o_pc_addr(w_id_o_pc_addr),
        .o_inst_data(w_id_o_inst_data),
        .o_reg1_data(w_id_o_reg1_data),
        .o_reg2_data(w_id_o_reg2_data),
        .o_regd_addr(w_id_o_regd_addr),
        .o_imm_data(w_id_o_imm_data),
        .o_ctrl(w_id_o_ctrl)
    );

    // regs
    wire[`RegsDataBus]      w_regs_o_r_data1;
    wire[`RegsDataBus]      w_regs_o_r_data2;
    regs regs_0(
        .i_Clk(i_Clk),
        .i_reset(i_reset),

        // from ex
        .i_we(w_ex_o_regd_we),     
        .i_w_addr(w_ex_o_regd_w_addr), 
        .i_w_data(w_ex_o_regd_w_data), 

        // from id
        .i_r_addr1(w_id_o_reg1_r_addr),
        .i_r_addr2(w_id_o_reg2_r_addr),

        // to id
        .o_r_data1(w_regs_o_r_data1),
        .o_r_data2(w_regs_o_r_data2) 
    );

    // id_ex
    wire[`InstAddrBus]    w_id_ex_o_pc_addr;
    wire[`InstDataBus]    w_id_ex_o_inst_data;
    wire[`RegsDataBus]    w_id_ex_o_reg1_data;
    wire[`RegsDataBus]    w_id_ex_o_reg2_data;
    wire[`RegsAddrBus]    w_id_ex_o_regd_addr;
    wire[`ImmDataBus]     w_id_ex_o_imm_data;
    wire[`CtrlBus]        w_id_ex_o_ctrl;
    id_ex id_ex_0(
        .i_Clk(i_Clk),
        .i_reset(i_reset),

        .i_pc_addr(w_id_o_pc_addr),
        .i_inst_data(w_id_o_inst_data),
        .i_reg1_data(w_id_o_reg1_data),
        .i_reg2_data(w_id_o_reg2_data),
        .i_regd_addr(w_id_o_regd_addr),
        .i_imm_data(w_id_o_imm_data),
        .i_ctrl(w_id_o_ctrl),

        .i_hold_flag(w_hold_ctrl_o_hold_flag[0]),

        .o_pc_addr(w_id_ex_o_pc_addr),  
        .o_inst_data(w_id_ex_o_inst_data),
        .o_reg1_data(w_id_ex_o_reg1_data),
        .o_reg2_data(w_id_ex_o_reg2_data),
        .o_regd_addr(w_id_ex_o_regd_addr),
        .o_imm_data(w_id_ex_o_imm_data), 
        .o_ctrl(w_id_ex_o_ctrl)      
    );

    // ex
    wire                  w_ex_o_regd_we;
    wire[`RegsAddrBus]    w_ex_o_regd_w_addr;
    wire[`RegsDataBus]    w_ex_o_regd_w_data;
    wire                  w_ex_o_mem_we;
    wire[`RAMAddrBus]     w_ex_o_mem_r_addr;
    wire[`RAMAddrBus]     w_ex_o_mem_w_addr;
    wire[`RAMDataBus]     w_ex_o_mem_w_data;
    wire[1:0]             w_ex_o_mem_len;
    wire[`HoldFlagBus]    w_ex_o_hold_type;
    wire                  w_ex_o_jump_flag;
    wire[`InstAddrBus]    w_ex_o_jump_addr;
    ex ex_0(
        .i_Clk(i_Clk),
        .i_reset(i_reset),

        // from id_ex
        .i_pc_addr(w_id_ex_o_pc_addr),    
        .i_inst_data(w_id_ex_o_inst_data),  
        .i_reg1_data(w_id_ex_o_reg1_data),  
        .i_reg2_data(w_id_ex_o_reg2_data),  
        .i_regd_addr(w_id_ex_o_regd_addr),  
        .i_imm_data(w_id_ex_o_imm_data),   
        .i_ctrl(w_id_ex_o_ctrl),    

        // from data_ram   
        .i_mem_r_data(w_data_ram_o_r_data), 
        .i_mem_r_addr(w_data_ram_o_r_addr),

        // to regs
        .o_regd_we(w_ex_o_regd_we),
        .o_regd_w_addr(w_ex_o_regd_w_addr),
        .o_regd_w_data(w_ex_o_regd_w_data),

        // to data_ram
        .o_mem_we(w_ex_o_mem_we),
        .o_mem_r_addr(w_ex_o_mem_r_addr), 
        .o_mem_w_addr(w_ex_o_mem_w_addr), 
        .o_mem_w_data(w_ex_o_mem_w_data), 

        .o_mem_len(w_ex_o_mem_len),

        // to hold_ctrl
        .o_hold_type(w_ex_o_hold_type),
        .o_jump_flag(w_ex_o_jump_flag),
        .o_jump_addr(w_ex_o_jump_addr)
    );

    // data_ram
    wire[`RAMDataBus]     w_data_ram_o_r_data;
    wire[`RAMAddrBus]     w_data_ram_o_r_addr;
    data_ram data_ram_0(
        // .i_ce(r_ce),
        .i_Clk(i_Clk),
        .i_reset(i_reset),

        .i_mem_len(w_ex_o_mem_len),

        // write
        .i_we(w_ex_o_mem_we),
        .i_w_data(w_ex_o_mem_w_data),
        .i_w_addr(w_ex_o_mem_w_addr),

        // read
        .i_r_addr(w_ex_o_mem_r_addr),

        .o_r_data(w_data_ram_o_r_data),
        .o_r_addr(w_data_ram_o_r_addr)
    );

    // hold_ctrl
    wire[`HoldFlagBus]    w_hold_ctrl_o_hold_flag;
    wire                  w_hold_ctrl_o_jump_flag;
    wire[`InstAddrBus]    w_hold_ctrl_o_jump_addr;
    hold_ctrl hold_ctrl_0(
        .i_reset(i_reset),

        // from ex
        .i_hold_type(w_ex_o_hold_type),
        .i_jump_flag(w_ex_o_jump_flag),
        .i_jump_addr(w_ex_o_jump_addr),

        // to pc, if_id, and id_ex
        .o_hold_flag(w_hold_ctrl_o_hold_flag),

        // to pc
        .o_jump_flag(w_hold_ctrl_o_jump_flag),
        .o_jump_addr(w_hold_ctrl_o_jump_addr)
    );

endmodule
