
package types; // Packages and enums are good practice. Dont change them
  typedef enum {S1, S2, S3} state_t;
endpackage


module maxpool 
  import types::*;
  (clk, rstn, s_valid, s_ready, s_data, m_valid, m_ready, m_data);

  parameter R=10, W=8;

  input  logic clk, rstn;
  input  logic s_valid;
  output logic s_ready;
  input  logic [R  -1:0][W-1:0] s_data;
  output logic m_valid;
  input  logic m_ready;
  output logic [R/2-1:0][W-1:0] m_data;

  state_t state;
  always @(posedge clk or negedge rstn)
    if (!rstn) state <= S1;
    else 
      if      (state == S1) begin
        if (s_valid & s_ready) state <= S2;
      end
      else if (state == S2) begin 
        if (s_valid & s_ready) state <= S3;
      end
      else if (state == S3) begin 
        if (m_ready)           state <= S1;
      end
  
  genvar r;
  for (r=0; r<R/2; r++)
    max_2x2 #(.W(W)) UNIT (clk, s_ready && s_valid, rstn, state, {s_data[2*r+1], s_data[2*r]}, m_data [r]);

  assign s_ready = m_ready & state != S3;
  
  always @(posedge clk)
    m_valid <= state == S3;

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

  // Set comp out
  always_ff @(posedge clk) begin
    if (en)
      if      (state == S1) max_1  <= comp_out;
      else if (state == S2) max_2  <= comp_out;

    if (state == S3) m_data <= comp_out;
  end

  // Set comp_in
  always @(*)
    if      (state == S1) {comp_in_1, comp_in_2} = {s_data[0], s_data[1]};
    else if (state == S2) {comp_in_1, comp_in_2} = {s_data[0], s_data[1]};
    else if (state == S3) {comp_in_1, comp_in_2} = {max_1    , max_2};

  // comparator
  assign comp_out = comp_in_1 > comp_in_2 ? comp_in_1 : comp_in_2; // unsigned

endmodule