`timescale 1ns / 1ps

module MUX_5to1(
    input [4:0] button,
    input [2:0] select,
    
    output reg out
    );
    always@ ( button, select ) begin
        case( select )
            default:
                out = button[0] ;
            3'b001:
                out = button[1] ;
            3'b010:
                out = button[2] ;
            3'b011:
                out = button[3] ;
            3'b100:
                out = button[4] ;  
        endcase                                                                         
    end
endmodule
