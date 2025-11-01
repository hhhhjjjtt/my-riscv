.global _boot
.text

_boot:
    /* Test ADD */
    addi x1 , x0 , -8
	addi x2 , x0 , 17
    add x3 , x1, x2			# 9
	add x3 , x2, x2			# 34
    add x3, x1 , x1         # -16
    
    addi x1 , x0, 2047
    addi x2 , x0 , 1
    add x3 , x1 , x2

end:
    j end                     # infinite loop
