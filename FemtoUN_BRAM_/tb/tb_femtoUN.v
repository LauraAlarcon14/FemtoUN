// =============================================================================
// Testbench  - SoC RISC-V con UART
// =============================================================================
// Compilar:   make
// Ver ondas:  gtkwave femtoUN.vcd
// =============================================================================
`timescale 1ns / 1ps

module tb_femtoUN;

   // ---------------------------------------------------------------
   // Parámetros de simulación
   // ---------------------------------------------------------------
   parameter CLK_PERIOD  = 37;         // ~27 MHz
   parameter SIM_TIME_MS = 150;        // ms (alcanza para ~6 caracteres UART)

   // ---------------------------------------------------------------
   // Señales del DUT
   // ---------------------------------------------------------------
   reg  clk_27mhz = 0;
   reg  rst_n     = 0;
   wire uart_tx;
   reg  uart_rx   = 1;                 // Idle alto
   wire led;

   // ---------------------------------------------------------------
   // Reloj 27 MHz
   // ---------------------------------------------------------------
   always #(CLK_PERIOD/2) clk_27mhz = ~clk_27mhz;

   // ---------------------------------------------------------------
   // DUT
   // ---------------------------------------------------------------
   top_tang_bram DUT (
      .clk_27mhz (clk_27mhz),
      .rst_n     (rst_n),
      .uart_tx   (uart_tx),
      .uart_rx   (uart_rx),
      .led       (led)
   );

   // ---------------------------------------------------------------
   // Secuencia de reset y control
   // ---------------------------------------------------------------
   initial begin
      $display("============================================");
      $display(" FemtoUN Testbench");
      $display(" Reloj: 27 MHz  |  UART: 120000 baud");
      $display(" Simulacion: %0d ms", SIM_TIME_MS);
      $display("============================================");
      $display("");

      rst_n = 0;
      #(CLK_PERIOD * 10);
      rst_n = 1;
      $display("[%0t] Reset externo liberado", $time);

      wait(DUT.resetn == 1'b1);
      $display("[%0t] CPU arrancando (resetn=1)", $time);
      $display("  Esperando transmision UART...");
      $display("");

      #(SIM_TIME_MS * 1_000_000);

      $display("");
      $display("============================================");
      $display(" Simulacion finalizada");
      $display(" Abre el VCD:  gtkwave femtoUN.vcd");
      $display("============================================");
      $finish;
   end

   // ---------------------------------------------------------------
   // VCD - Volcado selectivo para GTKWave
   // ---------------------------------------------------------------
   initial begin
      $dumpfile("femtoUN.vcd");

      // Top: clk, reset, uart_tx, led
      $dumpvars(1, DUT);

      // SoC internos: buses, chip-selects
      $dumpvars(1, DUT.SOC);

      // CPU: PC, estado, instrucción
      $dumpvars(1, DUT.SOC.CPU);

      // UART TX: señales de transmisión
      $dumpvars(1, DUT.SOC.UART);
      $dumpvars(1, DUT.SOC.UART.uart0);
   end

   // ---------------------------------------------------------------
   // Decodificador UART TX (imprime caracteres en consola)
   // ---------------------------------------------------------------
   localparam UART_BAUD     = 120_000;
   localparam UART_FREQ     = 27_000_000;
   localparam BIT_PERIOD_NS = (UART_FREQ / UART_BAUD) * CLK_PERIOD;

   reg [7:0]  rx_char;
   reg [7:0]  msg_buf [0:127];
   integer    msg_idx = 0;
   integer    bit_idx;

   initial begin
      forever begin
         @(negedge uart_tx);
         #(BIT_PERIOD_NS / 2);

         if (uart_tx == 1'b0) begin
            for (bit_idx = 0; bit_idx < 8; bit_idx = bit_idx + 1) begin
               #(BIT_PERIOD_NS);
               rx_char[bit_idx] = uart_tx;
            end
            #(BIT_PERIOD_NS);

            if (rx_char >= 8'h20 && rx_char <= 8'h7E) begin
               $write("%c", rx_char);
               msg_buf[msg_idx] = rx_char;
               msg_idx = msg_idx + 1;
            end
            else if (rx_char == 8'h0D) begin
               $write("<CR>");
            end
            else if (rx_char == 8'h0A) begin
               $write("<LF>\n");
               $display("  >>> Mensaje UART completo recibido!");
               msg_idx = 0;
            end
         end
      end
   end

   // ---------------------------------------------------------------
   // Monitor: escrituras al periférico UART
   // ---------------------------------------------------------------
   always @(posedge clk_27mhz) begin
      if (DUT.resetn && DUT.SOC.uart_cs && DUT.SOC.wr) begin
         if (DUT.SOC.mem_addr[4:0] == 5'h08)
            $display("[%0t] CPU -> UART_DATA = 0x%02h ('%c')",
                     $time, DUT.SOC.mem_wdata[7:0], DUT.SOC.mem_wdata[7:0]);
      end
   end

endmodule
