
module lab5part3(
	input wire clk,
	input wire rst,
	input wire en,
	output wire [6:0] digit5,
	output wire [6:0] digit4,
	output wire [6:0] digit3,
	output wire [6:0] digit2,
	output wire [6:0] digit1,
	output wire [6:0] digit0);
	
wire u1_rollover, u0_rollover, u2_rollover;
	
wire [7:0] u1_value, u2_value, u3_value;

lab5part1 #(.n(26), .endvalue(26'd500000)) u0(.en(en), .clk(clk), .rst(rst), .rollover(u0_rollover)); 
//50MHz이므로 endvalue = 50만일 때 rollover =1, 0.01초마다 u0_rollover가 1이 된다.
lab5part1 #(.n(7), .endvalue(7'd100)) u1(.en(u0_rollover), .clk(clk), .rst(rst), .rollover(u1_rollover), .value(u1_value));
//100 x 0.01초 = 1초가 되므로, en = u0_rollover, endvalue = 100, rollover = u1_rollover
lab5part1 #(.n(6), .endvalue(6'd60)) u2(.en(u1_rollover), .clk(clk), .rst(rst), .rollover(u2_rollover), .value(u2_value));
//60초가 1분이 되므로, en = u1_rollover, endvalue = 60, rollover = u2_rollover
lab5part1 #(.n(6), .endvalue(6'd60)) u3(.en(u2_rollover), .clk(clk), .rst(rst), .value(u3_value)); 
//60분이 되면 reset하므로, en = u2_rollover, endvalue = 60

segdec dec0(.i(u1_value%4'd10), .o(digit0));
segdec dec1(.i(u1_value/4'd10), .o(digit1));
segdec dec2(.i(u2_value%4'd10), .o(digit2));
segdec dec3(.i(u2_value/4'd10), .o(digit3));
segdec dec4(.i(u3_value%4'd10), .o(digit4));
segdec dec5(.i(u3_value/4'd10), .o(digit5)); // segment decoder instantiation

endmodule

module lab5part1 #(parameter n=5, parameter endvalue = 5'd20) // part 1 module
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

module segdec //lab4part1에 연결할 7segdisplay 1일때 꺼지고 0일때 켜짐
( input wire [3:0] i,
output reg [6:0] o);
	
	always @ *
	case(i) //case문으로 각 상황에 맞춰 구현.
	4'b0000 : o = {7'b1000000}; //0의 형태
	4'b0001 : o = {7'b1111001}; //1의 형태
	4'b0010 : o = {7'b0100100}; //2의 형태
	4'b0011 : o = {7'b0110000}; //3의 형태
	4'b0100 : o = {7'b0011001}; //4의 형태
	4'b0101 : o = {7'b0010010}; //5의 형태
	4'b0110 : o = {7'b0000010}; //6의 형태
	4'b0111 : o = {7'b1111000}; //7의 형태
	4'b1000 : o = {7'b0000000}; //8의 형태
	4'b1001 : o = {7'b0010000}; //9의 형태
	4'b1010 : o = {7'b0001000}; //A의 형태
	4'b1011 : o = {7'b0000011}; //b의 형태
	4'b1100 : o = {7'b1000110}; //C의 형태
	4'b1101 : o = {7'b0100001}; //d의 형태
	4'b1110 : o = {7'b0000110}; //E의 형태
	4'b1111 : o = {7'b0001110}; //F의 형태
	endcase
	
endmodule
	

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

`timescale 10ns/10ns
module lab5part3tb;
reg clk, rst, en;
wire [6:0] digit5, digit4, digit3, digit2, digit1, digit0;

initial begin
rst = 0;
clk = 0;
en = 1;
#1 clk = 1;
#1 clk = 0;
#1 rst = 1;
#1 clk = 1; // 초기값 설정 및 초기화
end


initial begin
clk = 0;
forever #1 clk = ~clk; // 20ns마다 clockpulse 발생
end

lab5part3 u0(clk, rst, en, digit5, digit4, digit3, digit2, digit1, digit0);

endmodule
