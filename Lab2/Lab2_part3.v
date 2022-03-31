module lab2part3(
input wire clk,
input wire rst,
input wire en,
output reg [15:0] Q
); //16비트 카운터의 포트 선언

always @(posedge clk, posedge rst) // active high, asynchronous reset
if(rst) Q <= 16'b0;
else if(en) Q <= Q + 16'b1; // enable이 1일 때 카운터에 +1
endmodule


`timescale 10ps/10ps // timescale 선언
module lab2part3test();
reg clk;
reg rst;
reg en; 
wire [15:0] Q; // test bench에서 사용할 데이터 할당

initial begin
clk = 0;
rst = 0;
en = 1;
#5 rst = 1;
#5 rst = 0; // 초기값 저장
end


lab2part3 u(.clk(clk), .rst(rst), .en(en), .Q(Q)); // counter module instantiation

always #5 clk = ~clk;

endmodule
