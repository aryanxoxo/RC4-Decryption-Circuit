module key_find_fsm_tb();

    reg clk, switch_on;
    reg [2:0] task_wait;
    reg [7:0] q_d;
    wire [4:0] address_d;
    wire restart, begin_task_1;
    wire [23:0] secret_key;
    wire [1:0] continue_x;
    wire [1:0] light;

    key_find_fsm UUT(clk, switch_on, task_wait, q_d, restart, address_d, secret_key, begin_task_1, continue_x, light);

    // clock setup(s)
    initial begin 
        forever begin
            clk = 0;
            #1;
            clk = 1;
            #1;
        end 
    end

    initial begin
        switch_on = 1'b1;
        task_wait = 2'b00;
        q_d = 8'b00100000;
        #10;
        task_wait = 2'b01;
        #4;
        task_wait = 2'b11;
        #10;
    $stop;
    end
endmodule