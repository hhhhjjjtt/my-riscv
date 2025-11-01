.global _boot
.text

_boot:
    /* Test AUIPC */
    auipc x1 , 0x1
    auipc x2 , 0x1
    auipc x3 , 0x1

end:
    j end                     # infinite loop
