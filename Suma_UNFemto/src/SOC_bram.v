module SOC_bram (
   input  clk,
   input  resetn,
   output uart_tx,
   input  uart_rx
);
   wire [31:0] mem_addr;
   wire [31:0] mem_rdata;
   wire        mem_rstrb;
   wire [31:0] mem_wdata;
   wire [3:0]  mem_wmask;
   wire wr = |mem_wmask;
   wire rd = mem_rstrb;

   wire uart_cs = (mem_addr[31:16] == 16'h0040);
   wire bram_cs = ~uart_cs;

   wire [31:0] bram_rdata;
   wire [31:0] uart_rdata;

   assign mem_rdata = uart_cs ? uart_rdata : bram_rdata;

   bram_hex RAM(
      .clk      (clk),
      .mem_addr (mem_addr),
      .mem_rdata(bram_rdata),
      .cs       (bram_cs),
      .rd       (rd),
      .wr       (wr),
      .mem_wdata(mem_wdata),
      .mem_wmask(mem_wmask)
   );

   // 🔴 CORRECCIÓN AQUÍ: se pasa también el parámetro baud
   peripheral_uart #(
      .clk_freq(27000000),
      .baud(120000)
   ) UART(
      .clk    (clk),
      .rst    (~resetn),
      .cs     (uart_cs),
      .rd     (rd),
      .wr     (wr),
      .addr   (mem_addr[4:0]),
      .d_in   (mem_wdata),
      .d_out  (uart_rdata),
      .uart_tx(uart_tx),
      .uart_rx(uart_rx)
   );

   FemtoRV32 CPU(
      .clk      (clk),
      .mem_addr (mem_addr),
      .mem_rdata(mem_rdata),
      .mem_rstrb(mem_rstrb),
      .mem_wdata(mem_wdata),
      .mem_wmask(mem_wmask),
      .mem_rbusy(1'b0),
      .mem_wbusy(1'b0),
      .reset    (resetn)
   );
endmodule