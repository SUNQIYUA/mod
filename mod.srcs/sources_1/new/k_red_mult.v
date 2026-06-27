`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/14 21:53:35
// Design Name: 
// Module Name: k_red_mult
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module k_red_mult#(
    parameter width   = 64
    //parameter r_mod_q = 2365951
    )(    
    input             clk,
    input             rst,
    input [width-1:0] data_in_1,
    input [width-1:0] data_in_2,
    input [22:0]      q,
    input             start,
    output reg        done,
    output reg [22:0] data_out

    );

    wire [width-1:0] buff_s;

    reg  [width-1:0] s;

    (* use_dsp = "no" *)wire [width-1:0] buff;

    reg  [width-1:0] data1;
    reg  [width-1:0] data2;
    reg  [10:0]      cnt;


    assign buff_s = (s<<1)+(data2[width-1]?data1:0);
    assign buff = (buff_s[22:0]+buff_s[width-1:23]*8191);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            //Q        <= 0;
            s        <= 0;
            data1    <= 0;
            data2    <= 0;

            cnt      <= 0;

            //temp     <= 0;
            done     <= 0;
            data_out <= 0;
            
        end
        else if (start&!done) begin
            if (cnt == 0) begin
                data1 <= data_in_1 ;
                data2 <= data_in_2;
                cnt   <= cnt +1;
                //Q <={{(width-1-22){1'b0}},q};

            end
            else if (cnt < width+1)begin
                s      <= buff;

                data2  <=  data2 << 1;
                
                cnt    <=  cnt+1;

            end
            else begin
                if (s>q) begin
                    s <= s-q;
                end
                else begin
                   data_out <= s;
                   done     <= 1; 
                end
                
            end
            
        end
    end

endmodule
