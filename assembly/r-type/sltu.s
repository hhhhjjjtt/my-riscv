.global _boot
.text

_boot:
    /* Test SLT */
    addi x1 , x0 , -1
	addi x2 , x0 , 20
	sltu x3 , x1 , x2			# 0
	
    addi x4 , x0 , 2
	addi x5 , x0 , 9
	sltu x6 , x4 , x5			# 1
    
    addi x7 , x0 , 7
	addi x8 , x0 , 7
	sltu x9 , x7 , x8			# 0

end:
    j end                     # infinite loop
