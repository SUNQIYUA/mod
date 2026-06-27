`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/05/14 20:58:17
// Design Name: 
// Module Name: k_red
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


module k_red#(
    parameter width =64
    //parameter r_mod_q =2365951
    )(
    input             clk,
    input             rst,
    input [width-1:0] data_in,
    input [22:0]      q,
    input             start,
    output reg        done,
    output reg [22:0] data_out


    );

    always @(posedge clk or posedge rst) begin
        if (!rst) begin
            done <= 0;

        end
        else if (start&!done) begin
            data_out <= {data_in[width-1:23],13'd0} - data_in[width-1:23]+ data_in[22:0];
            done     <= 1;
        end
    end


endmodule
