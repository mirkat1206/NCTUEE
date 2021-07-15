`timescale 1ns / 1ps

module seven_segment_display(
    input [3:0] in_num,
    input [7:0] in_dis,
    input dp,
    
    output [7:0] out_dis,
    output [6:0] out_num,
    output dotpoint
    );                                                   
    
    assign out_dis[0] = ~in_dis[0] ;  
    assign out_dis[1] = ~in_dis[1] ; 
    assign out_dis[2] = ~in_dis[2] ; 
    assign out_dis[3] = ~in_dis[3] ; 
    assign out_dis[4] = ~in_dis[4] ; 
    assign out_dis[5] = ~in_dis[5] ; 
    assign out_dis[6] = ~in_dis[6] ;
    assign out_dis[7] = ~in_dis[7] ;  
    
    // in_num[0123] = wxyz
    assign out_num[0] = ~(( ~in_num[0] & ~in_num[1] & ~in_num[3] )|( ~in_num[0] & in_num[2] & in_num[3] )|
                        ( in_num[0] & ~in_num[1] & ~in_num[2] )|( in_num[1] & ~in_num[2] & in_num[3] )) ;
    assign out_num[1] = ~(( ~in_num[0] & ~in_num[1] )|( ~in_num[2] & ~in_num[3] )|
                        ( ~in_num[0] & in_num[2] & in_num[3] )|( ~in_num[1] & ~in_num[2] )) ;                                    
    assign out_num[2] = ~(( ~in_num[0] & in_num[1] )|( ~in_num[1] & ~in_num[2] )|
                        ( ~in_num[1] & in_num[3] )) ;                                                         
    assign out_num[3] = ~(( ~in_num[1] & ~in_num[3] )|( ~in_num[1] & in_num[2] )|
                        ( in_num[1] & ~in_num[2] & in_num[3] )|( in_num[2] & ~in_num[3] )) ;
    assign out_num[4] = ~(( ~in_num[1] & ~in_num[3] )|( ~in_num[0] & in_num[2] & ~in_num[3] )|
                        ( in_num[0] & in_num[1] & in_num[2] & in_num[3] )) ;
    assign out_num[5] = ~(( ~in_num[2] & ~in_num[3] )|( in_num[1] & ~in_num[2] )|
                        ( in_num[1] & ~in_num[3] )|( in_num[0] & ~in_num[2] )) ;                    
    assign out_num[6] = ~(( ~in_num[1] & in_num[2] )|( in_num[1] & ~in_num[2] )|
                        ( in_num[0] & ~in_num[1] )|( in_num[2] & ~in_num[3] )) ;
    
    assign dotpoint = ~dp ;    
endmodule
