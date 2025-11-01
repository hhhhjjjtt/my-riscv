.global _boot
.text

_boot:
    /* Test LUI (Load Upper Immediate) */

    lui x1 , 0x12345          # x1 = 0x12345000
    addi x2 , x0 , 0x678        # x2 = 0x00000678
    add x3 , x1 , x2           # x3 = 0x12345678

end:
    j end                     # infinite loop
