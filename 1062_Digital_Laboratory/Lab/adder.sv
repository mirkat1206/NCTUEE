`timescale 1ns / 1ps

module adder(
     input clk,
     input AorB,    // A-->0    B-->1
     input [6:0] keyboard,
     input show_ans,
     input reset,
     output [7:0] out_dis,
     output [6:0] out_num,
     
     output out_AorB,
     output out_trigger
    );
//     assign led_key = keyboard ;
     
     assign out_AorB = AorB ;
     reg [3:0] num_AB [1:0] ;
     reg [3:0] b_num;
     wire [3:0] a_num;
     
     keyboard2num func_k2n( .keyboard(keyboard) , .k_in_num( a_num ) );
     reg trigger;
     assign out_trigger = trigger ;
     always @( negedge trigger ) begin        
        if( reset==1 )
            num_AB[ AorB ] <= 0 ;
        else
            num_AB[ AorB ] <= a_num ;
     end
          
     reg i = 1 ;
     reg [3:0] out_number;
          reg [3:0] num_show;
     set_sev_seg func_set( .num(num_show) , .w_out_num(out_num) );
     dis_sev_seg func_dis( .i(i+6) , .w_out_dis(out_dis) );
          
     wire my_clk;
     parameter frqdiv = 10 ;
     my_clock func_my_clk( .clk(clk) , .frqdiv(frqdiv) , .out_clk(my_clk) );
     
     reg [4:0] ans;

     always @( posedge my_clk ) begin
        if( show_ans==1 ) begin
            i <= i + 1 ;
            if( i==1 )
                num_show <= ans/10 ;
            else
                num_show <= ans%10 ;
        end
        else begin
            i <= 1 ;
            num_show <= num_AB[AorB] ;
        end
        
        ans <= num_AB[0] + num_AB[1] ;
            
        if( a_num==0 )
            trigger <= 1 ;
        else
            trigger <= 0 ;
     end
     
     wire set_clk;
     parameter set_fq = 20 ;
     my_clock func_set_clk( .clk(clk) , .frqdiv(set_fq) , .out_clk(set_clk) );
     
     always @( posedge set_clk ) begin
        
     end
     
     initial begin
        num_AB[0] = 0 ;     num_AB[1] = 0 ;
     end
    
endmodule
