module top_tang_bram (
   input  clk_27mhz,
   input  rst_n,
   output uart_tx,
   input  uart_rx,
   output led
);

   reg [19:0] reset_cnt = 0;
   wire resetn = &reset_cnt;
   always @(posedge clk_27mhz) begin
      if(!rst_n) reset_cnt <= 0;
      else if(!resetn) reset_cnt <= reset_cnt + 1;
   end

   SOC_bram SOC(
      .clk    (clk_27mhz),
      .resetn (resetn),
      .uart_tx(uart_tx),
      .uart_rx(uart_rx)
   );

   assign led = resetn;

endmodule
