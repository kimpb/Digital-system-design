module mux4(
	input wire s1,
	input wire s0,
	input wire u,
	input wire v,
	input wire w,
	input wire x,
	output reg m // procedural block 을 사용해서 combinational logic을 기술하는 형태로 하기 때문에
);                    // left handed side output을 reg type으로 선언함

always @ *
	case({s1, s0}) 
	2'b00 : m = u ; // s1s0 = 00 이면 m = u
	2'b01 : m = v ; // s1s0 = 01 이면 m = v
	2'b10 : m = w ; // s1s0 = 10 이면 m = w
	2'b11 : m = x ; // s1s0 = 11 이면 m = v
//part1에서 만들었던 2-to-1 mux를 사용해도 되지만 case문을 사용
	endcase

endmodule


module part2(
	input wire s0,
	input wire s1,
	input wire [1:0] U,
	input wire [1:0] V,
	input wire [1:0] W,
	input wire [1:0] X,
	output wire [1:0] M
);

mux4 u0(.u(U[0]), .v(V[0]), .w(W[0]), .x(X[0]), .s0(s0), .s1(s1), .m(M[0]));
mux4 u1(.u(U[1]), .v(V[1]), .w(W[1]), .x(X[1]), .s0(s0), .s1(s1), .m(M[1])); 

endmodule

module tbpart2();  // testbench module
reg [1:0] U;
reg [1:0] V;
reg [1:0] W;
reg [1:0] X;
reg s0;
reg s1;
wire [1:0] M;

part2 u(.U(U), .V(V), .W(W), .X(X), .s0(s0), .s1(s1), .M(M));

initial begin

U = 2'b00;
V = 2'b01;
W = 2'b10;
X = 2'b11;  // U = 00, V = 01, W = 10, X = 11 으로 초기값 설정

s0 = 2'b0;
s1 = 2'b0;

#200 s0 = 2'b1;

#200 s1 = 2'b1; s0 = 2'b0;

#200 s0 = 2'b1; // 200 timeunit마다 s0와 s1에 변화를 줘서 output 변화 

end

endmodule
