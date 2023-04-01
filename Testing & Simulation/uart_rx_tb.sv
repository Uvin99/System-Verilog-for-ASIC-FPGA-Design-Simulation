module uart_rx_tb ;
    timeunit 1ns/1ps;
    localparam CLOCKS_PER_PULSE = 4 ,
               W_out = 16,
               BITS_PER_WORD = 8,
               NUM_WORDS = W_out/BITS_PER_WORD,
               CLK_PERIOD = 10;
    
    logic clk=0,rstn=0,rx=1, m_valid;
    logic [NUM_WORDS-1:0][BITS_PER_WORD-1:0]m_data, data;
    logic [BITS_PER_WORD+2-1:0]packet ;


    initial forever #(CLK_PERIOD/2) clk <= !clk;

    uart_rx #(
        .CLOCKS_PER_PULSE(CLOCKS_PER_PULSE),
        .W_out(W_out),
        .BITS_PER_WORD(BITS_PER_WORD)
    ) dut(.*);
    //Driver

    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
        repeat(2) @(posedge clk) #1;
        rstn = 1 ;
        repeat(5) @(posedge clk) #1;

        repeat (10) begin 
            data = $urandom();
            for (int iw=0; iw<NUM_WORDS; iw=iw+1)begin
                packet = {1'b1 , data[iw], 1'b0};
                repeat ($urandom_range(1,20)) @(posedge clk);

                for (int ib=0; ib<BITS_PER_WORD+2 ; ib=ib+1)
                  repeat(CLOCKS_PER_PULSE) begin
                    #1 rx <= packet[ib];
                    @(posedge clk);
                  end
            end
            repeat 
    end
    

endmodule