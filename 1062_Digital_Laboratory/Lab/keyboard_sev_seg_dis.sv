`timescale 1ns / 1ps

module keyboard_sev_seg_dis(
    input [6:0] keyboard,
    output [7:0] out_num,       // 控制要在七段顯示器上顯示什麼
    output [7:0] out_dis,       // 控制要顯示 NEXYS 4 DDR 的哪一顆七段顯示器
    
    output [6:0] debug          // 將 3*4 鍵盤的 ABCDEFG 分別對應到 NEXYS 4  DDR 上的LED 燈，用來 debug
    );
    
    wire [3:0] num;

    // 控制要顯示 NEXYS 4 DDR 的哪一顆七段顯示器，詳細內容請見 dis_sev_seg.v        
    dis_sev_seg( 7 , out_dis );
    // 將 3*4 鍵盤的input 轉換成數字，詳細內容請見 keyboard2num.v
    keyboard2num func_k2n( .keyboard( keyboard ) , .k_in_num( num ) );
    // 控制要在七段顯示器上顯示什麼，詳細內容請見 set_set_seg.v
    set_sev_seg_dp func_set( .num( num ) , .w_out_num( out_num ) );
    
    assign debug = keyboard ;
    
endmodule
