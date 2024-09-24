module datapath_task2b_tb();

    reg clk;
    reg restart;
    reg commenco;
    reg [7:0] q; 
    reg [7:0] q_e; 
    wire [7:0] data; 
    wire [7:0] data_d; 
    wire [7:0] address; 
    wire [4:0] address_d; 
    wire [4:0] address_e;
    wire finito, wen_d, wen; 

    datapath_task2b UUT(clk, address, address_e, address_d, q, q_e, data, data_d, wen, wen_d, commenco, finito, restart);

    // clock setup
    initial begin 
        forever begin
            clk = 0;
            #1;
            clk = 1;
            #1;
        end 
    end

    initial begin
        restart = 1'b0;
        q = 8'b00000000;
        q_e = 8'b00000000;
        commenco = 1'b0;
        #6;
        commenco = 1'b1;
        #4;
        commenco = 1'b0;
        #12;
        restart = 1'b1;
        #4;
    $stop;
    end
endmodule