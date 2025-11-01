.global _boot
.text

_boot:
    /* Test BNE */
    addi x1 , x0 , 5
    addi x2 , x0 , 5
    addi x3 , x0 , 2
	bne x1 , x2 , target1   # should not jump
    bne x1 , x3 , target2   # should jump
    addi x4 , x0 , 1        # should not execute
    j end

target1:
    addi x4 , x0 , 5        # should not go here
    j end

target2:
    addi x4 , x0 , 9        # x4 should end up being 0x9
    j end

end:
    j end
