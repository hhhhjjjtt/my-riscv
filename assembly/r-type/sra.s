.global _boot
.text

_boot:
    /* Test SRA */
    addi x1 , x0 , -1
	addi x2 , x0 , 31
	sra x3 , x1 , x2

    addi x2 , x0 , 30
    sra x3 , x1 , x2
    
    addi x2 , x0 , 29
    sra x3 , x1 , x2

end:
    j end                     # infinite loop
