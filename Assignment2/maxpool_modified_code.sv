
package types; // Packages and enums are good practice. Dont change them
  typedef enum {RX1, RX2, TX} state_t;
endpackage


module maxpool 
  import types::*;
  #(parameter R=10, W=8 )

  (
    input  logic clk, rstn,
    input  logic s_valid,
    output logic s_ready,
    input  logic [R-1:0][W-1:0] s_data,
    output logic m_valid,
    input  logic m_ready,
    output logic [R/2-1:0][W-1:0] m_data
  );

  


  state_t state;
  always @(posedge clk or negedge rstn)
    if (!rstn) 
        state <= RX1;
     else begin
        unique case (state)
         RX1 : if (s_valid && s_ready) 
                state <= RX2;
         RX2 : if (s_valid && s_ready)
                state <= TX;
         TX : if (m_ready) 
                state <= RX1;
         endcase
                
      end
 
  genvar r;
  for (r=0; r<R/2; r++)
    max_2x2 #(.W(W)) UNIT (
                            .clk(clk), 
                            .en (s_ready && s_valid), 
                            .rstn(rstn), 
                            .state(state), 
                            .s_data({s_data[2*r+1], s_data[2*r]}),
                            .m_data(m_data [r])
                             );

  assign s_ready = (m_ready && state) != TX;
  
  always_ff @(posedge clk)
    m_valid <= (state == TX);

endmodule



module max_2x2 
  import types::*;
  #( parameter W=8 )(
    input  logic clk, rstn, en,
    input  state_t state,
    input  logic [1:0][W-1:0] s_data,
    output logic      [W-1:0] m_data
  );

  logic [W-1:0] comp_in_1, comp_in_2, comp_out;
  logic [W-1:0] max_1, max_2;


  // Set comp_in
  always_comb unique case (state)
     RX1 : {comp_in_1, comp_in_2} = {s_data[0], s_data[1]};
     RX2 : {comp_in_1, comp_in_2} = {s_data[0], s_data[1]};
     TX : {comp_in_1, comp_in_2} = {max_1    , max_2};
    endcase

  // comparator
  assign comp_out = (comp_in_1 > comp_in_2) ?       comp_in_1 : comp_in_2; // unsigned

  
  // Set comp out
  always_ff @(posedge clk) begin
    if (en)
      unique case(state)
      RX1 : max_1  <= comp_out;
      RX2 : max_2  <= comp_out;
      
      endcase

    if (state == TX) m_data <= comp_out;
  end

 
endmodule