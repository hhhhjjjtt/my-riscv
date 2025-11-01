.global _boot
.text

_boot:
    /* Test SW (store word) */
    addi x1 , x0 , 0
    addi x2 , x0 , 0x123    # x2 = 0x00000123
    sw x2 , 0(x1)           # store x2 -> data[0]
    sw x2 , 4(x1)           # store x2 -> data[1]
    sw x2 , 8(x1)           # store x2 -> data[2]
    addi x3 , x0 , 0x456
    sw x3 , 8(x1)           # store x3 -> data[2]
    sw x3 , 0xc(x1)         # store x3 -> data[3]
    sw x3 , 0x10(x1)        # store x3 -> data[4]
    j end                   # infinite loop

end:
    j end
