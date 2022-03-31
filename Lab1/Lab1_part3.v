module part3(
	input wire [3:0] v, // 4bit binary input
	output reg [3:0] d0, // 1의 자리 BCD output
	output reg [3:0] d1 // 10의 자리 BCD output
);

always @ * // v가 변할 때 마다 작동
case(v)
4'd0 : {d1,d0} = {4'd0 , 4'd0}; // 입력 받은 v값이 0000 이면 d1 =0000, d0 = 0000
4'd1 : {d1,d0} = {4'd0 , 4'd1}; // 입력 받은 v값이 0001 이면 d1 =0000, d0 = 0001
4'd2 : {d1,d0} = {4'd0 , 4'd2};
4'd3 : {d1,d0} = {4'd0 , 4'd3};
4'd4 : {d1,d0} = {4'd0 , 4'd4};
4'd5 : {d1,d0} = {4'd0 , 4'd5};
4'd6 : {d1,d0} = {4'd0 , 4'd6};
4'd7 : {d1,d0} = {4'd0 , 4'd7};
4'd8 : {d1,d0} = {4'd0 , 4'd8};
4'd9 : {d1,d0} = {4'd0 , 4'd9};
4'd10 : {d1,d0} = {4'd1 , 4'd0};
4'd11 : {d1,d0} = {4'd1 , 4'd1};
4'd12 : {d1,d0} = {4'd1 , 4'd2};
4'd13 : {d1,d0} = {4'd1 , 4'd3};
4'd14 : {d1,d0} = {4'd1 , 4'd4};
4'd15 : {d1,d0} = {4'd1 , 4'd5}; // 입력 받은 v값이 1111 이면 d1 =0001, d0 = 0101

endcase

endmodule

module tbpart3();  // testbench module
reg [3:0] v;
wire [3:0] d0;
wire [3:0] d1;

part3 u(v, d0, d1);

initial begin

v = 4'b0110; //초기값 v = 0110으로 설정

#200 v = 4'b1101;

#200 v = 4'b1111; // 200 timeunit 마다 v값에 변화를 줘서 output 변화 확인

end

endmodule
