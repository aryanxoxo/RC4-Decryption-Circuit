module datapath_task1_testbench; 
reg clk;
reg [7:0] q; 
wire       wen,finito;
wire [7:0] address, data;

datapath_task1 inst_task1(.clk(clk), .q(q), .wen(wen), .address(address), .data(data),.finito(finito));

initial begin 
clk = 1;  q = 0 ; #100; 
clk = 0; q = 0 ; #100; 
clk = 1;  q = 0 ; #100; 
clk = 0; q = 0 ; #100; 
clk = 1;  q = 0 ; #100; 
clk = 0;   q = 0 ; #100; 
clk = 1;  q = 0 ; #100; 
clk = 0;  q = 0 ; #100; 
clk = 1;   q = 0 ; #100; 
clk = 0;   q = 0 ; #100; 
clk = 1;   q = 0 ; #100; 
clk = 0;   q = 0 ; #100; 
clk = 1;   q = 0 ; #100; 
clk = 0;   q = 0 ; #100; 
clk = 1;   q = 0 ; #100; 
clk = 0;   q = 0 ; #100; 
clk = 1;   q = 0 ; #100; 
clk = 0;   q = 0 ; #100; 
clk = 1;  q = 0 ; #100; 
clk = 0;  q = 0 ; #100; 
clk = 1;  q = 0 ; #100; 
clk = 0;  q = 0 ; #100; 
clk = 1;   q = 0 ; #100; 
clk = 0;  q = 0 ; #100; 
clk = 1;   q = 0 ; #100; 
clk = 0;  q = 0 ; #100; 
clk = 1;  q = 0 ; #100; 
clk = 0;  q = 0 ; #100; 
clk = 1;  q = 0 ; #100; 
clk = 0;   q = 0 ; #100; 
clk = 1;   q = 0 ; #100; 
clk = 0; q = 0 ; #100; 
clk = 1;  q = 0 ; #100; 
clk = 0;   q = 0 ; #100; 
clk = 1;   q = 0 ; #100; 
clk = 0;   q = 0 ; #100; 
clk = 1;   q = 0 ; #100; 
clk = 0;   q = 0 ; #100; 
clk = 1;  q = 0 ; #100; 
clk = 0;   q = 0 ; #100; 
clk = 1;   q = 0 ; #100; 
clk = 0;  q = 0 ; #100; 
clk = 1;  q = 0 ; #100; 
end 
endmodule