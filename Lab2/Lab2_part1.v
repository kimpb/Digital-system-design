
module lab2part1dlatch(
	input wire D,
	input wire Gate,
	output reg Qa,
	output wire Qabar // Dlatch의 포트 선언
);

always @ *
if(Gate) Qa <= D;

assign Qabar = ~Qa; //gate와 D값에 모두 영향을 받음

endmodule 


module lab2part1posedge(
	input wire D,
	input wire clk,
	output reg Qb,
	output wire Qbbar //posedge D F/F 의 포트 선언
);

always @(posedge clk)
	Qb <= D;
	assign Qbbar = Qb; //오직 posedge 일 때만 작동

endmodule


module lab2part1negedge(
	input wire D,
	input wire clk,
	output reg Qc,
	output wire Qcbar //negedge D F/F의 포트 선언
);

always @(negedge clk)
	Qc <= D;
	assign Qcbar = Qc; //오직 negedge 일 때만 작동

endmodule

`timescale 10ns/1ns
module lab2part1tb();
reg D;
reg clk;
wire Qa;
wire Qb;
wire Qc;
wire Qabar;
wire Qbbar;
wire Qcbar;  // testbench에 사용할 데이터 선언

lab2part1dlatch u1(D, clk, Qa, Qabar);  // D latch module
lab2part1posedge u2(D, clk, Qb, Qbbar);  // posedge D F/F module
lab2part1negedge u3(D, clk, Qc, Qcbar); // negedge D F/F module

initial begin
clk = 0;
D = 0;

#3 D = 1;

#4 D = 0;

#1 D = 1;

#3 D = 0;

#1 D = 1;

#1 D = 0;

#1 D = 1;

#1 D = 0;

#3 D = 1;

#1 D = 0;

#1 D = 1;

#3 D = 0; // 시간에 따라 변하는 D값을 줘서 Qa, Qb, Qc 값을 각각 확인

end


always begin
#5 clk = ~clk;
end

endmodule
