module lab2part3(
	input wire w,
	input wire rst,
	input wire clk,
	output wire z
	);
	reg [3:0] shift_reg;
	always @(posedge clk)
	if (~rst) shift_reg <= 4'b0000; // rst 0 일때 초기화.
	else shift_reg <= {w,shift_reg[3:1]}; 
// w신호와 shift_reg[3:0]의 왼쪽 3비트가 합쳐져 shift register가 됨.
	assign z = (&shift_reg) | (&(~shift_reg));
 //shift_reg[3:0]의 각 비트를 and, inv and 를 해준후  or하여 0000,1111검출.
	endmodule
	
