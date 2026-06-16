// main DEBE ser la primera función para que el procesador arranque aquí
int main() {
    // 1. INICIALIZAR LA MEMORIA TEMPORAL (Stack Pointer)
    // Le decimos al procesador que su memoria RAM termina en el byte 1024 (0x0400)
    asm volatile("li sp, 0x00000400");

    // 2. DIRECCIONES DEL HARDWARE
    volatile int *uart_data = (volatile int *)0x00400008;
    volatile int *uart_ctrl = (volatile int *)0x00400010;
    
    // Usamos corchetes [] para obligar al procesador a guardar el texto en la memoria segura
    char mensaje[] = "femto riscv corriendo\r\n";

    while (1) {
        char *letra = mensaje;
        while (*letra) {
            *uart_data = *letra;       // Cargar letra
            *uart_ctrl = 1;            // Disparar
            *uart_ctrl = 0;            // Soltar
            letra++;
            
            // Pausa corta integrada para darle tiempo al cable
            for (volatile int i = 0; i < 20000; i++); 
        }
        // Pausa larga integrada antes de repetir el mensaje
        for (volatile int j = 0; j < 500000; j++); 
    }
    return 0;
}