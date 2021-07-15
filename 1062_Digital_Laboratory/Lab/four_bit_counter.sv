`timescale 1ns / 1ps

module four_bit_counter(   
    input clk,                  // 運用NEXYS 4 DDR內建clock ( 腳位E3 )
    input dis_dir,              // 控制數字顯示方向：左到右or右到左
    input cnt_updn,             // 控制數字上數or下數
    input [2:0] speed,          // 控制數字顯示的速度
    output reg [7:0] out_dis,   //  決定顯示哪一顆七段顯示器
    output reg [6:0] out_num    // 決定七段顯示器的數字
    );
    
    reg [3:0] display = 0 ;     // 控制顯示哪一顆七段顯示器
    reg [3:0] cnt = 0 ;         // 控制七段顯示器的數字
    reg [30:0] frqdiv = 0 ;     // 用來進行除頻的變數
    reg [5:0] N = 25 ;          // 決定以frqdiv的哪一格來進行除頻 --> 決定除頻的大小
    
    always @( posedge clk )     // 除頻
        frqdiv <= frqdiv + 1 ;
    
    always @( speed ) begin     // 決定數字顯示切換的速度
        case( speed )
            3'b001:     N = 24 ;
            3'b010:     N = 23 ;
            3'b100:     N = 22 ;
            default:    N = 25 ;
        endcase
    end 
    
    always @( posedge frqdiv[ N ] ) begin
        //        going right
        if( dis_dir==1 ) begin       
            if( display==7 ) begin
                display <= 0 ;
                //                counting up
                if( cnt_updn==1 )   cnt <= cnt + 1 ;
                //                counting down
                else                cnt <= cnt - 1 ;
            end         
            else
                display <= display + 1 ;        
        end
        
        else begin
            //            going left
            if( display==0 ) begin
                display <= 7 ;
                //                counting up                
                if( cnt_updn==1 )   cnt <= cnt + 1 ;
                //                counting down                
                else                cnt <= cnt - 1 ;
            end
        
            else
                display <= display - 1 ;
        end
    end
 
    always @( display ) begin
        case( display )
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
 
    always @( cnt ) begin
        case( cnt )
            0:   out_num = 7'b0000001 ;
            1:   out_num = 7'b1001111 ;
            2:   out_num = 7'b0010010 ;
            3:   out_num = 7'b0000110 ;
            4:   out_num = 7'b1001100 ;
            5:   out_num = 7'b0100100 ;
            6:   out_num = 7'b1100000 ;
            7:   out_num = 7'b0001111 ;
            8:   out_num = 7'b0000000 ;
            9:   out_num = 7'b0001100 ;
            10:  out_num = 7'b1110010 ;
            11:  out_num = 7'b1100110 ;
            12:  out_num = 7'b1011100 ;
            13:  out_num = 7'b0110100 ;
            14:  out_num = 7'b1110000 ;
            default:    out_num = 7'b1111111 ;      //  15:
        endcase
    end                    

endmodule
