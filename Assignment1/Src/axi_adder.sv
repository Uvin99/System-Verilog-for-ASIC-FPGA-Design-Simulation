module axi_adder #(
    parameter W = 8,    // Width of each data word
    parameter N = 3     // Number of data words to sum
    
    )
(
    input logic clk, rstn , s_valid , m_ready,
    input logic [W-1:0] s_data,
    output logic m_valid , s_ready,
    output logic [1:0][6:0] m_data
    
);
    
    localparam N_BITS = $clog2(N);

    // Local signals
    logic [W+N_BITS-1:0] sum_reg = 0;
    logic [W+N_BITS-1:0] data_reg;
    logic [6:0] ssd_out0 ;
    logic [6:0] ssd_out1;
    logic [N_BITS-1:0] count = 1'd1;

    //Seven segment display digits
    assign ssd_out0 = sum_reg % 10;
    assign ssd_out1 = sum_reg / 10;
   
   
   // Convert sum to 7-segment format
    ssd_convert  s0(
        .in(ssd_out0),
        .ssd_digit(m_data[0])
        );


    ssd_convert  s1(
        .in(ssd_out1),
        .ssd_digit(m_data[1])
        );


    always_ff @(posedge clk or  negedge rstn)
    if (!rstn)
    begin 
        sum_reg <= 0;
        m_valid <= 0;
        count <= 0;
    end
    
    else begin
        if(s_valid && m_ready && count < N)
        begin
            m_valid <=0 ;
            count <= count + 1'd1;          //incrementing the counter
            sum_reg <= sum_reg + s_data;    //updating the sum_reg
            s_ready <=1;
                   
        end
        
        else begin
            m_valid <= 0;
            s_ready <=0;
            
           if (count == N) begin
                m_valid <= 1;
                count <= 1'd1;
                sum_reg <= 0;
              end    
           end

    end 

endmodule
