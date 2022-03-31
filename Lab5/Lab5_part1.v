
module lab5part1 #(parameter n=5, parameter endvalue = 5'd20) // 5bit, endvalue 선언
( 	input wire clk,
	input wire rst,
	input wire en,
	output wire rollover,
	output reg [n-1:0] value
	);
	
	wire [n-1:0] next_value;
	always @ (posedge clk)
		if (~rst) value <= {n{1'b0}}; // rst = 0일때 초기화
		else if (rollover) value <= {n{1'b0}}; //rollover이 1일때 value = 0
		else value <= next_value; // rolloverdl 0일때 +1
		
		assign next_value = value + en; //enable이 1일때 동작
		assign rollover = (value == endvalue);
		
	endmodule
    
module tb_lab5part1();
	reg clk;
	reg rst;
	reg en;
	wire rollover;
	wire [4:0] value;

lab5part1 u0(.clk(clk) ,.rst(rst),.en(en) ,.rollover(rollover) ,.value(value));



initial begin
	en = 1;
	clk = 1'b0;
	forever #5 clk = ~clk;
end

initial begin
	rst = 1;
	#3 rst = 0;
	#3 rst = 1;
end

endmodule
