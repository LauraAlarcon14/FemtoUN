OUTPUT_ARCH( "riscv" )

SECTIONS
  {
    . = 0x00000000;         /* Forzar el inicio en la dirección cero de la BRAM */
    
    .text : {
        start.o(.text)     /* ¡CRÍTICO! Obliga a que el código de start.o vaya PRIMERO */
        *(.text*)          /* Luego coloca el resto del código (main, multiplicar, etc.) */
        *(.rodata*)        /* Cadenas de texto y constantes */
    }
    
    .data : { *(.data*) }  /* Sección de datos */
    .bss  : { *(.bss*)  }  /* Sección bss */
    _end = .;
}