.section .text
.global _inicio
_inicio:
    li sp, 0x00007FF0
    j main
loop:
    j loop