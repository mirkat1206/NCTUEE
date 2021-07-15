`timescale 1ns / 1ps
 
module dis_sev_seg(
    input [2:0] i,              // 指定顯示 NEXYS 4 DDR 的哪一顆七段顯示器
    output [7:0] w_out_dis      // 控制要顯示 NEXYS 4 DDR 的哪一顆七段顯示器 
    );
    
    reg [7:0] out_dis;    
    assign w_out_dis = out_dis ;
    
    always @( i ) begin
        case( i )
            0:  out_dis = ~8'b10000000 ;
            1:  out_dis = ~8'b01000000 ;
            2:  out_dis = ~8'b00100000 ;
            3:  out_dis = ~8'b00010000 ;
            4:  out_dis = ~8'b00001000 ;
            5:  out_dis = ~8'b00000100 ;
            6:  out_dis = ~8'b00000010 ;
            7:  out_dis = ~8'b00000001 ;
        endcase
    end    
    
endmodule
