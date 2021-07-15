`timescale 1ns / 1ps

module marquee(
    input clk,                  // 使用 NEXYS 4 DDR 內建 CMOS 振盪器 ( 腳位 E3 )
    output [7:0] out_dis,       // 控制要顯示 NEXYS 4 DDR 的哪一顆七段顯示器 
    output [6:0] out_num,       // 控制要在七段顯示器上顯示什麼
    
    input dir,                  // 控制跑馬燈 marquee 移動方向
    input [4:0] set,            // 設定out_num
    input run                   // 控制跑馬燈 marquee 是否要移動
    );
    
    reg [3:0] num [7:0];        // 儲存要顯示的內容 
    reg [2:0] i = 0 ;           // 決定當下顯示的是第 i 顆七段顯示器
    
    // 控制要在七段顯示器上顯示什麼，詳細內容請見 set_set_seg.v
    set_sev_seg func_set( num[i] , out_num ) ;
    // 控制要顯示 NEXYS 4 DDR 的哪一顆七段顯示器，詳細內容請見 dis_sev_seg.v
    dis_sev_seg func_dis( i , out_dis ) ;
    
    wire my_clk;                // 除頻後的clock
    parameter frqdiv = 10 ;   
    // 進行除頻，詳細內容請見 my_clock.v 
    my_clock func_my_clk( clk , frqdiv , my_clk );  
    
    always @( posedge my_clk ) begin 
        if( i==7 )
            i <= 0 ;
        else            
            i <= i + 1 ;                
    end     
    
    wire set_clk;   
    parameter fq_set_clk = 25 ;
    // 進行除頻，詳細內容請見 my_clock.v
    my_clock func_set_clk( clk , fq_set_clk , set_clk );
    
    reg [2:0] set_which = 0 ;   // 設定第 set_which 顆七段顯示器     
    always @( posedge set_clk ) begin
        // 在 marquee 移動時不得進行設定         
        if( run==1 ) begin      // run --> L16     
            if( dir==0 ) begin  // dir --> M13
                    num[0] <= num[1] ;    num[1] <= num[2] ;    num[2] <= num[3] ;    num[3] <= num[4] ;
                    num[4] <= num[5] ;    num[5] <= num[6] ;    num[6] <= num[7] ;    num[7] <= num[0] ;
            end
            else begin      // dir==1
                    num[2] <= num[1] ;    num[3] <= num[2] ;    num[4] <= num[3] ;    num[5] <= num[4] ;
                    num[6] <= num[5] ;    num[7] <= num[6] ;    num[0] <= num[7] ;    num[1] <= num[0] ;
            end  
        end
        // 設定七段顯示器要顯示的內容
        else begin
            case( set ) 
                    5'b00011: 
                        if( num[ set_which ]==11 )
                              num[ set_which ] <= 0 ;
                        else
                            num[ set_which ] <= num[ set_which ] + 1 ;
                    5'b00101:
                        if( num[ set_which ]==0 )
                            num[ set_which ] <= 11 ;
                        else               
                            num[ set_which ] <= num[ set_which ] - 1 ;
                    5'b01001:   
                        if( set_which==0 )
                            set_which <= 7 ;
                        else 
                            set_which <= set_which - 1 ;
                    5'b10001:  
                        if( set_which==7 )
                            set_which <= 0 ;
                        else                
                            set_which <= set_which + 1 ;
                    default:    ;
                endcase
        end        
    end                      
    
    // 初始化 initialization : 20180503
    initial begin
        num[0] = 2 ;    num[1] = 0 ;    num[2] = 1 ;    num[3] = 8 ;
        num[4] = 0 ;    num[5] = 5 ;    num[6] = 0 ;    num[7] = 3 ;
    end
endmodule
