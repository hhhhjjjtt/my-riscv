.global _boot
.text

_boot:
    /* Test OR */
    addi x1 , x0 , 100
    addi x2 , x0 , 27
	or x3 , x1 , x2

end:
    j end                     # infinite loop
