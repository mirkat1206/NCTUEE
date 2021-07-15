`timescale 1ns / 1ps

module keyboard2num(
    input [6:0] keyboard,
    output [3:0] k_in_num
    );
    
    reg [3:0] in_num;
    assign k_in_num = in_num ; 
    
    // ABCDEFG
    always @( keyboard ) begin
        case( keyboard )
            7'b1110101:    in_num = 0 ;
            7'b0111011:    in_num = 1 ;
            7'b0111101:    in_num = 2 ;
            7'b0111110:    in_num = 3 ;
            7'b1011011:    in_num = 4 ;            
            7'b1011101:    in_num = 5 ;
            7'b1011110:    in_num = 6 ;
            7'b1101011:    in_num = 7 ;
            7'b1101101:    in_num = 8 ;
            7'b1101110:    in_num = 9 ;
            7'b1110011:    in_num = 10 ;   // '*'
            7'b1110110:    in_num = 11 ;   // '#'  
            default:       in_num = 12 ;
        endcase
    end
    
endmodule
