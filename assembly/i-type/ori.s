.global _boot
.text

_boot:
    /* Test ORI */
    addi x1 , x0 , 100      /* x1 = 1100100 */
	ori x2 , x1 , 27        /* x2 = x1 || 0011011, should be 1111111 */
