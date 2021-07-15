`timescale 1ns / 1ps

module timer_marquee(
    input clk,                  // 使用 NEXYS 4 DDR 內建 CMOS 振盪器 ( 腳位 E3 )
    output [6:0] out_num,       // 控制要在七段顯示器上顯示什麼
    output [7:0] out_dis,       // 控制要顯示 NEXYS 4 DDR 的哪一顆七段顯示器 
    
    input reset,                // RESET按鈕，使所有設定回到 initail 狀態
    input [1:0] speed_up,       // 控制計時器 timer 計時的速度，有四段變速
    input dir,                  // 控制跑馬燈 marquee 移動方向
    input run                   // 控制跑馬燈 marquee 是否要移動
    );       
    
    reg [3:0] num [19:0];       // 儲存要顯示的內容 
    reg [3:0] i = 0 ;           // 決定當下顯示的是第 i 顆七段顯示器
    reg [4:0] str = 12 ;        // 決定當下七段顯示器顯示的是 num[ str ]~num[ str+7 ] 的內容    
    reg [4:0] ii;   
//    reg [3:0] x_num [7:0];     

    // 控制要在七段顯示器上顯示什麼，詳細內容請見 set_set_seg.v
    set_sev_seg func_set( .num( num[ii] ) , .w_out_num( out_num ) );
    // 控制要顯示 NEXYS 4 DDR 的哪一顆七段顯示器，詳細內容請見 dis_sev_seg.v
    dis_sev_seg func_dis( .i( i ) , .w_out_dis( out_dis ) );
    
    wire my_clk;
    parameter fq_my_clk = 10 ;          // frequency divider of my_clk
    // 進行除頻，詳細內容請見 my_clock.v
    my_clock func_my_clk( .clk( clk ), .frqdiv( fq_my_clk ), .out_clk( my_clk ) );
        
    always @( posedge my_clk ) begin
        if( i==7 ) begin
            i <= 0 ;
            ii <= str ;
        end
        else begin
            i <= i + 1 ;
            if( ii==19 )
                ii <= 0 ;
            else
                ii <= ii + 1 ;
        end                              
//        x_num[0] <= num[ ( 0 + str )%20 ] ;         x_num[4] <= num[ ( 4 + str )%20 ] ;
//        x_num[1] <= num[ ( 1 + str )%20 ] ;         x_num[5] <= num[ ( 5 + str )%20 ] ;
//        x_num[2] <= num[ ( 2 + str )%20 ] ;         x_num[6] <= num[ ( 6 + str )%20 ] ;
//        x_num[3] <= num[ ( 3 + str )%20 ] ;         x_num[7] <= num[ ( 7 + str )%20 ] ;            
    end
    
    wire pos_clk;                       // 控制跑馬燈的跑速 : position's clock
    parameter fq_pos_clk = 25 ;         // frequency divider of pos_clk
    // 進行除頻，詳細內容請見 my_clock.v
    my_clock func_pos_clk( .clk( clk ) , .frqdiv( fq_pos_clk ) , .out_clk( pos_clk ) );  
    
    always @( posedge pos_clk ) begin     
        if( run==0 );                   // 如果 input run為0，則 reg [4:0] str 維持原本的值
        else if( dir==0 ) begin         // 如果 input dir為0，代表跑馬燈 marquee 向右跑，則 reg [4:0] str 加一
            if( str==19 )
                str <= 0 ;
            else
                str <= str + 1 ;
        end
        else begin                  // 如果 input dir為1，代表跑馬燈 marquee 向左跑，則 reg [4:0] str 減一
            if( str==0 )
                str <= 19 ;
            else
                str <= str - 1 ;
        end
            
        if( reset==1 ) 
            str <= 0 ;      
    end
        
    wire timer_clk;                     // 控制計時器 timer 的速度 : timer's clock
    reg [4:0] fq_timer_clk ;            // frequency divider of timer_clk
    // 進行除頻，詳細內容請見 my_clock.v
    my_clock func_timer_clk( .clk( clk ) , .frqdiv( fq_timer_clk ) , .out_clk( timer_clk ) );
    // 計時器 timer 的實作
    always @( posedge timer_clk ) begin                         // 01-34-67                     
        // s1         
        if( num[18]==9 ) begin                                  // xx-xx-x9
            num[18] <= 0 ;       
            // s2
            if( num[17]==5 ) begin                              // xx-xx-59 
                num[17] <= 0 ;
                // m1
                if( num[15]==9 ) begin                          // xx-x9-59
                    num[15] <= 0 ;
                    // m2
                    if( num[14]==5 ) begin                      // xx-59-59
                        num[14] <= 0 ;
                        // hh
                        if( num[11]==2 && num[12]==3 ) begin    // 23-59-59
                            num[11] <= 0 ;
                            num[12] <= 0 ;
                        end 
                        // h1                                                                          // 01-34-67
                        else if( num[12]==9 ) begin             // x9-59-59
                            num[12] <= 0 ;
                            num[11] <= num[11] + 1 ;
                        end
                        // h2
                        else                                    // xx-59-59
                            num[12] <= num[12] + 1 ;                            
                    end
                    // m2
                    else 
                        num[14] <= num[14] + 1 ;
                end
                // m1                                                                                         // 01-34-67
                else                                            // xx-x9-59
                    num[15] <= num[15] + 1 ;
            end
            // s2    
            else                                                // xx-xx-x9
                num[17] <= num[17] + 1 ;
        end
        // s1
        else                                                    // xx-xx-xx
            num[18] <= num[18] + 1 ;
        
        if( reset==1 ) begin
            num[0] <= 2 ;        num[1] <= 0 ;        num[2] <= 1 ;        num[3] <= 8 ;    
            num[4] <= 10 ;       num[5] <= 0 ;        num[6] <= 5 ;        num[7] <= 10 ;
            num[8] <= 0 ;        num[9] <= 3 ;        num[10] <= 10 ;      num[11] <= 0 ;    
            num[12] <= 0 ;       num[13] <= 10 ;      num[14] <= 0 ;       num[15] <= 0 ;
            num[16] <= 10 ;      num[17] <= 0 ;       num[18] <= 0 ;       num[19] <= 11 ; 
        end                                                
    end      
      
    // 加速器的實作             
    always @( speed_up ) begin
        if( speed_up==3 )
            fq_timer_clk = 12 ;
        else if( speed_up==2 )
            fq_timer_clk = 18 ;
        else if( speed_up==1 )
            fq_timer_clk = 23 ;                        
        else
            fq_timer_clk = 25 ;
    end  
    
    // 初始化 initialization : 2018-05-03-00-00-00(空白)
    initial begin
            num[0] = 2 ;        num[1] = 0 ;        num[2] = 1 ;        num[3] = 8 ;    
            num[4] = 10 ;       num[5] = 0 ;        num[6] = 5 ;        num[7] = 10 ;
            num[8] = 0 ;        num[9] = 3 ;        num[10] = 10 ;      num[11] = 0 ;    
            num[12] = 0 ;       num[13] = 10 ;      num[14] = 0 ;       num[15] = 0 ;
            num[16] = 10 ;      num[17] = 0 ;       num[18] = 0 ;       num[19] = 11 ;    
    end        
       
endmodule
