# =============================================================================
# Makefile - Femto Testbench
# =============================================================================
# Uso:
#   make          → Compilar y simular (genera femtoUN.vcd)
#   make compile  → Solo compilar
#   make sim      → Solo simular (requiere compilar antes)
#   make wave     → Abrir GTKWave (requiere simular antes)
#   make clean    → Limpiar archivos generados
# =============================================================================

IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

# Fuentes
SRC = src/uart.v \
      src/perip_uart.v \
      src/bram_hex.v \
      src/femtorv_quark.v \
      src/SOC_bram.v \
      src/top_tang_bram.v

TB  = tb/tb_femtoUN.v

# Salidas
SIM_BIN = sim.out
VCD     = femtoUN.vcd

# Flags
DEFINES = -DBENCH

.PHONY: all compile sim wave clean

all: compile sim

compile:
	@echo "═══ Compilando con Icarus Verilog ═══"
	$(IVERILOG) $(DEFINES) -o $(SIM_BIN) $(TB) $(SRC)
	@echo "═══ Compilación exitosa ═══"

sim: compile
	@echo "═══ Ejecutando simulación ═══"
	$(VVP) $(SIM_BIN)
	@echo "═══ VCD generado: $(VCD) ═══"

wave: $(VCD)
	$(GTKWAVE) $(VCD) &

clean:
	rm -f $(SIM_BIN) $(VCD)
	@echo "═══ Limpio ═══"
