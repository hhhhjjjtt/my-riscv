.global _boot
.text

_boot:
    /* Test BLTU (unsigned) */
    addi x1 , x0 , -1        # x1 = 0xFFFFFFFF (unsigned = 4294967295)
    addi x2 , x0 , 5         # x2 = 0x00000005
    bltu x2 , x1 , target1   # 5 < 0xFFFFFFFF → should jump
    addi x3 , x0 , 1         # should not execute
    j end

target1:
    addi x3 , x0 , 9         
    bltu x1 , x3 , target2   # 0xFFFFFFFF < 9? (unsigned) → NOT jump
    bltu x3 , x1 , target3   # 9 < 0xFFFFFFFF → should jump
    j end

target2:
    addi x3 , x0 , 5         # should not execute
    j end

target3:
    addi x3 , x0 , 3         # x3 should end up being 0x3
    j end

end:
    j end
