`timescale 1ns / 1ps

module pwm_generator(
    input clk,
    input [6:0] in_duty_cyc,
    
    output [6:0] out_num,
    output [7:0] out_dis,
    output reg out_pulse = 0,
    output led_debug    
    );
    
    reg [6:0] duty_cyc;
    reg [6:0] cnt = 0 ;
    reg [3:0] out_cnt;
    reg [2:0] i = 0 ;
    
    assign led_debug = out_pulse ;
    set_sev_seg func_set( out_cnt , out_num );
    dis_sev_seg func_dis( i , out_dis );
        
    wire my_clk;
    parameter frqdiv = 10 ;
    my_clock func_my_clk( clk , frqdiv , my_clk );
    
    always @( posedge my_clk ) begin
        if( i==2 ) begin
            i <= 0 ;
            out_cnt <= ( cnt/100 )%10 ;
        end
        else if( i==1 ) begin
            i <= 2 ;
            out_cnt <= cnt%10 ;            
        end
        else begin
            i <= 1 ;
            out_cnt <= ( cnt/10 )%10 ;            
        end
    end
    
    wire basic_clk;    
    parameter basic_frqdiv = 10 ;           // for pwm
//    parameter basic_frqdiv = 20 ;           // for debug
    my_clock func_basic_clk( clk , basic_frqdiv , basic_clk );
    
    always @( posedge basic_clk ) begin
        if( cnt==100 ) begin
            cnt <= 0 ;
            if( in_duty_cyc!=0 )
                out_pulse <= 1 ;
        end
        else if( cnt==(in_duty_cyc+1) ) begin
            cnt <= cnt + 1 ;
            if( in_duty_cyc!=100 )
                out_pulse <= 0 ;
        end
        else begin
            cnt <= cnt + 1 ;
        end   
    end
    
endmodule
