module key_find_fsm(input clk, input switch_on, input [2:0] task_wait, input [7:0] q_d,
						  output restart, output reg [4:0] address_d,
						  output [23:0] secret_key, output begin_task_1, output [1:0] continue_x, output [1:0] light);

	parameter [7:0] IDLE = 		8'b0000_0_0_0_0;
	parameter [7:0] RESTART =  8'b0001_0_0_0_1;
	parameter [7:0] START = 	8'b0010_0_0_1_0;
	parameter [7:0] WAIT_1 = 	8'b0011_0_0_0_0;
	parameter [7:0] WAIT_2 = 	8'b0100_0_0_0_0;
	parameter [7:0] WAIT_3 = 	8'b0101_0_0_0_0;
	parameter [7:0] CHECK = 	8'b0110_0_0_0_0;
	parameter [7:0] READ = 		8'b0111_0_0_0_0;
	parameter [7:0] CONT_1 = 	8'b1000_0_0_0_0;
	parameter [7:0] INCRI = 	8'b1001_0_1_0_0;
	parameter [7:0] INCRE = 	8'b1010_1_0_0_0;
	parameter [7:0] DONE = 		8'b1011_0_0_0_0;

	reg [7:0] state;
	reg [7:0] next_state;	
	reg [7:0] temp;
	reg [23:0] counter_key = 24'h000000; 
	reg [7:0] counter_addr = 5'b00000;
	reg up;
	wire incriment;

	// counter setup to go through each key value
	always @(posedge up) begin
		 if (counter_key == 24'hffffff) begin counter_key <= 24'h000000; end //if rst count = 0
		 else begin counter_key <= counter_key + 1; end     
	end 

	COUNTER_2 task3_counter(.clk(incriment), .up(1'b1), .down(1'b0), .rst(restart), .count(counter_addr));
	
	// sequential logic
	always @(posedge clk) begin
			state <= next_state;
	end

	// next_state logic
	always @(*) begin
		case (state)
			IDLE: begin // go from idle to initiate brute-forcing algorithm
						if (switch_on) begin
							next_state <= RESTART;
						end else begin
							next_state <= IDLE;
						end
					end
			RESTART: next_state <= START;
			START: next_state <= WAIT_1; // begin task 1
			WAIT_1: next_state <= (task_wait[0]) ? WAIT_2: WAIT_1; // wait for task one to complete
			WAIT_2: next_state <= (task_wait[1]) ? WAIT_3: WAIT_2; // wait for task two to complete
			WAIT_3: next_state <= (task_wait[2]) ? CHECK: WAIT_3;   // wait for task three to complete
			CHECK: begin // check if all address' have been checked
						if ((counter_addr < 5'd31)) begin
							next_state <= READ;
						end else begin
							next_state <= DONE;
						end
					 end
			READ: next_state <= CONT_1;
			CONT_1: begin // check if value is within limits
						if (((q_d >= 8'd97) && (q_d <= 8'd122)) || (q_d == 8'd32)) begin
							next_state <= INCRI;
						end else begin
							next_state <= INCRE;
						end
					  end
			INCRE: next_state <= RESTART;
			INCRI: next_state <= CHECK;
			DONE: next_state <= DONE;
			default: next_state <= IDLE;
		endcase
	end
	
	always @(*) begin
		case (state)
			//READ: temp = q_d;
			RESTART: continue_x = 2'b00;
			WAIT_1: continue_x = 2'b00;
			WAIT_2: continue_x = 2'b01;
			WAIT_3: continue_x = 2'b11;
			//DONE: light = (counter_key == 24'hffffff) ? 2'b10: 2'b01;
			default: begin temp = 8'b0; continue_x = 2'b00; end
		endcase
	end
	
	assign light = (state == DONE) ? ((counter_key == 24'hffffff)? 2'b10: 2'b01): 2'b00;

	//output logic
	assign up = state[3];
	assign restart = state[0];
	assign begin_task_1 = state[1];
	assign incriment = state[2];
	assign secret_key = counter_key; 
	assign address_d = counter_addr;

endmodule
