
module lab2tff(

input t,
input clk,
input clr,
output reg q // T F/F 의 포트 선언
);
wire D; // T F/F 에 필요한 임시 데이터 선언
initial
begin
 q <= 1'b0; // q 에 초기값 0 저장
end
assign D = t ^ q; // D 에 t와 q의 xor 값 저장

always@(posedge clk) // synchronous
begin
        if(~clr) // active low reset
            q <= 1'b0;
        else q <=  D; // clr가 1이면 q = 0을 넣고 그렇지 않으면 q = D
end

endmodule


module lab2counter(
input wire enable,
input wire clk,
input wire rst,
output wire q0,
output wire q1,
output wire q2,
output wire q3,
output wire q4,
output wire q5,
output wire q6,
output wire q7 // counter의 포트 선언
);


lab2tff t1(.t(enable), .clk(clk), .clr(rst), .q(q0)); // module instantiation 에서, 첫번째 T F/F에 인풋 enable을 넣음
lab2tff t2(.t(q0), .clk(clk), .clr(rst), .q(q1));  // 두번째 T F/F의 인풋에 첫번째 T F/F의 output을 넣음
lab2tff t3(.t(q1 && q0), .clk(clk), .clr(rst), .q(q2)); // 8비트 숫자에서 뒤의 두자리 비트가 모두 1일 때 세번째 비트가 1이 되므로…
lab2tff t4(.t(q2 && q1 && q0), .clk(clk), .clr(rst), .q(q3)); // 마찬가지로 1,2,3 비트 모두 1일 때 네번째 비트 1
lab2tff t5(.t(q3 && q2 && q1 && q0), .clk(clk), .clr(rst), .q(q4));
lab2tff t6(.t(q4 && q3 && q2 && q1 && q0), .clk(clk), .clr(rst), .q(q5));
lab2tff t7(.t(q5 && q4 && q3 && q2 && q1 && q0), .clk(clk), .clr(rst), .q(q6));
lab2tff t8(.t(q6 && q5 && q4 && q3 && q2 && q1 && q0), .clk(clk), .clr(rst), .q(q7)); // 8번째 비트까지 동일하게 작동



endmodule

module lab2test();
 reg clk;
 reg rst = 1;
 reg enable = 1; // test bench 에서의 input 값 설정

	wire q0;
	wire q1;
	wire q2;
	wire q3;
	wire q4;
	wire q5;
	wire q6;
	wire q7; // 각 자리의 비트 선언

lab2counter u(.clk(clk), 
.rst(rst), 
.enable(enable),
.q0(q0),
.q1(q1),
.q2(q2),
.q3(q3),
.q4(q4),
.q5(q5),
.q6(q6),
.q7(q7)
); // clk, rst, enable, 그리고 각 비트의 자릿수들을 counter module에 넣어줌

   initial begin
    #5 clk <= 1'b0;

   end

    always #5 clk=~clk;

endmodule
