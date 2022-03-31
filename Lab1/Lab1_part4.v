module part4(
	input wire [3:0] X, 
	input wire [3:0] Y, // 4bit BCD input X 와 Y
	input wire cin, // 1bit input carry in
	output wire [3:0] d0, // 4bit 1의 자리 output
	output wire [3:0] d1 // 4bit 10의 자리 output
);

wire [4:0] tmp = X + Y + cin ; // tmp는 임시의 값으로 X와 Y, cin의 합을 가짐
wire gteq = ( tmp >= 5'd10 ); // gteq는 tmp가 10보다 크면 1이 되고 작으면 0이 됨
wire [3:0] minus10 = ( tmp - 5'd10 ); // X+Y+cin 이 10보다 클 경우 합에서 10을 빼 줌

assign d0 = gteq ? minus10 : tmp[3:0]; // gteq가 1이면 10보다 뺀 값을 output으로 내주고 아니면 합이 그대로 나옴

assign d1 = {3'b000,gteq}; // 10의 자리 output은 합이 10보다 크면 0001, 작으면 0000으로 나오게 됨
endmodule

module tbpart4(); // testbench module 
reg [3:0] X;
reg [3:0] Y;
reg cin;
wire [3:0] d0;
wire [3:0] d1;

part4 u(X, Y, cin, d0, d1);

initial begin

X = 4'b1011;

Y = 4'b0110;

cin = 1'b1; // 초기값 X = 1011, Y = 0110, cin = 1 으로 설정

#200

X = 4'b0111;

Y = 4'b0011;

cin = 1'b0;

#200

X = 4'b0100;

Y = 4'b0010;

cin = 1'b0; // 200 timeunit 마다 X, Y, cin에 변화를 줘서 output의 변화 확인

end

endmodule
