.global _boot
.text

_boot:
    /* Test XOR */
    addi x1 , x0 , 100
	addi x2 , x0 , 7
	xor x3 , x1 , x2			# 1100100 ^ 0000111 = 1100011

end:
    j end                     # infinite loop
