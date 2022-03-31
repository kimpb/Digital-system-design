
module lab4_part3(
	input wire [7:0] i, // SW0~SW7 할당
	input wire EA, //SW8
	input wire EB, //SW9
	input wire clk, //key[1]
	input wire rst, //key[0], synchronous reset
	output wire [7:0] LED, //A와 B값 출력
	output wire [6:0] hex3,
	output wire [6:0] hex2,
	output wire [6:0] hex1,
	output wire [6:0] hex0 //연산 결과 출력
	); 
	
	reg [7:0] reg_A;
	reg [7:0] reg_B;
	reg [15:0] reg_P; //연산결과 P를 저장하는 reg 선언
	wire [15:0] product; // A와 B의 곱을 저장하는 wire 선언
	assign product = reg_A * reg_B;
	
	segdec u0(.i(reg_P[3:0]), .o(hex0));
	segdec u1(.i(reg_P[7:4]), .o(hex1));
	segdec u2(.i(reg_P[11:8]), .o(hex2));
	segdec u3(.i(reg_P[15:12]), .o(hex3));
	
	always @ (posedge clk)
	if(~rst) reg_A <= 8'd0; // synchronous reset
	else if(EA) reg_A <= i; // EA =1 일 경우 A에 input i를 저장
	
	always @ (posedge clk)
	if(~rst) reg_B <= 8'd0;
	else if (EB) reg_B <= i; // EB = 1 일 경우 B에 input i를 저장
	
	always @ (posedge clk)
	if(rst) reg_P <= product; // 클락이 들어왔을 때 rst = 1이면 P에 A와 B의 곱을 넣어줌
	
	assign LED = (EA&(~EB))? reg_A : reg_B; // A와 B의 값을 나타내는 LED
	
endmodule


module segdec //lab4part2에서 사용한 7segment decoder와 동일
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


module lab4_part3tb();
	reg [7:0] i;
	reg EA;
	reg EB;
	reg clk;
	reg rst;
	wire [7:0] LED;
	wire [6:0] hex3;
	wire [6:0] hex2;
	wire [6:0] hex1;
	wire [6:0] hex0;

lab4_part3 u0(i, EA, EB, clk, rst, LED, hex3, hex2, hex1, hex0);

initial begin
#(0) rst=1; clk=1; i=8'b0;///초기값 설정
#(15) EA=1; i=8'b00011110;
#(5) clk=~clk;  #(5) clk=~clk;  //// A에 8'b00011110 저장
#(15) EA=0; EB=1; i=8'b00000101; 
#(5) clk=~clk;  #(5) clk=~clk; //// B에 8'b00000101 저장
#(15) EA=0; EB=0;
#(5) clk=~clk;  #(5) clk=~clk;  ///연산 결과값 확인
#(20) i=0; EA=1;      ////저장된 A값 확인
#(20) i=0; EA=0; EB=1; ////저장된 B값 확인
#(20) rst=~rst; clk=~clk;  #(5) rst=~rst; clk=~clk; ////리셋
#(10) EA=1; EB=1; i=8'b00000110;  
#(5) clk=~clk;  #(5) clk=~clk;    ////A와B에 동시에 8'b00000110 저장
#(15) EA=0; EB=0;
#(20) clk=~clk;  #(5) clk=~clk;  ////연산 결과값 확인
#(20) i=0; EA=1; EB=0;  ////저장된 A값 확인
#(20) i=0; EA=0; EB=1;  ////저장된 B값 확인"
end 
endmodule
