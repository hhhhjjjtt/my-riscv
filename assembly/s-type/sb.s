.global _boot
.text

_boot:
    /* Test SB (store byte) */
    li x1 , 0x22221234
    j end                   # infinite loop

end:
    j end
