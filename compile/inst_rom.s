.global _boot
.text

_boot:
    /* Test BGEU (unsigned) */
    addi x1 , x0 , -1        # x1 = 0xFFFFFFFF (unsigned = 4294967295)
    addi x2 , x0 , 5         # x2 = 0x00000005
    bgeu x1 , x2 , target1   # 0xFFFFFFFF >= 5 → should jump
    addi x3 , x0 , 1         # should not execute
    j end

target1:
    addi x3 , x0 , 9
    bgeu x2 , x3 , target2   # 5 >= 9? → not taken
    bgeu x3 , x2 , target3   # 9 >= 5 → should jump
    j end

target2:
    addi x3 , x0 , 5         # should not execute
    j end

target3:
    addi x3 , x0 , 3         # x3 should end up being 0x3
    j end

end:
    j end
