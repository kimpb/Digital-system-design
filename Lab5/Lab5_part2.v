module lab5part2(
	input wire clk,
	input wire rst,
	input wire en,
	output wire [6:0] digit2, //100의자리
	output wire [6:0] digit1, //10의자리
	output wire [6:0] digit0, //1의자리
	output wire u1_rollover,
	output wire u0_rollover,
	output wire u2_rollover,
	output wire u1_en,
	output wire u2_en,
	output wire u3_en);
	
wire [3:0] u1_value, u2_value, u3_value; 

lab5part1 #(.n(26), .endvalue(26'd50000000)) u0(.en(en), .clk(clk), .rst(rst), .rollover(u0_rollover)); //1초에 한번씩 rollover 검출
lab5part1 #(.n(4), .endvalue(4'd10)) u1(.en(u0_rollover), .clk(clk), .rst(rst), .rollover(u1_rollover), .value(u1_value)); 
// 10번의 u0_rollover이 생길때 u1_rollover 검출
lab5part1 #(.n(4), .endvalue(4'd10)) u2(.en(u1_rollover), .clk(clk), .rst(rst), .rollover(u2_rollover), .value(u2_value)); 
//10번의 u1_rollover이 생길때 u2_rollover 검출
lab5part1 #(.n(4), .endvalue(4'd10)) u3(.en(u2_rollover), .clk(clk), .rst(rst), .value(u3_value));
// 10번의 u2_rollover 생길때 u2_rollover 검출

segdec dec0(.i(u1_value), .o(digit0)); // 7seg 연결
segdec dec1(.i(u2_value), .o(digit1));
segdec dec2(.i(u3_value), .o(digit2));

endmodule

//7segment display
module segdec
( input wire [3:0] i,
output reg [6:0] o);
	
	always @ *
	case(i) 
	4'b0000 : o = {7'b1000000}; //0
	4'b0001 : o = {7'b1111001}; //1
	4'b0010 : o = {7'b0100100}; //2
	4'b0011 : o = {7'b0110000}; //3
	4'b0100 : o = {7'b0011001}; //4
	4'b0101 : o = {7'b0010010}; //5
	4'b0110 : o = {7'b0000010};//6
	4'b0111 : o = {7'b1111000};//7
	4'b1000 : o = {7'b0000000}; //8
	4'b1001 : o = {7'b0010000};//9
	4'b1010 : o = {7'b0001000};//A
	4'b1011 : o = {7'b0000011};//B
	4'b1100 : o = {7'b1000110}; //C
	4'b1101 : o = {7'b0100001}; //D
	4'b1110 : o = {7'b0000110};//E
	4'b1111 : o = {7'b0001110};//F
	endcase
	
endmodule
	
// part1 counter
module lab5part1 #(parameter n=5, parameter endvalue = 5'd20)
( 	input wire clk,
	input wire rst,
	input wire en,
	output wire rollover,
	output reg [n-1:0] value
	);
	
	wire [n-1:0] next_value;
	always @ (posedge clk)
		if (~rst) value <= {n{1'b0}};
		else if (rollover) value <= {n{1'b0}};
		else value <= next_value;
		
		assign next_value = value + en;
		assign rollover = (value == endvalue);
		
	endmodule
	

//lab5part2 testbench
`timescale 10ns/1ns 
module lab5part2tb;
reg clk, rst, en;
wire [6:0] digit2, digit1, digit0;
wire u0_rollover, u1_rollover, u2_rollover;

initial begin
rst = 0;
clk = 0;
#2 rst = 1;
clk = 1;
en = 1;
end //초기값 설정


initial begin
clk = 0;
forever #1 clk = ~clk; // clockpulse는 20ns마다 한번 발생
end

lab5part2 u0(clk, rst, en, digit2, digit1, digit0, u1_rollover, u0_rollover, u2_rollover);

endmodule

