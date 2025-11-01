.global _boot
.text

_boot:
    /* Test LW */
    li x1 , 0x12345678
    sw x1 , 0(x0)
    lb x2 , 0(x0)
    lh x3 , 0(x0)
    lw x4 , 0(x0)
    
end:
	j end
