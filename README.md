# my-riscv

**Experimental Project.** This repository documents my personal exploration into RISC-V processor design. The implementation may contain errors or incomplete features and is therefore not intended for formal educational use.

## Overview

A simple three-stage pipelined RISC-V CPU implementing the RV32I instruction set architecture (ISA).

## References and Inspirations

This project draws heavily from the following resources:

- `tinyriscv`: https://github.com/liangkangnan/tinyriscv
    - `my-riscv` can be viewed as a simplified version of `tinyriscv`, focusing solely on the CPU core.
    - Peripherals such as UART, SPI, and JTAG are excluded.
    - The instruction ROM and data RAM fetch processes have been simplified.
    - 

- `OPENMIPS`: from the book _自己动手写CPU_ _(write a CPU yourself)_

- `NJUCS 2023 Digital Logic and Computer Organization` Course Project: https://nju-projectn.github.io/dlco-lecture-note/exp/11.html




