`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/07 20:26:32
// Design Name: 
// Module Name: montgomery
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

(* use_dsp = "no" *)
module montgomery#(
    parameter width =64,
    parameter r_mod_q =2365951
    )(
    input clk,
    input rst,
    input [width-1:0]data_in,
    input [22:0]q,
    input start,
    output reg done,
    output reg [22:0]data_out

    );

    wire [width+21:0] s21 = data_in << 21;
    wire [width+21:0] s18 = data_in << 18;
    wire [width+21:0] s12 = data_in << 12;
    wire [width+21:0] s11 = data_in << 11;
    wire [width+21:0] s9  = data_in << 9;

    (* keep = "true" *) wire [width+21:0] sum1 = s21 + s18;
    (* keep = "true" *) wire [width+21:0] sum2 = sum1 + s12;
    (* keep = "true" *) wire [width+21:0] sum3 = sum2 + s11;
    (* keep = "true" *) wire [width+21:0] sum4 = sum3 + s9;

    //根据输入数据data_in末位的奇偶判断是否补充q，使其移位时数据不变
    wire [width-1:0] plus = data[0] ? { {(width-1-23){1'b0}}, Q } : {(width){1'b0}}; 
    wire [width-1:0] data_after = (data+plus)>>1;

    (* keep = "true" *) wire [2*width:0]data_tran = sum4 - data_in;

    reg [22:0] Q;
    reg [width:0]data;
    reg [10:0] cnt;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            data <= 0;
            cnt  <= 0;
            Q    <= 0;
            data_out <= 0;
            done <= 0;
            
        end
        else if (start&(!done)) begin
            if (cnt == 0) begin
                data <= data_tran;
                Q    <= q;
                cnt  <= cnt+1;
            end
            else if (cnt < width+1) begin
                data <= data_after;
                cnt <= cnt+1;
            end
            else begin
                if (data >= Q) begin
                    data <= data -Q;
                    //done <= 1;
                end
                else begin
                    data_out <= data;
                    done     <= 1;
                end
            end

        end
    end

endmodule
