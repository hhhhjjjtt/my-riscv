.global _boot
.text

_boot:
    /* Test SUB */
    addi x1 , x0 , 17
	addi x2 , x0 , -8
    sub x3 , x1 , x2			# 25
    
    sub x3 , x2 , x2
    
    sub x2 , x2 , x2
    
end:
    j end                     # infinite loop
