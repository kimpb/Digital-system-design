module lab4part2(
	input wire [7:0] A, //8bit 입력값
	input wire clk,
	input wire rst,
	input wire add_sub, //2-1MUX입력 0일때 add, 1일때 sub
	output reg overflow,
	output reg carry,
	output wire [7:0] sum,
	output wire [6:0] hex3,
	output wire [6:0] hex2,
	output wire [6:0] hex1,
	output wire [6:0] hex0
	);
	
	
	
	reg [7:0] reg_A; //A값 저장
	reg [7:0] reg_S; //sum값 저장
	wire cout;
	wire ov;
	
	
	assign {cout,sum} = reg_A + reg_S; // adder 동작 선언
	
	assign ov = ( reg_A[7] & reg_S[7] & (~sum[7]))|((~reg_A[7]) & (~reg_S[7]) & sum[7]);
	//각각의MSB의 곱의합 형태로 overflow 검출
	always @ (posedge out, negedge rst)
	if(~rst) {reg_A, reg_S, carry, overflow} <= {18'b0};//rst0일때 초기화
	else if(add_sub) {reg_A, reg_S, carry, overflow} <= {~A+1'b1, sum, cout, ov}; //add_sub값이 1일때subtracter역할
	else {reg_A, reg_S, carry, overflow} <= {A, sum, cout, ov}; //add_sub값이 0일때 adder역할
	
	segdec dec0(.i(reg_A[7:4]), .o(hex3[6:0])); //입력과 출력을 각각 4비트씩 나누어 4개의 hex[3:0]에 할당
	segdec dec1(.i(reg_A[3:0]), .o(hex2[6:0]));
	segdec dec2(.i(reg_S[7:4]), .o(hex1[6:0]));
	segdec dec3(.i(reg_S[3:0]), .o(hex0[6:0]));
	
endmodule

module segdec //lab4part2에 연결할 7segdisplay 1일때 꺼지고 0일때 켜짐
( input wire [3:0] i,
output reg [6:0] o);
	
	always @ *
	case(i) //case문으로 각 상황에 맞춰 구현
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
