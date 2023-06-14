module maxpool_tb;
  timeunit 1ns/1ps;

  localparam R=4, W=8, CLK_PERIOD=10;

  logic clk=0, rstn=0, s_valid=0, m_valid, m_ready=1, s_ready;
  logic [R  -1:0][W-1:0] s_data;
  logic [R/2-1:0][W-1:0] m_data;

  initial forever #(CLK_PERIOD/2) clk <= ~clk;
  maxpool #(.R(R), .W(W)) dut (.*);

  int i = 0;
  initial begin

    repeat(2) @(posedge clk);
    #1 rstn = 1;

      while (i<10) begin

        @(posedge clk);
        if (!s_ready) continue;

        #1
        for (int r=0; r<R; r++) begin
          s_valid   <= 1;
          s_data[r] <= $urandom_range(0,2**W);
        end
        i += 1;
      end
      @(posedge clk) #1 s_valid   <= 0;
  end

endmodule