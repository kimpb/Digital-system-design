
module lab3part2(
	input wire w, // SW[1]으로 받음
	input wire slowclk, // KEY[0]로 clock input 받음
	input wire fastclk, // PIN_P11으로 50Mhz clock 받음
	input wire rst, // SW[0]으로 active low synchronous reset
	output reg z, // LED[9]로 출력
	output reg [8:0] state); // 현재의 상태를 LED[8:0]로 출력
	
	
	wire clkout; // bouncing을 막기 위한 내부 clock
	
	
	debounce_better_version u0(.pb_1(slowclk),.clk(fastclk),.pb_out(clkout)); 
//debouncing을 막기 위한 module으로 구글에서 찾아서 적용했습니다.
	
	reg [8:0] next_state; 
	
	always @ (posedge clkout)
		if(~rst)                    //active low synchronous reset
			state <= 9'b000000001;
		else state <= next_state; 
	always @ *
		case({state,w})
			{9'b000000001, 1'b0} : next_state = 9'b000000010;
			{9'b000000010, 1'b0} : next_state = 9'b000000100;
			{9'b000000100, 1'b0} : next_state = 9'b000001000;
			{9'b000001000, 1'b0} : next_state = 9'b000010000;
			{9'b000010000, 1'b0} : next_state = 9'b000010000;
			{9'b000100000, 1'b0} : next_state = 9'b000000010;
			{9'b001000000, 1'b0} : next_state = 9'b000000010;
			{9'b010000000, 1'b0} : next_state = 9'b000000010;
			{9'b100000000, 1'b0} : next_state = 9'b000000010;
			{9'b000000001, 1'b1} : next_state = 9'b000100000;
			{9'b000000010, 1'b1} : next_state = 9'b000100000;
			{9'b000000100, 1'b1} : next_state = 9'b000100000;
			{9'b000001000, 1'b1} : next_state = 9'b000100000;
			{9'b000010000, 1'b1} : next_state = 9'b000100000;
			{9'b000100000, 1'b1} : next_state = 9'b001000000;
			{9'b001000000, 1'b1} : next_state = 9'b010000000;
			{9'b010000000, 1'b1} : next_state = 9'b100000000;
			{9'b100000000, 1'b1} : next_state = 9'b100000000;
			// 현재 상태와 input에 따라 next_state 지정
			endcase
	
	always @ *
		case(state)
		9'b000000001 : z = 0;
		9'b000000010 : z = 0;
		9'b000000100 : z = 0;
		9'b000001000 : z = 0;
		9'b000010000 : z = 1;
		9'b000100000 : z = 0;
		9'b001000000 : z = 0;
		9'b010000000 : z = 0;
		9'b100000000 : z = 1;
		// 현재의 상태를 판별하여 z 출력
		endcase
			
endmodule


// bouncing을 막기 위한 module의 내용입니다.
module debounce_better_version(input pb_1,clk,output pb_out);
wire slow_clk_en;
wire Q1,Q2,Q2_bar,Q0;
clock_enable u1(clk,slow_clk_en);
my_dff_en d0(clk,slow_clk_en,pb_1,Q0);

my_dff_en d1(clk,slow_clk_en,Q0,Q1);
my_dff_en d2(clk,slow_clk_en,Q1,Q2);
assign Q2_bar = ~Q2;
assign pb_out = Q1 & Q2_bar;
endmodule
// Slow clock enable for debouncing button 
module clock_enable(input Clk_100M,output slow_clk_en);
    reg [26:0]counter=0;
    always @(posedge Clk_100M)
    begin
       counter <= (counter>=249999)?0:counter+1;
    end
    assign slow_clk_en = (counter == 249999)?1'b1:1'b0;
endmodule
// D-flip-flop with clock enable signal for debouncing module 
module my_dff_en(input DFF_CLOCK, clock_enable,D, output reg Q=0);
    always @ (posedge DFF_CLOCK) begin
  if(clock_enable==1) 
           Q <= D;
    end
endmodule

// 위와 동일하며 state code만 변경
module lab3part2(
	input wire w,
	input wire slowclk,
	input wire fastclk,
	input wire rst,
	output reg z,
	output reg [8:0] state);
	
	
	wire clkout;
	
	
	debounce_better_version u0(.pb_1(slowclk),.clk(fastclk),.pb_out(clkout));
	
	reg [8:0] next_state;
	
	always @ (posedge clkout)
		if(~rst)
			state <= 9'b000000000;
		else state <= next_state;
	always @ *
		case({state,w})
			{9'b000000000, 1'b0} : next_state = 9'b000000011;
			{9'b000000011, 1'b0} : next_state = 9'b000000101;
			{9'b000000101, 1'b0} : next_state = 9'b000001001;
			{9'b000001001, 1'b0} : next_state = 9'b000010001;
			{9'b000010001, 1'b0} : next_state = 9'b000010001;
			{9'b000100001, 1'b0} : next_state = 9'b000000011;
			{9'b001000001, 1'b0} : next_state = 9'b000000011;
			{9'b010000001, 1'b0} : next_state = 9'b000000011;
			{9'b100000000, 1'b0} : next_state = 9'b000000011;
			{9'b000000000, 1'b1} : next_state = 9'b000100001;
			{9'b000000011, 1'b1} : next_state = 9'b000100001;
			{9'b000000101, 1'b1} : next_state = 9'b000100001;
			{9'b000001001, 1'b1} : next_state = 9'b000100001;
			{9'b000010001, 1'b1} : next_state = 9'b000100001;
			{9'b000100001, 1'b1} : next_state = 9'b001000001;
			{9'b001000001, 1'b1} : next_state = 9'b010000001;
			{9'b010000001, 1'b1} : next_state = 9'b100000001;
			{9'b100000001, 1'b1} : next_state = 9'b100000001;
			// Modified one-hot codes
			endcase
	
	always @ *
		case(state)
		9'b000000000 : z = 0;
		9'b000000011 : z = 0;
		9'b000000101 : z = 0;
		9'b000001001 : z = 0;
		9'b000010001 : z = 1;
		9'b000100001 : z = 0;
		9'b001000001 : z = 0;
		9'b010000001 : z = 0;
		9'b100000001 : z = 1;
		
		endcase
			
endmodule
//debouncing을 위한 module은 생략했습니다.

RTL Simulation 결과 분석
//debouncing을 위한 module은 test bench에서는 필요 없으므로 빼고 simulation 했습니다.
module lab3part2tb();
reg w,rst,clk;  wire [8:0] state;  wire z;
lab3part2_2 u(.w(w),.rst(rst),.clk(clk),.state(state),.z(z)); 
initial begin
#(0) rst=0; clk=1; w=0;
#(1) clk=~clk; #(1) clk=~clk;
#(2) rst=1; clk=~clk; 
#(2) clk=~clk;
#(2) clk=~clk; 
#(2) clk=~clk;
#(2) clk=~clk; 
#(2) clk=~clk;
#(2) clk=~clk; 
#(2) clk=~clk;
#(2) clk=~clk; 
#(2) clk=~clk;   // w = 0일 때 clock을 5번 넣어줌
#(2) w=1; clk=~clk; // w = 1로 바꾸고 clock을 5번 넣어줌 
#(2) clk=~clk;
#(2) clk=~clk; 
#(2) clk=~clk;
#(2) clk=~clk; 
#(2) clk=~clk;
#(2) clk=~clk; 
#(2) clk=~clk;
#(2) clk=~clk; 
#(2) clk=~clk;

#(1) rst=~rst; clk=~clk; 
#(1) clk=~clk; // Reset
end  
endmodule
