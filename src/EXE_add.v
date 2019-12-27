/*
 *adder/subtractor that simulates a two cycle delay for both operations
 *
 *
 *
 * */
module EXE_add(
	input clk,
	input rst_n,
	input start,
	input Op,
	input [31:0] a,
	input [31:0] b,
	output valid,
	output reg [31:0] result
);
localparam IDLE = 0,BUSY = 1;
reg state,next_state;
reg [31:0] delay0,delay0_next;
reg counter, counter_next;
always@(posedge clk)begin
	if(~rst_n)begin
		result <= 0;
		delay0 <= 0;
		counter <= 0;
	end else begin
		result <= delay0;
		delay0 <= delay0_next;
		counter <= counter_next;	
	end
end

//computation logic
always@(*)begin
	case(Op)
		1'b0:	delay0_next = a + b;
		1'b0:   delay0_next = a - b;
	endcase
end

//valid control via a FSM ,control signals start and the counter value

always@(*)begin
	case(state)
		IDLE:	begin
					if(start)begin
						next_state = BUSY;
						counter_next = counter+1;
					end else begin
						next_state = IDLE;
						counter_next = counter;
					end
				end
		BUSY:	begin
					counter_next = counter + 1;
					if(counter == 1)begin
						next_state = IDLE;
					end else begin
						next_state = BUSY;
					end	
				end
	endcase
end

assign valid = (counter==1)?1:0;


endmodule
