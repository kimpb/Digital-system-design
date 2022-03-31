module mux2 (
	input wire x,
	input wire y,
	input wire s,
	output wire m
);

assign m = ( s & y )|( (~s) & x ); // s가 0이면 m = x, s가 1이면 m = y
//m = s ? y : x; 로 써도 됨
endmodule

module part1(
	input wire [3:0] X, 
	input wire [3:0] Y, 
	input wire s, 
	output wire [3:0] M
);

mux2 u0(.x(X[3]), .y(Y[3]), .s(s), .m(M[3]));
mux2 u1(.x(X[2]), .y(Y[2]), .s(s), .m(M[2]));
mux2 u2(.x(X[1]), .y(Y[1]), .s(s), .m(M[1]));
mux2 u3(.x(X[0]), .y(Y[0]), .s(s), .m(M[0]));

endmodule

module tbpart1(); // testbench module
reg [3:0] X;
reg [3:0] Y;
reg s;
wire [3:0] M;

part1 u(.X(X), .Y(Y), .s(s), .M(M));

initial begin


X = 4'b0000;
Y = 4'b0000;
s = 1'b0; // 초기값 X = 0, Y = 0, s = 0 으로 설정

#100 X = 4'b0010; 

#100 Y = 4'b1011;

#100 s = 1'b1;

#100 X = 4'b0111;

#100 s = 1'b0; // 100time unit마다 값에 변화를 줘서 output 변화 확인

end

endmodule
