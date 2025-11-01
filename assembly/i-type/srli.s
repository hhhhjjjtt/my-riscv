.global _boot
.text

_boot:
    /* Test SRLI */
    addi x1 , x0 , 8
	srli x2 , x1 , 3		# 0x1
    
    addi x3 , x0 , 1
	srli x4 , x3 , 8		# 0x0
    
    addi x5 , x0 , 16
	srli x6 , x5 , 2		# 0x4

end:
    j end                     # infinite loop
