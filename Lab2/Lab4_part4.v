
module seccounter(
input wire clk,
input wire rst,
output reg [3:0] slow_counter // 1초마다 1씩 증가하는 slow counter
); // seccounter의 포트 선언
parameter N = 26;
reg [N-1:0] fast_counter; // 50MHz clock signal

assign is_slow_counter_9 = (slow_counter == 4'd9); // slow counter가 9인지 판별

always @(posedge clk or posedge rst) // active high asynchronous reset
if (rst)
	fast_counter <= {N{1'b0}};
else
	fast_counter <= fast_counter + 1'b1; // reset이 1이 아닐 경우 fast count에 +1

always @(posedge clk or posedge rst)
	if(rst)
	slow_counter <= 4'd0;
	else if( (fast_counter == 26'b10111110101111000010000000) & ~(is_slow_counter_9)) // fast counter가 5*10^(7)이면
	begin
	slow_counter <= slow_counter + 1'b1;         //  slow counter에 1을 더하고 fast counter는 0으로 초기화
	fast_counter <= {N{1'b0}};
	end 
	else if( (fast_counter == 26'b10111110101111000010000000) & (is_slow_counter_9)) // slow counter가 9이고,
	begin                                                   // fast counter가 5*10^(7)이면,
	slow_counter <= 4'd0;                                   // slow counter, fast counter 둘 다 0으로 초기화한다.
	fast_counter <= {N{1'b0}};
	end
	
endmodule	
	

`timescale 1ns/1ns // timescale 선언 timeunit = 1ns
module lab2part4tb();

reg clk;
reg rst;
wire [3:0] slow_counter;

seccounter u(clk, rst, slow_counter); // seccounter module instantiation

initial begin

clk = 1'b0;
#1 rst = 1'b1;
#1 rst = 1'b0; 
forever #10 clk = ~clk; // clock의 한 주기는 20ns가 되려면 clock은 10ns마다 반전이 되어야 한다.

end

endmodule

