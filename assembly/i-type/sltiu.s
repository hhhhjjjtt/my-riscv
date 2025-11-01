.global _boot
.text

_boot:
    /* Test SLTI */
    addi x1 , x0 , -5
	sltiu x2 , x1 , -2
    
    addi x3 , x0 , 1
	sltiu x4 , x3 , 0
    
    addi x5 , x0 , 0
	sltiu x6 , x5 , 1

end:
    j end                     # infinite loop
