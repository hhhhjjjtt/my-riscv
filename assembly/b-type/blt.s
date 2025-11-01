.global _boot
.text

_boot:
    /* Test BLT */
    addi x1 , x0 , 4
    addi x2 , x0 , 5
	blt x1 , x2 , target1   # should jump
    addi x3 , x0 , 1        # should not execute
    j end

target1:
    addi x3 , x0 , 9        
    blt x1 , x3 , target2   # should jump
    j end

target2:
    addi x3 , x0 , 3        # x3 should end up being 0x3
    j end

end:
    j end
