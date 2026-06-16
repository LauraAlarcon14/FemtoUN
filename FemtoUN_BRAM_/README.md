# Femto - Testbench para GTKWave

SoC RISC-V (FemtoRV32 Quark) con UART, simulado con Icarus Verilog.

## Requisitos

```
sudo apt install iverilog gtkwave
```

## Uso rápido

```bash
make              # Compilar + simular → genera femtoUN.vcd
gtkwave femtoUN.vcd femtoUN.gtkw   # Abrir con señales pre-configuradas
```

## Comandos disponibles

| Comando        | Descripción                            |
|----------------|----------------------------------------|
| `make`         | Compilar y simular                     |
| `make compile` | Solo compilar                          |
| `make sim`     | Solo simular                           |
| `make wave`    | Abrir GTKWave                          |
| `make clean`   | Limpiar archivos generados             |

## Estructura

```
├── src/
│   ├── firmware.hex         ← Firmware RISC-V (main.c compilado)
│   ├── femtorv_quark.v      ← CPU FemtoRV32 (RV32I)
│   ├── bram_hex.v           ← Block RAM con carga de firmware
│   ├── SOC_bram.v           ← SoC: CPU + BRAM + UART
│   ├── perip_uart.v         ← Periférico UART (wrapper)
│   ├── uart.v               ← UART TX/RX (120000 baud)
│   └── top_tang_bram.v      ← Top-level (Tang Nano 20K)
├── tb/
│   └── tb_femtosebasian.v   ← Testbench con decodificador UART
├── femtoUN.gtkw       ← Configuración GTKWave (señales agrupadas)
└── Makefile
```

## Señales en GTKWave

El archivo `.gtkw` pre-configura estos grupos:

- **Top**: clk, reset, led, uart_tx
- **CPU**: PC, instrucción, máquina de estados, rs1, rs2
- **Bus de Memoria**: dirección, datos R/W, masks, chip selects
- **UART TX**: tx line, busy, registro de datos, bit counter
- **UART RX**: rx line, available, data
- **Periférico UART**: registros internos

## Salida esperada en consola

```
[37753650000] CPU -> UART_DATA = 0x66 ('f')
[55036530000] CPU -> UART_DATA = 0x65 ('e')
[72319410000] CPU -> UART_DATA = 0x6d ('m')
[89602290000] CPU -> UART_DATA = 0x74 ('t')
[106885170000] CPU -> UART_DATA = 0x6f ('o')
...
```

El firmware transmite "femto riscv corriendo\r\n" en bucle infinito.
Cada carácter tarda ~17 ms (delay de 20000 ciclos entre letras).

## Ajustar tiempo de simulación

En `tb/tb_femtoUN.v`, cambiar el parámetro:

```verilog
parameter SIM_TIME_MS = 150;   // ← Subir para ver más caracteres
                                //    450 ms ≈ mensaje completo
                                //    150 ms ≈ primeros 6-7 caracteres
```
