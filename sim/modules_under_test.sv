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
	/*
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
	*/
	assign light = (state == DONE) ? ((counter_key == 24'hffffff)? 2'b10: 2'b01): 2'b00;

	//output logic
	assign up = state[3];
	assign restart = state[0];
	assign begin_task_1 = state[1];
	assign incriment = state[2];
	assign secret_key = counter_key; 
	assign address_d = counter_addr;

endmodule

module datapath_task1(clk, q, wen, address, data,finito);
input  logic        clk; 
input  logic [7:0]  q;
output logic        wen; 
output logic        finito; 
output logic [7:0]  address;
output logic [7:0]  data;
       logic [4:0]  state; 
       logic        reset_task1; 
       logic [7:0]  out_data; 
       logic        wen_reg; 
       logic [7:0]  address_reg;
       logic [7:0]  data_reg;

parameter idle                             = 5'b0000_1; 
parameter fill_s                           = 5'b0010_1; 
parameter end_state                        = 5'b1000_0; 

always_ff@(posedge clk) 
begin 
	case(state) 
	idle: 	      state <=                   fill_s    ;
	fill_s:        state <= (reset_task1)?    end_state : fill_s;  
    end_state:    state <=                   end_state ;
	default:       state <=                   idle      ; 
	endcase 
end 

always_ff@(posedge clk) 
    begin 
	    case(state) 
	    default:   begin  data_reg = out_data; address_reg = out_data;    wen_reg = state[0];end 
	    endcase 
    end 
COUNTER task1_counter(.clk(clk), .up(1'b1), .down(1'b0), .rst(reset_task1), .count(out_data)); 
assign reset_task1 = (out_data == 8'b11111111)? 1 : 0;
assign data = data_reg; 
assign address = address_reg; 
assign wen = wen_reg; 
assign finito = state[4];
 
endmodule

module datapath_task2(address,q,data,wen,commenco,clk,finito,secret_key);
input  logic [7:0]  q; 
input  logic        clk;
input  logic        commenco;
input  logic [23:0] secret_key;
output logic [7:0]  address; 
output logic [7:0]  data; 
output logic        wen;
output logic        finito; 
       logic [6:0]  state; 
       logic [7:0]  secret_key_p;
       logic        wen_reg;               //output registers
       logic [7:0]  address_reg;
       logic [7:0]  data_reg;

parameter idle          = 7'b000000_0; 
parameter read_si       = 7'b000010_0; 
parameter wait_read_si  = 7'b000100_0;
parameter compute_j     = 7'b000110_0;
parameter read_sj       = 7'b001000_0;
parameter wait_read_sj  = 7'b001010_0;
parameter write_sj      = 7'b001100_0;
parameter write_si      = 7'b001110_0;
parameter done_or       = 7'b010001_0;
parameter done_all      = 7'b010010_1;
parameter donedone      = 7'b010100_1; 

logic [7:0] i_value, i_index; 
logic [7:0] j_value, j_index; 
logic [7:0] counter_boy; 

COUNTER task2_counter(.clk(state[1]), .up(1'b1), .down(1'b0), .rst(1'b0), .count(counter_boy)); 
assign secret_key_p = (i_index % 3 == 1'b0)? secret_key[23:16] : ((i_index % 3 == 1'b1)? secret_key[15:8] : secret_key[7:0]) ; 

always_ff@(posedge clk) 
begin 
    case(state)
        idle:         state <= (commenco)?                read_si: idle;
        read_si:      state <=                            wait_read_si; 
        wait_read_si: state <=                            compute_j;
        compute_j:    state <=                            read_sj; 
        read_sj:      state <=                            wait_read_sj; 
        wait_read_sj: state <=                            write_sj; 
        write_sj:     state <=                            write_si;
        write_si:     state <=                            done_or;
        done_or:      state <= (counter_boy == 8'd256)?   done_all:read_si;
        done_all:     state <=                            donedone; 
        donedone:     state <=                            donedone; 
        default:      state <=                            idle; 
    endcase 
end 
always_ff@(posedge clk) 
begin 
    case(state)
        idle:        begin  address_reg = 8'b0; wen_reg = 1'b0; data_reg = 8'bx; end
        read_si:     begin  address_reg = counter_boy; wen_reg = 1'b0; data_reg = 8'bx; i_index =counter_boy; end
        wait_read_si:begin  i_value <= q; end
        compute_j:   begin  j_index = (counter_boy == 8'b0)? i_value + secret_key_p: i_value + j_index + secret_key_p; end
        read_sj:     begin  address_reg = j_index; wen_reg = 1'b0; data_reg = 8'bx; end
        wait_read_sj:begin  j_value <= q;  end
        write_sj:    begin  address_reg = j_index; wen_reg = 1'b1; data_reg = i_value;end
        write_si:    begin  address_reg = i_index; wen_reg = 1'b1; data_reg = j_value;end
        done_or:     begin  wen_reg = 1'b0; end

        default:     begin  address_reg = address_reg; wen_reg = wen_reg; data_reg = data_reg; 
                            i_index = i_index; j_index = j_index; 
                            i_value = i_value; j_value = j_value; end
    endcase 
end 
assign finito = state[0];
assign address = address_reg; 
assign data = data_reg; 
assign wen = wen_reg; 
endmodule

module datapath_task2b(clk,address,address_e,address_d,q,q_e,data,data_d,wen,wen_d,commenco,finito, restart);

input  logic        clk;

output logic [7:0]  address; 
output logic [4:0]  address_d; 
output logic [4:0]  address_e;
input  logic [7:0]  q; 
input  logic [7:0]  q_e; 
output logic [7:0]  data; 
output logic [7:0]  data_d; 
output logic        wen;
output logic        wen_d;

input logic         restart;
input  logic        commenco;
output logic        finito; 

       logic [6:0]  state; 
/////////////////////////////////////////////////////////////////////might not need 
       logic [7:0]  address_reg;
       logic [4:0]  address_d_reg, address_e_reg;
       logic [7:0]  data_reg;
       logic [7:0]  data_d_reg;
       logic        wen_reg;               //output registers
       logic        wen_d_reg;             //output registers
/////////////////////////////////////////////////////////////////////
       logic [7:0] i_value; 
       logic [7:0] i_index; 
       logic [7:0] j_value; 
       logic [7:0] j_index; 
       logic [7:0] k_value; 
       logic [7:0] f_value; 

parameter idle                 = 7'b000000_0; 
parameter incrament_i          = 7'b000001_0; 
parameter read_si              = 7'b000010_0; 
parameter wait_read_si         = 7'b000100_0;
parameter update_j             = 7'b000110_0;
parameter read_sj              = 7'b001000_0;
parameter wait_read_sj         = 7'b001001_0;
parameter write_sj             = 7'b001010_0;
parameter write_si             = 7'b001011_0;
parameter make_f_read_sum      = 7'b001100_0;
parameter wait_read_sum        = 7'b001101_0;
parameter wait_read_encrypted  = 7'b001110_0;
parameter write_decrypted      = 7'b001111_0;
parameter read_encrypted       = 7'b010000_0;
parameter done                 = 7'b010001_1;
parameter count_k_state        = 7'b010010_0;
parameter inc_k_state          = 7'b110011_0;
logic [7:0] counter_boy; 
//COUNTER task2b_counter(.clk(state[6]), .up(1'b1), .down(1'b0), .rst(1'b0), .count(counter_boy)); 
COUNTER_2 task2b_counter(.clk(state[6]), .up(1'b1), .down(1'b0), .rst(restart), .count(counter_boy)); 

always_ff@(posedge clk) 
begin 
    case(state)
        idle:                state <= (commenco)? incrament_i: idle; 
        incrament_i:         state <= read_si; 
        read_si:             state <= wait_read_si; 
        wait_read_si:        state <= update_j; 
        update_j:            state <= read_sj; 
        read_sj:             state <= wait_read_sj;
        wait_read_sj:        state <= write_sj;
        write_sj:            state <= write_si;
        write_si:            state <= make_f_read_sum;
        make_f_read_sum:     state <= wait_read_sum;
        wait_read_sum:       state <= read_encrypted;
        read_encrypted:      state <= wait_read_encrypted;
        wait_read_encrypted: state <= write_decrypted;
        write_decrypted:     state <= count_k_state; 
        count_k_state:       state <= (counter_boy < 31)? inc_k_state : done; 
        inc_k_state:         state <= incrament_i; 
		  done:                state <= (restart)? idle: done; 
        default:             state <= idle; 
    endcase 
end 
always_ff@(posedge clk) 
begin 
    case(state)
        idle:                begin  address_reg = 8'b0; address_d_reg = 8'b0; address_e_reg = 8'b0; 
												wen_reg = 1'b0;     wen_d_reg = 1'b0;          
												data_reg = 8'b0;    data_d_reg = 8'b0;  
												i_index = 8'b0; j_index = 8'b0; 
												i_value = 8'b0; j_value = 8'b0; k_value = 8'b0; 
												f_value = 8'b0; end


        incrament_i:         begin  i_index = i_index + 8'b1 ;  end
        read_si:             begin  address_reg = i_index;   end
        wait_read_si:        begin  i_value <= q; end
        update_j:            begin  j_index = j_index + i_value; end
        read_sj:             begin  address_reg = j_index; end
        wait_read_sj:        begin  j_value <= q;  end
        write_sj:            begin                          data_reg = i_value; wen_reg = 1'b1;end
        write_si:            begin  address_reg = i_index;  data_reg = j_value;                end
        make_f_read_sum:     begin  address_reg = (i_value + j_value); wen_reg = 1'b0; end
        wait_read_sum:       begin  f_value <= q; end 
        read_encrypted:      begin  address_e_reg = counter_boy[4:0];  end         
        wait_read_encrypted: begin  k_value <= q_e; end
        write_decrypted:     begin  address_d_reg = counter_boy[4:0]; data_d_reg = k_value ^ f_value; wen_d_reg = 1'b1;  end
		  count_k_state:     begin  wen_d_reg = 1'b0; end

        default:   			 begin  address_reg = address_reg; address_d_reg = address_d_reg; address_e_reg = address_e_reg; 
											  wen_reg = wen_reg;         wen_d_reg = wen_d_reg;          
											  data_reg = data_reg;       data_d_reg = data_d_reg;  
											  i_index = i_index; j_index = j_index; 
											  i_value = i_value; j_value = j_value; k_value = k_value; 
											  f_value = f_value; end
    endcase 
end 
assign finito = state[0];
assign address = address_reg; 
assign data = data_reg; 
assign wen = wen_reg; 

assign address_d = address_d_reg; 
assign wen_d = wen_d_reg;
assign data_d = data_d_reg; 
assign address_e = address_e_reg; 
 
endmodule

module COUNTER(clk, up, down, rst, count); 
 
input up, down, rst, clk; 
output reg [8:0] count; 
reg [8:0] counterino = 9'd0; 
always_ff @(posedge clk)
begin
    if (rst)    begin counterino <= 9'd0; end                 //if rst count = 0
    else if (up) begin counterino <= counterino + 9'd1; end     //if up then count > 0
    else if (down) begin counterino <= counterino - 9'd1; end   //if down then count < 0
    else begin counterino <= counterino; end
end 
assign count = counterino; 
endmodule

module COUNTER_2(clk, up, down, rst, count); 
 
input up, down, rst, clk; 
output reg [7:0] count; 
reg [7:0] counterino = 8'd0; 
always_ff @(posedge clk, posedge rst)
begin
    if (rst)    begin counterino <= 8'd0; end                 //if rst count = 0
    else if (up) begin counterino <= counterino + 8'd1; end     //if up then count > 0
    else if (down) begin counterino <= counterino - 8'd1; end   //if down then count < 0
    else begin counterino <= counterino; end
end 
assign count = counterino; 
endmodule