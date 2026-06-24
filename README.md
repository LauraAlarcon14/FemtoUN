# FEMTO_UN

## Implementación de un Procesador Softcore RISC-V FemtoRV32 sobre FPGA Tang Primer 20K

FEMTO_UN es un proyecto de grado desarrollado en la Universidad Nacional de Colombia que implementa un Sistema en Chip (SoC) basado en la arquitectura abierta **RISC-V**, utilizando el procesador softcore **FemtoRV32** sobre una FPGA **Tang Primer 20K**.

El proyecto abarca desde la construcción de una plataforma base con memoria y comunicación serial, hasta la implementación de un bootloader capaz de cargar aplicaciones desde una tarjeta MicroSD hacia memoria PSRAM externa.

---

## Características principales

- Arquitectura RISC-V RV32I.
- Procesador softcore FemtoRV32 (versión Quark).
- Memoria BRAM de 32 KiB.
- Comunicación UART mapeada en memoria.
- Simulación y verificación funcional en Verilog.
- Desarrollo de firmware embebido en C y Assembly.
- Implementación sobre FPGA Tang Primer 20K.
- Soporte para MicroSD mediante SPI.
- Soporte para memoria externa HyperRAM / PSRAM.
- Bootloader para carga de aplicaciones externas.

---

## Arquitectura del Sistema

El SoC está compuesto por:

- CPU FemtoRV32
- Memoria BRAM
- Periférico UART
- Bus de memoria compartido
- Controlador SPI (Bootloader)
- Adaptador de PSRAM (Bootloader)

```text
                +----------------+
                |   FemtoRV32    |
                +--------+-------+
                         |
                  Bus de Memoria
                         |
      +------------------+------------------+
      |                                     |
+-----v-----+                       +-------v------+
|   BRAM    |                       |    UART      |
+-----------+                       +--------------+

           (Proyecto Bootloader)

      +------------------+------------------+
      |                                     |
+-----v-----+                       +-------v------+
|    SPI    |                       |    PSRAM     |
+-----------+                       +--------------+
```

---

## Proyectos incluidos

### Proyecto 1 — Verificación UART

Validación de la comunicación serial mediante un programa de eco ASCII.

Funciones:

- Recepción de caracteres desde terminal serial.
- Transmisión de caracteres.
- Verificación de códigos ASCII.
- Pruebas de comunicación bidireccional.

---

### Proyecto 2 — Calculadora Básica

Aplicación embebida que recibe dos números por UART y realiza operaciones aritméticas.

Características:

- Entrada de datos por terminal.
- Conversión ASCII → entero.
- Implementación sin multiplicación ni división por hardware.
- Salida de resultados por UART.

---

### Proyecto 3 — FemtoUN Boot

Bootloader para carga de aplicaciones desde una tarjeta MicroSD.

Características:

- Inicialización de tarjeta SD mediante SPI.
- Lectura de sectores.
- Carga de programas en PSRAM.
- Transferencia de ejecución a memoria externa.
- Expansión de capacidad desde 32 KiB hasta 8 MB.

---

## Hardware Utilizado

| Componente | Descripción |
|------------|------------|
| FPGA | Tang Primer 20K |
| FPGA Device | Gowin GW2A-LV18PG256C8/I7 |
| CPU | FemtoRV32 Quark |
| BRAM | 32 KiB |
| UART | 120000 bps |
| PSRAM | 8 MB HyperRAM |
| MicroSD | Interfaz SPI |

---

## Herramientas Utilizadas

- Gowin EDA
- Icarus Verilog
- GTKWave
- xPack RISC-V GCC
- PuTTY
- Git
- GitHub

---

## Estructura del Repositorio

```text
FEMTO_UN/
│
├── rtl/
│   ├── cpu/
│   ├── uart/
│   ├── bram/
│   ├── spi/
│   └── psram/
│
├── firmware/
│   ├── uart_echo/
│   ├── calculator/
│   └── bootloader/
│
├── sim/
│   ├── testbench/
│   └── waveforms/
│
├── constraints/
│
├── docs/
│
└── README.md
```

---

## Compilación del Firmware

Ejemplo:

```bash
riscv-none-elf-gcc \
-march=rv32i \
-mabi=ilp32 \
-Os \
-nostartfiles \
-o firmware.elf main.c
```

Generación del archivo hexadecimal:

```bash
riscv-none-elf-objcopy \
-O verilog \
firmware.elf \
firmware.hex
```

---

## Objetivos del Proyecto

- Comprender el funcionamiento interno de una arquitectura RISC-V.
- Implementar un SoC completo sobre FPGA.
- Integrar hardware y software embebido.
- Explorar técnicas de diseño digital y sistemas embebidos.
- Desarrollar una plataforma educativa abierta basada en RISC-V.

---

## Autores

**Laura Daniela Alarcón Castaño**  
Ingeniería Electrónica  
Universidad Nacional de Colombia

**Sebastián Orozco Agudelo**  
Ingeniería Electrónica  
Universidad Nacional de Colombia

---

## Director

**Juan Bernardo Gómez Mendoza**

---

## Universidad

Universidad Nacional de Colombia  
Sede Manizales  
Facultad de Ingeniería y Arquitectura  
Departamento de Ingeniería Eléctrica, Electrónica y Computación

---

## Licencia

Proyecto desarrollado con fines académicos y educativos.
