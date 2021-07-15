`timescale 1ns / 1ps

module my_counter(
    input clk,
//    output reg [3:0] a = 0,
    output my_clk
    );
    
    reg [22:0] q = 0 ;
    
//    frequency 47.6 Hz
    always @( negedge clk ) begin
//        a <= a + 1 ;
        q <= q + 1 ;
    end
        
    assign my_clk = q[20];
    
endmodule
