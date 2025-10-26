# my-riscv

**Experimental Project.** This repository documents my personal exploration into RISC-V processor design. Not intended for formal educational use.

## Overview

A simple three-stage pipelined RISC-V CPU implementing the RV32I instruction set architecture (ISA).

## References and Inspirations

This project draws heavily from the following resources:

- `tinyriscv`: https://github.com/liangkangnan/tinyriscv
    - `my-riscv` can be viewed as a modified version of `tinyriscv` that is targeted on simplicity, focusing solely on the CPU core. The instruction ROM and data RAM fetch processes have been simplified, and peripherals such as UART, SPI, and JTAG are excluded.

- `OPENMIPS`: from the book _write a CPU yourself_ https://github.com/yufeiran/OpenMIPS

- `NJUCS 2023 Digital Logic and Computer Organization` Course Project: https://nju-projectn.github.io/dlco-lecture-note/exp/11.html




