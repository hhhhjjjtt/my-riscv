`define InstAddrBus     31:0
`define InstDataBus     31:0

// reset
`define ResetEnable     1'b1
`define ResetDisable    1'b0

// ce
`define ChipEnable      1'b1
`define ChipDisable     1'b0

// we
`define WriteEnable     1'b1
`define WriteDisable    1'b0

// jump
`define JumpEnable      1'b1

// hold
`define HoldFlagBus     2:0
`define Hold_None       3'b000
`define Hold_PC         3'b001
`define Hold_IF         3'b010
`define Hold_ID         3'b100

// regs
`define RegsAddrBus     4:0
`define RegsDataBus     31:0
`define RegsNum         32

`define Reg0Addr        5'b0
`define ZeroWord        32'b0

// inst_rom
`define ROMAddrBus      InstAddrBus
`define ROMDataBus      InstDataBus
`define ROMNum          4096

// data_ram
`define RAMAddrBus      31:0
`define RAMDataBus      31:0
`define RAMNum          4096
