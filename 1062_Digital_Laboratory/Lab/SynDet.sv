`timescale 1ns / 1ps

module SynDet(
    input clk,      // e3 or d14(JB1)
    input data_in,  // f16(JB2)
    output led_clk,
    output reg led_data_in,
    output reg [3:0] series,
    output reg out_detected = 0
    );
    
    reg my_clk;
//    assign my_clk = clk ;
    reg [31:0] cnt = 0 ;
    
    assign led_clk = my_clk ;
    reg [3:0] target = 4'b1011 ;

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
    
    always @( posedge my_clk ) begin
        if( data_in==1 )
            led_data_in <= 1 ;
        else
            led_data_in <= 0 ;
            
        series <= series*2 + data_in ;
    end
    
    initial begin
        series = 0 ;
    end
    
endmodule
