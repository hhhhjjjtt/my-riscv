.global _boot
.text

_boot:
    /* Test JAL */
    jal loop
    nop 
    nop 

loop:
    nop 
    nop
    jal loop
