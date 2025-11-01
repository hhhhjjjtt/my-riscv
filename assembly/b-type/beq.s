.global _boot
.text

_boot:
    /* Test BEQ */
    addi x1 , x0 , 5
    addi x2 , x0 , 5
	beq x1 , x2 , target    # should jump
    addi x3 , x0 , 1        # should not execute
    j end

target:
    addi x3 , x0 , 9        # x3 should end up being 0x9
    beq x1 , x3 , fake_target
    j end

fake_target:
    addi x3 , x0 , 3        # should not go here
    j end

end:
    j end
