.global _boot
.text

_boot:
    /* Test SLTI */
    addi x1 , x0 , -8
	srai x2 , x1 , 3
    
    addi x3 , x0 , -1
	srai x4 , x3 , 8
    
    addi x5 , x0 , -16
	srai x6 , x5 , 2

end:
    j end                     # infinite loop
