`timescale 1ns / 1ps

module set_sev_seg_dp(
    input [3:0] num,
    output [7:0] w_out_num
    );
    
    reg [7:0] out_num;
    assign w_out_num = out_num ;
    
    always @( num ) begin
        case( num )
            0:   out_num = 8'b0000_0011;
            1:   out_num = 8'b1001_1111;
            2:   out_num = 8'b0010_0101;
            3:   out_num = 8'b0000_1101;
            4:   out_num = 8'b1001_1001;
            5:   out_num = 8'b0100_1001;
            6:   out_num = 8'b1100_0001;
            7:   out_num = 8'b0001_1111;
            8:   out_num = 8'b0000_0001;
            9:   out_num = 8'b0001_1001;
            10:  out_num = 8'b1111_1110;         // '*' =  dot point
            11:  out_num = 8'b1000_0001;         // '#'
            default:  out_num = 8'b1111_1111;    // 空白
        endcase
    end
    
endmodule
