module assignment1_tb;
  timeunit 1ns/1ps;

  localparam W=3, N=4, CLK_PERIOD=10;
  logic clk=0, rstn=0;
  logic [W-1:0] s_data;
  logic [2-1:0][7-1:0] m_data;

  initial forever #(CLK_PERIOD/2) clk <= !clk;
  assignment1 #(.W(W), .N(N)) dut (.*);

  initial begin
    repeat(2) @(posedge clk);
    #1 rstn <= 1;

    for (int i=0; i<N; i++) begin
      s_data <= i;
      @(posedge clk) #1;
    end
    s_data <= 0;
    @(posedge clk);
  end
endmodule