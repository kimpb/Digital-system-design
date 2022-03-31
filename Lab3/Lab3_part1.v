module lab3part1(
	input wire c0,
	input wire c1,
	output reg [6:0] hex0
	);
	
	always @ *
	case ( {c1,c0} ) // case문을 통해 디코더 만듬
	2'b00: hex0 = 7'b0100001; //d 형태의 7seg
	2'b01: hex0 = 7'b0000110; //E 형태의 7seg
	2'b10: hex0 = 7'b1111001; //1 형태의 7seg
	2'b11: hex0 = 7'b1000000; //0 형태의 7seg
	endcase
	
	endmodule 
	
