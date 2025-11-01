.global _boot
.text

_boot:
    /* Test JALR */
    addi a0 , x0 , 100
    addi a1 , x0 , 2
	jal ra , add_numbers
    addi a2 , a0 , 0        # a2 = 102
stop:
    j stop                  # infinite loop (halts execution)

add_numbers:
    add a0 , a0 , a1
    jalr zero , 0(ra)
