`timescale 1ns / 1ps

module adder_subtracter(
    input a,
    input b,
    input c_in,
    output sum,
    output c_out,
    
    input x,
    input y,
    input b_in,
    output dif,
    output b_out
    );
    assign sum = a ^ b ^ c_in ;
    assign c_out = ( a & b )|( b & c_in )|( c_in & a ) ;
    
    assign dif = ( ~x & ~y & b_in )|( ~x & y & ~b_in )|( x & ~y & ~b_in )|( x & y & b_in ) ;
    assign b_out = ( ~x & ~y & b_in )|( ~x & y & ~b_in )|( ~x & y & b_in )|( x & y & b_in ) ;
endmodule
