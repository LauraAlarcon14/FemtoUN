module bram_hex (
   input             clk,
   input      [31:0] mem_addr,
   output reg [31:0] mem_rdata,
   input             cs,
   input             rd,
   input             wr,
   input      [31:0] mem_wdata,
   input      [3:0]  mem_wmask
);
   reg [31:0] MEM [0:8191];
   wire [29:0] word_addr = mem_addr[31:2];

   initial begin
      $readmemh("src/firmware.hex", MEM);
   end

   always @(posedge clk) begin
      if(cs & rd) begin
         mem_rdata <= MEM[word_addr[12:0]];
      end
      if(cs & wr) begin
         if(mem_wmask[0]) MEM[word_addr[12:0]][7:0]   <= mem_wdata[7:0];
         if(mem_wmask[1]) MEM[word_addr[12:0]][15:8]  <= mem_wdata[15:8];
         if(mem_wmask[2]) MEM[word_addr[12:0]][23:16] <= mem_wdata[23:16];
         if(mem_wmask[3]) MEM[word_addr[12:0]][31:24] <= mem_wdata[31:24];
      end
   end
endmodule