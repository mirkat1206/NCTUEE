`timescale 1ns / 1ps

module timer(
    input clk,                  // 使用 NEXYS 4 DDR 內建 CMOS 振盪器 ( 腳位 E3 )
    output [6:0] out_num,       // 控制要在七段顯示器上顯示什麼
    output [7:0] out_dis,       // 控制要顯示 NEXYS 4 DDR 的哪一顆七段顯示器 
    
    input reset,                // RESET按鈕，使所有設定回到 initail 狀態
    input [1:0] speed_up        // 控制計時器 timer 計時的速度，有四段變速
    );
    
    reg [3:0] num [7:0];        // 儲存要顯示的內容 
    reg [2:0] i = 0 ;           // 決定當下顯示的是第 i 顆七段顯示器
    
    // 控制要在七段顯示器上顯示什麼，詳細內容請見 set_set_seg.v
    set_sev_seg func_set( .num( num[i] ) , .w_out_num( out_num ) );
    // 控制要顯示 NEXYS 4 DDR 的哪一顆七段顯示器，詳細內容請見 dis_sev_seg.v
    dis_sev_seg func_dis( .i( i ) , .w_out_dis( out_dis ) );
    
    wire my_clk;
    parameter fq_my_clk = 10 ;      // frequency divider of my_clk
    // 進行除頻，詳細內容請見 my_clock.v
    my_clock func_my_clk( .clk( clk ), .frqdiv( fq_my_clk ), .out_clk( my_clk ) );
    
    always @( posedge my_clk ) begin
        if( i==7 ) 
            i <= 0 ;
        else
            i <= i + 1 ;
    end
    
    wire timer_clk;                 // 控制計時器 timer 的速度 : timer's clock
    reg [4:0] fq_timer_clk ;        // frequency divider of timer_clk
    // 進行除頻，詳細內容請見 my_clock.v
    my_clock func_timer_clk( .clk( clk ) , .frqdiv( fq_timer_clk ) , .out_clk( timer_clk ) );    
    // 計時器 timer 的實作
    always @( posedge timer_clk ) begin                         // 01-34-67 
        if( reset==1 ) begin
            num[0] = 0 ;    num[1] = 0 ;    num[2] = 10 ;   num[3] = 0 ;    
            num[4] = 0 ;    num[5] = 10 ;   num[6] = 0 ;    num[7] = 0 ;
        end
        
        // s1         
        else if( num[7]==9 ) begin                                 // xx-xx-x9
            num[7] <= 0 ;       
            // s2
            if( num[6]==5 ) begin                               // xx-xx-59 
                num[6] <= 0 ;
                // m1
                if( num[4]==9 ) begin                           // xx-x9-59
                    num[4] <= 0 ;
                    // m2
                    if( num[3]==5 ) begin                       // xx-59-59
                        num[3] <= 0 ;
                        // hh
                        if( num[0]==2 && num[1]==3 ) begin      // 23-59-59
                            num[0] <= 0 ;
                            num[1] <= 0 ;
                        end 
                        // h1                                                                          // 01-34-67
                        else if( num[1]==9 ) begin              // x9-59-59
                            num[1] <= 0 ;
                            num[0] <= num[0] + 1 ;
                        end
                        // h2
                        else                                    // xx-59-59
                            num[1] <= num[1] + 1 ;                            
                    end
                    // m2
                    else 
                        num[3] <= num[3] + 1 ;
                end
                // m1                                                                                         // 01-34-67
                else                                            // xx-x9-59
                    num[4] <= num[4] + 1 ;
            end
            // s2    
            else                                                // xx-xx-x9
                num[6] <= num[6] + 1 ;
        end
        // s1
        else                                                    // xx-xx-xx
            num[7] <= num[7] + 1 ;
                                                             
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
    
    // 初始化 initialization : 00-00-00
    initial begin
            num[0] = 0 ;    num[1] = 0 ;    num[2] = 10 ;   num[3] = 0 ;    
            num[4] = 0 ;    num[5] = 10 ;   num[6] = 0 ;    num[7] = 0 ;   
    end    
    
endmodule
