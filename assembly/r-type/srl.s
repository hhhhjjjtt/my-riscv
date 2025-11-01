.global _boot
.text

_boot:
    /* Test SRL */
    addi x1 , x0 , -1
	addi x2 , x0 , 31
	srl x3 , x1 , x2

    addi x2 , x0 , 30
    srl x3 , x1 , x2
    
    addi x2 , x0 , 29
    srl x3 , x1 , x2

end:
    j end                     # infinite loop
