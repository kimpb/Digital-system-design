
module termproject(
	input wire [8:0] SW,
	input wire key0,
	input wire key1,
	output wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	output wire LEDR0
	);
	
	reg [17:0] operand1;
	reg [17:0] operand2;
	reg [19:0] result;
	reg [2:0] present;
	reg [17:0] presentvalue;
	reg [2:0] operator;
	wire [17:0] wire_presentvalue;
	wire [3:0] BCD0, BCD1, BCD2, BCD3, BCD4, BCD5;
	wire [8:0] quotient;
	wire [8:0] remainder;
	
	assign wire_presentvalue = presentvalue;
	assign LEDR0 = (result > 19'd262143)? 1'b1 : ((operator == 3'b011) || (operator == 3'b100)) && (operand2>18'd511)? 1'b1 : 1'b0; 

	always @(posedge key0, negedge key1)
	if(~key1) {presentvalue,present} <= 21'b0;
	else if(present == 3'b000) {presentvalue[17:0],operand1[17:9],present[2:0]} <= {SW[8:0],9'b0,SW[8:0],present[2:0] + 1'b1};
	else if(present == 3'b001) {presentvalue[8:0],operand1[8:0],present[2:0]} <= {SW[8:0],SW[8:0],present[2:0] + 1'b1};
	else if(present == 3'b010) {presentvalue[17:0],operator[2:0],present[2:0]} <= {15'b0,SW[2:0],SW[2:0],present[2:0] + 1'b1};
	else if(present == 3'b011) {presentvalue[17:0],operand2[17:9],present[2:0]} <= {SW[8:0],9'b0,SW[8:0],present[2:0] + 1'b1};
	else if(present == 3'b100) {presentvalue[8:0],operand2[8:0],present[2:0]} <= {SW[8:0],SW[8:0],present[2:0] + 1'b1};
	else if(present == 3'b101) {presentvalue[17:0],present[2:0]} <= {result[17:0],present[2:0] + 1'b1};
	else {presentvalue,present} <= 21'b0;

		
	

	always @ (present == 3'b101)
	if(operator == 3'b000)
	result <= operand1 + operand2;
	else if(operator == 3'b001)
	result <= operand1 - operand2;
	else if(operator == 3'b010)
	result <= operand1 * operand2;
	else if(operator == 3'b011)
	result <= quotient;
	else if(operator == 3'b100)
	result <= remainder;
	else 
	result <= 19'd524287;
	
	BCD b0(wire_presentvalue, BCD0, BCD1, BCD2, BCD3, BCD4, BCD5);
	
	divider2 d2(operand1,operand2,quotient,remainder);
	
	
	
	segdec u0(.i(BCD0), .o(HEX0));
	segdec u1(.i(BCD1), .o(HEX1));
	segdec u2(.i(BCD2), .o(HEX2));
	segdec u3(.i(BCD3), .o(HEX3));
	segdec u4(.i(BCD4), .o(HEX4));
	segdec u5(.i(BCD5), .o(HEX5));
	
	
	
	
endmodule
