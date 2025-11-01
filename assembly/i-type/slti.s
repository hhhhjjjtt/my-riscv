.global _boot
.text

_boot:
    /* Test SLTI */
    addi x1 , x0 , -5
	slti x2 , x1 , -2       # expected: x2 == 0x1

    addi x3 , x0 , -2048
	slti x4 , x3 , 2047     # expected: x4 == 0x1
    
    addi x5 , x0 , 2047
	slti x6 , x5 , -2048    # expected: x6 == 0x0
    
    addi x7 , x0 , 0
	slti x8 , x7 , 0        # expected: x8 == 0x0
    
    addi x9 , x0 , 100
	slti x10 , x9 , 15      # expected: x10 == 0x0

end:
    j end                     # infinite loop
