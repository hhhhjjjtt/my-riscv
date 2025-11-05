# ---- Toolchain ----
AS      = riscv-none-elf-gcc
LD      = riscv-none-elf-gcc
OBJCOPY = riscv-none-elf-objcopy
OBJDUMP = riscv-none-elf-objdump
HEXDUMP = hexdump

# ---- Flags ----
ARCH   = -march=rv32i
ABI    = -mabi=ilp32
CFLAGS = $(ARCH) $(ABI) -I .
LDFLAGS = -T linker.ld -nostdlib -nostartfiles -Wl,--gc-sections,--no-relax

# ---- Sources / Targets ----
SRCS      := $(wildcard *.S)
OBJS      := $(SRCS:.S=.o)
ELFS      := $(SRCS:.S=.elf)

MEM_DIR   := mem
INST_DIR  := $(MEM_DIR)/inst_rom
DATA_DIR  := $(MEM_DIR)/data_ram

# base names without extension (e.g., test from test.S)
BASENAMES := $(SRCS:.S=)

INST_MEM  := $(addprefix $(INST_DIR)/,$(addsuffix _inst_rom.mem,$(BASENAMES)))
DATA_MEM  := $(addprefix $(DATA_DIR)/,$(addsuffix _data_ram.mem,$(BASENAMES)))

.SECONDARY: $(ELFS)

# Default
all: $(INST_MEM) $(DATA_MEM)

# Ensure folders exist (order-only prerequisites)
$(INST_MEM): | $(INST_DIR)
$(DATA_MEM): | $(DATA_DIR)

$(INST_DIR) $(DATA_DIR):
	@mkdir -p $@

# ---- Build ----
%.o: %.S riscv_test.h test_macros.h
	$(AS) -c $(CFLAGS) -o $@ $<

%.elf: %.o linker.ld
	$(LD) $< $(LDFLAGS) -o $@

# ---- .text -> mem/inst_rom/<name>_inst_rom.mem ----
$(INST_DIR)/%_inst_rom.mem: %.elf
	$(OBJCOPY) -O binary --only-section=.text $< $@.bin
	$(HEXDUMP) -v -e '1/4 "%08x\n"' $@.bin > $@
	@rm -f $@.bin
	@echo "Generated $@"

# ---- .data+.sdata -> mem/data_ram/<name>_data_ram.mem ----
$(DATA_DIR)/%_data_ram.mem: %.elf
	$(OBJCOPY) -O binary --only-section=.data --only-section=.sdata $< $@.bin
	$(HEXDUMP) -v -e '1/4 "%08x\n"' $@.bin > $@
	@rm -f $@.bin
	@echo "Generated $@"

clean:
	rm -f $(OBJS) $(ELFS)
	rm -rf $(MEM_DIR)

.PHONY: all clean
