`timescale 1ns / 1ps

module music_littlestar(
    input clk,                  // 使用 NEXYS 4 DDR 內建 CMOS 振盪器 ( 腳位 E3 )
    output reg speaker = 0,     // 控制喇吧
    output out_stop             // 停頓點的 LED，用於debug
    );
    
    reg [7:0] cnt = 0 ;
    reg [7:0] note_frq [12:0] ;    
    
    reg [3:0] a [41:0];         // 小星星樂譜       
    reg [5:0] i = 0 ;          // 控制喇叭要發出小星星樂譜的第幾個音
    
    wire basic_div;
    parameter basic_frq = 10 ;
    // 進行除頻，詳細內容請見 my_clock.v
    my_clock set_note( .clk( clk ) , .frqdiv( basic_frq ) , .out_clk( basic_div ) );
       
    always @( posedge basic_div ) begin
        if( cnt==note_frq[ a[i] ] ) begin
            speaker <= speaker + 1 ;
            cnt <= 0 ;
        end
        else
            cnt <= cnt + 1 ;
    end   
 
    wire a_clk;
    parameter a_frq = 24 ;
    // 進行除頻，詳細內容請見 my_clock.v
    my_clock func_a_clk( .clk( clk ) , .frqdiv( a_frq ) , .out_clk( a_clk ) );
    
    reg stop = 0 ;
    assign out_stop = stop ;
    
    reg [5:0] buffer = 0 ;
    always @( posedge a_clk ) begin
        // 當 stop==1 時，喇叭不發出聲音
        if( stop==1 ) begin
            i <= 42 ;
            stop <= 0 ;
        end
        // 當 stop==0 時，喇叭發出聲音
        else begin     
            i <= buffer ;
            stop <= 1 ;           
            if( buffer==41 ) begin
                buffer <= 0 ;
            end
            else begin
                buffer <= buffer + 1 ;
            end                         
        end            
    end
    
    // 初始化 initialization：小星星樂譜~~        
    initial begin
        // stop==0
        note_frq[1] = 94 ;  note_frq[2] = 83 ;  note_frq[3] = 74 ;  note_frq[4] = 70 ;    
        note_frq[5] = 62 ;  note_frq[6] = 55 ;  note_frq[7] = 49 ;  note_frq[8] = 46 ;  
        note_frq[9] = 41 ;  note_frq[10] = 37 ;  note_frq[0] = 35 ;  note_frq[11] = 31 ;        
         
        
        a[0] = 1 ;      a[1] = 1 ;      a[2] = 5 ;      a[3] = 5 ;      a[4] = 6 ;      a[5] = 6 ;      a[6] = 5 ; 
        a[7] = 4 ;      a[8] = 4 ;      a[9] = 3 ;      a[10] = 3 ;     a[11] = 2 ;     a[12] = 2 ;     a[13] = 1 ; 
        a[14] = 5 ;     a[15] = 5 ;     a[16] = 4 ;     a[17] = 4 ;     a[18] = 3 ;     a[19] = 3 ;     a[20] = 2 ; 
        a[21] = 5 ;     a[22] = 5 ;     a[23] = 4 ;     a[24] = 4 ;     a[25] = 3 ;     a[26] = 3 ;     a[27] = 2 ; 
        a[28] = 1 ;     a[29] = 1 ;     a[30] = 5 ;     a[31] = 5 ;     a[32] = 6 ;     a[33] = 6 ;     a[34] = 5 ; 
        a[35] = 4 ;     a[36] = 4 ;     a[37] = 3 ;     a[38] = 3 ;     a[39] = 2 ;     a[40] = 2 ;     a[41] = 1 ;         
        
        // stop==1
        note_frq[12] = 0 ;
        a[42] = 12 ;                 
    end

endmodule
