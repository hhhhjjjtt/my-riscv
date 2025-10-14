`define InstAddrBus     31:0
`define InstDataBus     31:0

// reset
`define ResetEnable     1'b1
`define ResetDisable    1'b0

// regs
`define RegsAddrBus     4:0
`define RegsDataBus     31:0
`define RegsNum         32

`define Reg0Addr        5'b0
`define ZeroWord        32'b0

// hold
`define HoldFlagBus     2:0
`define Hold_None       3'b000
`define Hold_PC         3'b001
`define Hold_IF         3'b010
`define Hold_ID         3'b100
