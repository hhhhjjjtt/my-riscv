.global _boot
.text

_boot:
    /* Test LW */
	addi x1 , x0 , 0
    addi x2 , x0 , 0x111    # x2 = 0x111
    sw x2 , 0(x1)           # store x2 -> data[0]
    lw x3 , 0(x1)           # x3 = x2
    add x4 , x3 , x3
	sw x4 , 4(x1)			# store x4 -> data[1]
    lw x5 , 4(x1)
    add x6 , x5 , x5
    lw x7 , 4(x1)
    lw x8 , 4(x1)
    lw x9 , 4(x1)
    
end:
	j end
