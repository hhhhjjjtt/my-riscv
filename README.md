# my-riscv

**Experimental Project.** This repository documents my personal exploration into RISC-V processor design. Not intended for formal educational use, but you can use this as a reference of how a beginner attempts to learn building a RISC-V cpu.

## References, Credits and Inspirations

`my-riscv` draws heavily from the following resources:

- `tinyriscv`: https://github.com/liangkangnan/tinyriscv
    - `my-riscv`'s core design logic is based on the 3-stage pipeline structure of `tinyriscv`. that is targeted on simplicity, focusing solely on the CPU core. The instruction ROM and data RAM fetch processes have been simplified, and peripherals such as UART, SPI, and JTAG are excluded.
    - Removed interconnect bus and the total pipeline stall comes with fetching from instruction rom and data ram over interconnect bus. 
    - Instruction rom and data ram is tightly coupled with the pipeline.

- `picorv32`: https://github.com/YosysHQ/picorv32
    - RISC-V have its own official tests: https://github.com/riscv-software-src/riscv-tests. However, I personally found it to be a little hard to build.
    - In a blog about building RISC-V cpu: https://www.ustcpetergu.com/MyBlog/experience/2021/07/09/about-riscv-testing.html, I discovered this modified version of the official test under `picorv32`'s test cases.
    - Based on tests in `picorv32`, I made a more simplified version of tests and applied the automated tests to `my-riscv`.

- `OPENMIPS`: from the book _write a CPU yourself_ https://github.com/yufeiran/OpenMIPS
    - Referenced how other cpu's are made in verilog, act as a complement to `tinyriscv`

- `NJUCS 2023 Digital Logic and Computer Organization` Course Project: https://nju-projectn.github.io/dlco-lecture-note/exp/11.html
    - Provided decent amount of information about building a single-cycle rv32i cpu, especially setting up automated tests in systemverilog.

## Overview

`my-riscv` is a simple single-core, single-issue, in-order, 3-stage pipelined RISC-V CPU implementing the RV32I instruction set architecture (ISA).
![Alt text](img/pipeline.png)

An overview of the hdl sources is as follows:

`my_riscv_top.v`: The top module of `my-riscv`

`defines.v`: Defines Macros like buses, opcodes, funct3/7, the 16‑bit control encoding, etc.

`pc.v`: PC pointer register. Have three behaviors: jump, hold, or PC+4.
- Sequential logic

`inst_rom.v`: Instruction rom, maps to address `0x0000` to `0x3999`. Able to do syncronous read and write; memories with addr[31:2] drop (enforces word alignment).
- Sequential logic

`data_ram.v`: Data ram, maps to address `0x4000` to `0x7999`. Able to do syncronous read and write; memories with addr[31:2] drop (enforces word alignment).
- Sequential logic

`regs.v`: 32×32 regfile, synchronous write, combinational reads with simple WB‑bypass.
- Combinational logic

`id.v`: Decoder builds immediates (I/S/B/U/J), selects ALU ops, sets branch class, memory width/sign, and MemToReg.
- Combinational logic

`if_id.v`: Pipeline latch between **if** and **id**. Flush and hold behavior is controlled by `hold_ctrl.v`. Instruction Rom is integrated inside of `if_id.v` instead of placing along with `pc.v` before `if_id.v` it to prevent an extra clock cycle in **id** stage.
- Sequential logic

`id_ex.v`: Pipeline latch between **id** and **ex**. Flush and hold behavior is controlled by `hold_ctrl.v`. 
- Sequential logic

`ex.v`: handles the ALU; branch target/decision; data‑width packing/unpacking for loads/stores; extra load/WB two‑beat register; hazard control
- Mainly combinational logic, but with a sequential logic load register that stores the load instruction (destination register address/write enable/write width/write source) during load operation

`hold_ctrl.v`: translates EX’s general hold flag `{load_en, branch_en}` into the specific hold/flush flags for each stage.
- Combinational logic

## RISC-V Toolchain Setup

To turn RV32I assembly into the hex image for inst_rom, install a RISC-V toolchain on either Windows or Ubuntu. I mostly work on Windows (that’s where my project files live).

### Windows setup
Follow the instruction in The xPack GNU RISC-V Embedded GCC: https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack.

I personally used the global install mentioned in project website's Installation instruction page.

### Ubuntu setup
You can choose to build the toolchain yourself following the official instruction https://github.com/riscv-collab/riscv-gnu-toolchain

Or, to use a prebuit toolchain: https://github.com/stnolting/riscv-gcc-prebuilt

#### To setup the prebuilt toolchain in `Prebuilt RISC-V GCC Toolchains for Linux`:

First, download the package:

```
wget https://github.com/stnolting/riscv-gcc-prebuilt/releases/download/rv32i-131023/riscv32-unknown-elf.gcc-13.2.0.tar.gz
```

Then extract:

```
sudo mkdir -p /opt/riscv
sudo tar -xzf riscv32-unknown-elf.gcc-13.2.0.tar.gz -C /opt/riscv/
```

Then add the toolchain `bin` to your PATH:

```
export PATH="$PATH:/opt/riscv/bin"
```

Or to make it permanent, you can go:
```
nano ~/.bashrc
```

Then scroll to bottom to this shell's startup files, and add a new line there:
```
# Add RISC-V toolchain to PATH
export PATH=$PATH:/opt/riscv/bin
```
## Compile Tests

Under `/test`, run:

```
make
```

And the test source codes will be compiled into hex code in `.mem` files under `/test/mem/inst_rom` and `/test/mem/data_ram`.

## Automated Tests

In Vivado:

1. Add all .v files ulder `/hdl` to your Design Sources.
2. Compile the test cases, then add all `.mem` files under `/test/mem/inst_rom` and `/test/mem/data_ram` to your Design Sources.
3. Add `tb_my_riscv_03.sv` to your Simulation Sources.
4. Click "Run Simulation" -> "Run Behavioral Simulation"

## Data Hazard Handeling

- **Control (branch/jump)**: resolved in EX
    - When a branch or jump is taken in EX, `ex.v` sends a branch signal to `hold_ctrl.v`. 
    - On the next cycle, `pc.v` jumps to the target, and both `if_id.v` and `id_ex.v` are flushed to `NOP`. In a 3-stage pipe this inserts **two bubbles in the wrong-path instructions sitting in IF and ID**.

- **Load-Use (data)**: handled in EX stage
    - When there is a load detected, `ex.v` sends a pipeline hold signal to `hold_ctrl.v`.
    - On the next cycle, `pc.v` and `if_id.v` will hold on to its current output value, while `id_ex.v` will be flushed to `NOP`. Which is equavalent to **waiting for the data loaded from the data ram to be written to the register files**.

- **Read after Write (data)**: handled in register file
    - Simple RAWs between back-to-back ALU ops are handled in the register file via a combinational bypass
    - If a read address equals the write address while we is asserted, **the read returns the pending write data**.

## To Do
- Revise comments
- FPGA
