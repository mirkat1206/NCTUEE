`timescale 1ns / 1ps

module keyboard_music(
    input clk,                  // 使用 NEXYS 4 DDR 內建 CMOS 振盪器 ( 腳位 E3 )
    input [6:0] keyboard,    
    output reg speaker = 0
    );
    
    reg [7:0] cnt = 0 ;
    reg [7:0] note_frq [12:0] ;
    
    wire [3:0] i ;
    // 將 3*4 鍵盤的input 轉換成數字，詳細內容請見 keyboard2num.v
    keyboard2num k2n( .keyboard( keyboard ) , .k_in_num( i ) );     
    
    wire basic_div;
    parameter basic_frq = 10 ;          // frequency divider of basic_frq
    // 進行除頻，詳細內容請見 my_clock.v
    my_clock set_note( .clk( clk ) , .frqdiv( basic_frq ) , .out_clk( basic_div ) );
       
    always @( posedge basic_div ) begin
        if( i==12 );
        else if( cnt==note_frq[i] ) begin
            speaker <= speaker + 1 ;
            cnt <= 0 ;
        end
        else
            cnt <= cnt + 1 ;
    end   
    
    // 初始化 initialization 音階從c4-g5
    initial begin
        note_frq[1] = 94 ;  note_frq[2] = 83 ;  note_frq[3] = 74 ;  note_frq[4] = 70 ;    
        note_frq[5] = 62 ;  note_frq[6] = 55 ;  note_frq[7] = 49 ;  note_frq[8] = 46 ;  
        note_frq[9] = 41 ;  note_frq[10] = 37 ;  note_frq[0] = 35 ;  note_frq[11] = 31 ;                  
    end
        
endmodule
