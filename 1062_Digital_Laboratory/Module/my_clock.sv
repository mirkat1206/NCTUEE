`timescale 1ns / 1ps

module my_clock(
    input clk,                  // 使用 NEXYS 4 DDR 內建 CMOS 振盪器 ( 腳位 E3 )
    input [10:0] frqdiv,        // ( 輸入頻率 ) / ( 2 ^ frqdiv ) = ( 輸出頻率 )
    output out_clk              // 輸出頻率
    );
    
    reg [30:0] cnt = 0 ;        // 計數器 counter
    assign out_clk = cnt[ frqdiv ] ;
    
    always @( posedge clk )
        cnt <= cnt + 1 ;
    
endmodule
