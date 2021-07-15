`timescale 1ns / 1ps

module my_counter_drei(
    input clk,
    output reg ans = 0
//    output reg [21:0] q = 0,
//    output reg [1:0] a = 0
    );
    reg [21:0] q = 0 ;
    reg [3:0] a = 0 ;
//    reg [1:0] a = 0 ;    
    always @( posedge clk )
            q <= q + 1 ;    
    always @( posedge q[19] ) begin
        if( a==2 ) begin
            ans <= ans + 1 ;    
            a <= 0 ;
        end
        else
            a <= a + 1 ;
    end              
endmodule
