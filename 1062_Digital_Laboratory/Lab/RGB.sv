`timescale 1ns / 1ps

module RGB(
    input clk,              // 使用 NEXYS 4 DDR 內建 CMOS 振盪器 ( 腳位 E3 )
    // 此程式碼中， r = red, g = green, b = blue
    output reg out_r,
    output reg out_g,
    output reg out_b 
    );
    
    reg [6:0] r = 50 ;      // 1~50
    reg [6:0] g = 1 ;       // 1~50
    reg [6:0] b = 1 ;       // 1~50
    reg r_up = 0 ;       reg r_dn = 0 ;     // 控制 r 的上行或下行
    reg g_up = 0 ;       reg g_dn = 0 ;     // 控制 g 的上行或下行
    reg b_up = 0 ;       reg b_dn = 0 ;     // 控制 b 的上行或下行
    
    wire set_clk;
    parameter set_fq = 23 ;
    // 進行除頻，詳細內容請見 my_clock.v
    my_clock func_set_clk( .clk(clk) , .frqdiv(set_fq) , .out_clk(set_clk) );    
    
    always @( posedge set_clk ) begin    //  隨著 set_clk 調整 r, g, b 的 duty cycle 值                   
        if( r_up==1 ) 
            r <= r + 1 ;
        if( r_dn==1 ) 
            r <= r - 1 ;       
        if( g_up==1 ) 
            g <= g + 1 ;
        if( g_dn==1 ) 
            g <= g - 1 ;     
        if( b_up==1 ) 
            b <= b + 1 ;
        if( b_dn==1 ) 
            b <= b - 1 ;         
    end
    
    wire my_clk;
    parameter frqdiv = 10 ;
    // 進行除頻，詳細內容請見 my_clock.v
    my_clock func_my_clk( .clk(clk) , .frqdiv(frqdiv) , .out_clk(my_clk) );
    
    reg [6:0] cnt = 0 ;    // 0~100
    always @( posedge my_clk ) begin
        if( cnt==100 )
            cnt <= 0 ;
        else
            cnt <= cnt + 1 ;       
    end
    
    always @( negedge my_clk ) begin
        if( cnt==100 ) begin
            if( r!=1 )
                out_r = 1 ;
            if( g!=1 )
                out_g = 1 ;
            if( b!=1 )
                out_b = 1 ;
        end
        else begin
            if( r==cnt )
                out_r = 0 ;
            if( g==cnt )
                out_g = 0 ;
            if( b==cnt )
                out_b = 0 ;
        end           
                   
        if( r==50 ) begin   // b==1     //  當 r 的 duty cycle 值為 50 時
            r_up <= 0 ;             // r 的 duty cycle 值不再上升
            r_dn <= 1 ;             // 承上，改為下降
            g_up <= 1 ;             // g 的 duty cycle 值從 1 開始上升
            b_dn <= 0 ;             // b 的 duty cycle 值維持在 0
        end
        if( g==50 ) begin   // r==1     //  當 g 的 duty cycle 值為 50 時
            g_up <= 0 ;             // g 的 duty cycle 值不再上升
            g_dn <= 1 ;             // 承上，改為下降
            b_up <= 1 ;             // b 的 duty cycle 值從 1 開始上升
            r_dn <= 0 ;             // r 的 duty cycle 值維持在 0
        end
        if( b==50 ) begin   // g==1     //  當 b 的 duty cycle 值為 50 時
            b_up <= 0 ;             // b 的 duty cycle 值不再上升
            b_dn <= 1 ;             // 承上，改為下降
            r_up <= 1 ;             // r 的 duty cycle 值從 1 開始上升
            g_dn <= 0 ;             // g 的 duty cycle 值維持在 0
        end             
    end
    
endmodule
