.global _boot
.text

_boot:
    /* Test SLL */
    addi x1 , x0 , 1
	addi x2 , x0 , 33
	sll x3 , x1 , x2		# x2[4:0] = 0x1, so x3=0x10

end:
    j end                     # infinite loop
