.global _boot
.text

_boot:
    /* Test SLLI */
    addi x1 , x0 , 1
	slli x2 , x1 , 5
    
    addi x3 , x0 , 1
	slli x4 , x3 , 8
    
    addi x5 , x0 , 2
	slli x6 , x5 , 2

end:
    j end                     # infinite loop
