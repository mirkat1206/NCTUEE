`timescale 1ns / 1ps

module AsyDet(
    input clk,      // e3 or d14(JB1)
    input data_in,  // f16(JB2)
    input [4:0] target,
    output led_clk,
    output reg led_data_in,
    output reg [4:0] series,
    output reg out_detected = 0,
    
    output reg led_cnt1,
    output reg led_cnt2,
    output reg led_cnt3,
    output reg led_cnt4,
    output reg led_cnt5
    );
    
    reg my_clk;
    //    assign my_clk = clk ;
    reg [31:0] cnt = 0 ;
    
    assign led_clk = my_clk ;
    
    always @( posedge clk ) begin
        if(cnt==100_000_000) begin
            my_clk <= 1;
            cnt <= 0;
        end
        else if (cnt<50_000_000) begin
            my_clk <= 1;
            cnt <= cnt + 1;
        end
        else begin
            my_clk <= 0;
            cnt <= cnt + 1;
        end
        
        if( series==target )
            out_detected <= 1 ;
        else
            out_detected <= 0 ;           
    end
    
    reg [2:0] flag_cnt = 5 ;
    reg flag = 0 ;
    always @( posedge my_clk ) begin
        if( data_in==1 ) begin
            led_data_in <= 1 ;
        end
        else begin
            led_data_in <= 0 ;
        end
        
        if( flag==1 )
             series <= series*2 + data_in ;           
        
            if( flag_cnt>4 && data_in==1 ) begin
                flag_cnt <= 5 ;
                flag <= 0 ;
            end
            else if( flag_cnt>4 && data_in==0 ) begin
                flag_cnt <= 0 ;
                flag <= 1 ;
            end
            else begin
                flag_cnt <= flag_cnt + 1 ;
                flag <= 1 ;
            end
             
       if( flag_cnt==1 ) begin    led_cnt1 <= 1 ; led_cnt2 <= 0 ; led_cnt3 <= 0 ; led_cnt4 <= 0 ; led_cnt5 <= 0 ;        end
       if( flag_cnt==2 ) begin    led_cnt1 <= 0 ; led_cnt2 <= 1 ; led_cnt3 <= 0 ; led_cnt4 <= 0 ; led_cnt5 <= 0 ;        end
       if( flag_cnt==3 ) begin    led_cnt1 <= 0 ; led_cnt2 <= 0 ; led_cnt3 <= 1 ; led_cnt4 <= 0 ; led_cnt5 <= 0 ;        end
       if( flag_cnt==4 ) begin    led_cnt1 <= 0 ; led_cnt2 <= 0 ; led_cnt3 <= 0 ; led_cnt4 <= 1 ; led_cnt5 <= 0 ;        end
       if( flag_cnt==5 ) begin    led_cnt1 <= 0 ; led_cnt2 <= 0 ; led_cnt3 <= 0 ; led_cnt4 <= 0 ; led_cnt5 <= 1 ;        end                                          
    end
    
    
    initial begin
        series = 0 ;
    end

endmodule
