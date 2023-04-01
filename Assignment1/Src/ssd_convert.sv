module ssd_convert
(
 input logic signed [6:0] in,
 output logic signed [6:0] ssd_digit
);

always @(in) begin
    case(in)
    0: ssd_digit = 7'b111_1110;
    1: ssd_digit = 7'b011_0000;
    2: ssd_digit = 7'b110_1101;
    3: ssd_digit = 7'b111_1001;
    4: ssd_digit= 7'b011_0011;
    5: ssd_digit = 7'b101_1011;
    6: ssd_digit = 7'b101_1111;
    7: ssd_digit = 7'b111_0000;
    8: ssd_digit = 7'b111_1111;
    9: ssd_digit = 7'b111_1011;

    default ssd_digit = 7'b111_1111;
        
    endcase
end

endmodule

