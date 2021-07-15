`timescale 1ns / 1ps

module pwm(
    input clk,                  // 使用 NEXYS 4 DDR 內建 CMOS 振盪器 ( 腳位 E3 )
    input [6:0] in_duty_cyc,    // 決定 duty cycle 的值
    output reg out_pulse = 0    // output 連接 pmod 腳位
    );

    reg [6:0] cnt = 0 ;         // 計數器 0~100
    reg [10:0] my_cnt = 0 ;     // 用於除頻
    reg my_clk = 0 ;            // 除頻後的 clk
    
    always @( posedge clk ) begin
        // 根據示波器顯示，設置 cnt==1995 比 cnt==1999 來的接近 500Hz
        if( my_cnt==1995 ) begin   
            my_cnt <= 0 ;
            my_clk <= 1 ;
        end
        else begin
            my_cnt <= my_cnt + 1 ;
            my_clk <= 0 ;
        end
    end
    
    always @( posedge my_clk ) begin
        if( cnt==100 ) begin
            cnt <= 0 ;
            if( in_duty_cyc!=0 )    // 當 duty cycle 不為 0% 時， output 升上去為 1
                out_pulse <= 1 ;
        end
        else if( cnt==(in_duty_cyc+1) ) begin   // 如果已經到達想要的 duty cycle
            cnt <= cnt + 1 ;
            if( in_duty_cyc!=100 )
                out_pulse <= 0 ;                // 則 output 降為 0
        end
        else begin
            cnt <= cnt + 1 ;
        end   
    end

endmodule
