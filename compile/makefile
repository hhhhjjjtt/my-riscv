AS       = riscv-none-elf-as
OBJCOPY  = riscv-none-elf-objcopy
OBJDUMP  = riscv-none-elf-objdump
HEXDUMP  = hexdump

# ---- Target and input ----
SRC  = inst_rom.s
ELF  = $(SRC:.s=.elf)
BIN  = $(SRC:.s=.bin)
HEX  = $(SRC:.s=.hex)
DUMP = $(SRC:.s=.dump)

# ---- Assembler flags ----
ARCH  = -march=rv32i
ABI   = -mabi=ilp32

all: $(HEX) $(DUMP)

# .s → .elf
$(ELF): $(SRC)
	$(AS) $(ARCH) -o $@ $<

# .elf → .bin
$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

# .bin → .hex
$(HEX): $(BIN)
	$(HEXDUMP) -v -e '1/4 "%08x\n"' $< > $@
	@echo "Generated $@"

# .elf → .dump disassembly
$(DUMP): $(ELF)
	$(OBJDUMP) -d $< > $@
	@echo "Generated $@"

# ---- Cleanup ----
clean:
	rm -f $(ELF) $(BIN) $(HEX) $(DUMP)

# ---- Phony targets ----
.PHONY: all clean
