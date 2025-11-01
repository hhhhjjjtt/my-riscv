.global _boot
.text

_boot:
    /* Test XORI */
    addi x1 , x0 , 100      /* x1 = 1100100 */
	xori x2 , x1 , 7        /* x2 = x1 ^ 0000111, should be 1100011 */

end:
    j end                     # infinite loop
