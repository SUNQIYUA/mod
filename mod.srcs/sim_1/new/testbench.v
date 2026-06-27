`timescale 1ns / 1ps

module testbench;
    
    parameter width =64;
    
    reg             clk;
    reg             rst;
    reg [width-1:0] data_in_1;
    reg [width-1:0] data_in_2;
    reg [22:0]      q;
    reg             start;
    
    wire [22:0]     data_out1;
    wire [22:0]     data_out2;

    wire            done1;
    wire            done2;

    //例化
    montgomery test1(.clk(clk), .rst(rst), .data_in(data_in_1), .q(q), .start(start), .data_out(data_out1), .done(done1));
    mont_mult  test2(.clk(clk), .rst(rst), .data_in_1(data_in_1), .data_in_2(data_in_2), .q(q), .start(start), .data_out(data_out2), .done(done2));
    k_red      test3(.clk(clk), .rst(rst), .data_in(data_in_1), .q(q), .start(start), .data_out(), .done());
    k_red_mult test4(.clk(clk), .rst(rst), .data_in_1(data_in_1), .data_in_2(data_in_2), .q(q), .start(start), .data_out(), .done());

    // 时钟
    always #5 clk = ~clk;

    initial begin
        clk      = 0;
        rst      = 0;

        data_in_1  = 0;
        data_in_2  = 0;
        q          = 0;
        
        start      = 0;


        // 复位
        #100;
        rst = 0;

        #20;
        rst = 1;

        #20
        start   = 1;
        q       = 8380417;
        data_in_1 = 123456789;
        data_in_2 = 987654321;
    end


    initial begin
        wait((done1 == 1)&(done2 == 1));
        
        #500

        $display("Simulation finished.result is ",data_out1,data_out2);
        $stop;
    end


endmodule