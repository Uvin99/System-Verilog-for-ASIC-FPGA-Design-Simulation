module full_adder(
    input logic a,b, ci,
    output logic sum, co
);

  logic wire1, wire2;
  assign wire1 = a^b ; // bitwise XOR
  assign wire2 = wire1 & ci;  //bitwise AND

wire wire3 = a & b;

always_comb begin 
    co = wire1 | wire3;   // bitwise OR
    sum = wire1 ^ ci;     //bitwise XOR

end

endmodule

 


