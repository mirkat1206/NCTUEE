`timescale 1ns / 1ps

module trafficLT(
    input clk,                  // 使用 NEXYS 4 DDR 內建 CMOS 振盪器 ( 腳位 E3 )
    output [6:0] out_num,       // 控制要顯示 NEXYS 4 DDR 的哪一顆七段顯示器 
    output [7:0] out_dis,       // 控制要在七段顯示器上顯示什麼
    output reg out_r,           // 控制 tri-color LED 的 red light
    output reg out_g,           // 控制 tri-color LED 的 green light
    output reg out_b,            // 控制 tri-color LED 的 blue light
    // 以下的 output 都是用於 debug 的呦
    output reg debug,           // 切換燈的時候會閃爍
    output w_en_r,
    output w_en_y,
    output w_en_g,
    output w_is_next_y
    );
    
    // en_r, en_y, en_g 三者同時只會有一個為 1    
    reg en_r = 1 ;              // 決定是否亮紅燈
    reg en_y = 0 ;              // 決定是否亮黃燈
    reg en_g = 0 ;              // 決定是否亮綠燈
    assign w_en_r = en_r ;
    assign w_en_y = en_y ; 
    assign w_en_g = en_g ;    
    
    reg [3:0] num [0:1] ;       // 儲存倒數計時的數字        // num = 10-0
    reg i = 0;                  // 決定當下顯示的是第 i 顆七段顯示器       // i = 0-1

    // 控制要在七段顯示器上顯示什麼，詳細內容請見 set_set_seg.v    
    set_sev_seg func_set( .num(num[i]) , .w_out_num(out_num) );
    // 控制要顯示 NEXYS 4 DDR 的哪一顆七段顯示器，詳細內容請見 dis_sev_seg.v
    dis_sev_seg func_dis( .i(i+6) , .w_out_dis(out_dis) );
        
    wire num_clk;
    parameter num_fq = 24 ;
    // 進行除頻，詳細內容請見 my_clock.v 
    my_clock func_cnt_clk( .clk(clk) , .frqdiv(num_fq) , .out_clk(num_clk) );
    
    reg is_next_y = 0 ;
    assign w_is_next_y = is_next_y ;
    always @( posedge num_clk ) begin    
        if( num[0]==1 ) begin
            num[0] <= 0 ;
            num[1] <= 9 ;
        end
        else if( num[1]==1 ) begin
            if( is_next_y==1 )               // 黃燈倒數時間為 5 秒
                num[1] <= 5 ;
            else begin                       // 紅燈及綠燈倒數時間為10秒
                num[0] <= 1 ;
                num[1] <= 0 ;
            end
        end
        else begin
            num[1] <= num[1] - 1 ;
        end
        
        if( is_next_y==0 && num[1]==3 ) begin      // 原本為紅燈或綠燈
            is_next_y <= 1 ;        // 則下一輪為黃燈    
        end
        else if( is_next_y==1 && num[1]==3 ) begin      // 原本為紅燈
            is_next_y <= 0 ;        // 則下一輪不為黃燈，為紅燈或綠燈     
        end
    end
    
    reg fuckU_clk = 0 ;         // 切換燈的 clock
    always @( num[1] ) begin
        if( num[1]==0 && num[0]==1 ) begin
            debug <= 1 ;            // 切換燈亮!!!
            fuckU_clk <= 1 ;      
        end
        else if( is_next_y==1 && num[1]==5 ) begin
            debug <= 1 ;            // 切換燈亮!!!
            fuckU_clk <= 1 ;         
        end
        else begin
            debug <= 0 ;
            fuckU_clk <= 0;
        end
    end
    
    reg flag = 0 ;
    always @( posedge fuckU_clk ) begin        
        if( en_r==1 ) begin         // 紅燈亮完，亮黃燈
            en_r <= 0 ;
            en_y <= 1 ;
        end
        else if( en_g==1 ) begin         // 綠燈亮玩，亮綠燈
            en_g <= 0 ;
            en_y <= 1 ;
        end
        else if( en_y==1 ) begin         // 黃燈亮完
            en_y <= 0 ;
            if( flag==0 ) begin     // flag==0 亮綠燈
                en_g <= 1 ;
                flag <= 1 ;
            end
            else begin              // flag==1 亮紅燈 
                en_r <= 1 ;
                flag <= 0 ;
            end
        end        
    end
    
    wire my_clk;
    parameter frqdiv = 10 ;
    // 進行除頻，詳細內容請見 my_clock.v 
    my_clock func_my_clk( .clk(clk) , .frqdiv(frqdiv) , .out_clk(my_clk) );
        
    reg [6:0] cnt = 0 ;    // 0~100
    always @( posedge my_clk ) begin
        i <= 1 - i ;
        
        if( cnt==100 )
            cnt <= 0 ;
        else
            cnt <= cnt + 1 ;       
    end
    
    always @( negedge my_clk ) begin
        if( cnt==100 ) begin
            if( en_r==1 ) begin
                out_r = 1 ;
            end
            if( en_y==1 ) begin
                out_r = 1 ;
                out_g = 1 ;
            end
            if( en_g==1 ) begin
                out_g = 1 ;
            end    
        end
        else if( cnt==25 ) begin
            if( en_y==1 ) begin
                out_r = 0 ;
                out_g = 0 ;
            end                
        end
        else if( cnt==50 ) begin
            out_r = 0 ;
            out_g = 0 ; 
            out_b = 0 ;
        end                  
    end
    
endmodule
