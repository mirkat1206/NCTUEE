`timescale 1ns / 1ps

module set_sev_seg(
    input [3:0] num,            // 指定要在七段顯示器上顯示什麼
    output [6:0] w_out_num      // 控制要在七段顯示器上顯示什麼
    );
    
    reg [6:0] out_num;    
    assign w_out_num = out_num ;
    
    always @( num ) begin
        case( num )
            0:   out_num = 7'b0000001 ;
            1:   out_num = 7'b1001111 ;
            2:   out_num = 7'b0010010 ;
            3:   out_num = 7'b0000110 ;
            4:   out_num = 7'b1001100 ;
            5:   out_num = 7'b0100100 ;
            6:   out_num = 7'b1100000 ;
            7:   out_num = 7'b0001111 ;
            8:   out_num = 7'b0000000 ;
            9:   out_num = 7'b0001100 ;
            10:  out_num = 7'b1111110 ;         //  "-"
            default:  out_num = 7'b1111111 ;    // 控白
            /*            
            10:  out_num = 7'b1110010 ;
            11:  out_num = 7'b1100110 ;
            12:  out_num = 7'b1011100 ;
            13:  out_num = 7'b0110100 ;
            14:  out_num = 7'b1110000 ;
            default:    out_num = 7'b1111111 ;      //  空白
            */
        endcase
    end      
    
endmodule
