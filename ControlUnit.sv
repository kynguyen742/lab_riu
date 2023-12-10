module ControlUnit (input logic [6:0] funct7, 
	input logic [4:0] rs2, 
	input logic [4:0] rs1, 
	input logic [2:0] funct3,
	input logic [4:0] rd, 
	input logic [6:0] opcode, 
	input logic [19:0] imm20, 
	input logic [11:0] imm12, 
	input logic stall_EX, 
 
	output logic alusrc, 
	output logic regwrite, 
	output logic [1:0] regsel, 
	output logic [3:0] op, 
	output logic gpio_we, 
	output logic stall_FETCH, 
	output logic [1:0] pcsrc, 
	output logic [2:0] branch, 
	output logic x_EX
	);
	
always@(funct3 or funct7 or opcode) begin
//R-type
	pcsrc = 2'b00;
	stall_FETCH = 1'b0;
	if(opcode == 7'b0110011) begin
		if (funct3 == 3'b000 && funct7 == 7'b0000000) begin // add
			alusrc = 1'b0;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b0011;
			gpio_we = 1'b0;
			
		end 
		else if (funct3 == 3'b000 && funct7 == 7'b0100000) begin // sub
			alusrc = 1'b0;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b0100;
			gpio_we = 1'b0;	
		end 
		else if (funct3 == 3'b111 && funct7 == 7'b0000000) begin // and
			alusrc = 1'b0;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b0000;
			gpio_we = 1'b0;
		end 
		else if (funct3 == 3'b110 && funct7 == 7'b0000000) begin // or
			alusrc = 1'b0;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b0001;
			gpio_we = 1'b0;
		end 
		else if (funct3 == 3'b100 && funct7 == 7'b0000000) begin // xor
			alusrc = 1'b0;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b0010;
			gpio_we = 1'b0;
		end 
		else if (funct3 == 3'b101 && funct7 == 7'b0000000) begin // srl
			alusrc = 1'b0;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b1001;
			gpio_we = 1'b0;
		end 
		else if (funct3 == 3'b010 && funct7 == 7'b0000000) begin // slt
			alusrc = 1'b0;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b1100;
			gpio_we = 1'b0;
		end 
		else if (funct3 == 3'b011 && funct7 == 7'b0000000) begin // sltu
			alusrc = 1'b0;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b1101;
			gpio_we = 1'b0;
		end 
		else if (funct3 == 3'b000 && funct7 == 7'b0000001) begin // mul
			alusrc = 1'b0;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b0101;
			gpio_we = 1'b0;
		end 
		else if (funct3 == 3'b001 && funct7 == 7'b0000001) begin // mulh
			alusrc = 1'b0;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b0110;
			gpio_we = 1'b0;
		end 
		else if (funct3 == 3'b011 && funct7 == 7'b0000001) begin // mulhu
			alusrc = 1'b0;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b0111;
			gpio_we = 1'b0;
		end 
		else if (funct3 == 3'b001 && funct7 == 7'b0000000) begin // sll
			alusrc = 1'b0;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b1000;
			gpio_we = 1'b0;
		end 
		else if (funct3 == 3'b101 && funct7 == 7'b0100000) begin // sra
			alusrc = 1'b0;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b1011;
			gpio_we = 1'b0;
		end 
	
	end
//I-type
	else if(opcode == 7'b0010011) begin
		if (funct3 == 3'b000) begin // addi
			alusrc = 1'b1;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b0011;
			gpio_we = 1'b0;
			end
		else if (funct3 == 3'b111) begin // andi
			alusrc = 1'b1;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b0000;
			gpio_we = 1'b0;
		end else if (funct3 == 3'b110) begin // ori
			alusrc = 1'b1;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b0001;
			gpio_we = 1'b0;
		end else if (funct3 == 3'b100) begin // xori
			alusrc = 1'b1;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b0010;
			gpio_we = 1'b0;
		end else if (funct3 == 3'b001 && imm12[11:5] == 7'b0) begin // slli
			alusrc = 1'b1;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b1000;
			gpio_we = 1'b0;
		end else if (funct3 == 3'b101 && imm12[11:5] == 7'b0100000) begin // srai
			alusrc = 1'b1;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b1011;
			gpio_we = 1'b0;
		end else if (funct3 == 3'b101 && imm12[11:5] == 7'b0) begin // srli
			alusrc = 1'b1;
			regwrite = 1'b1;
			regsel = 2'b10;
			op = 4'b1001;
			gpio_we = 1'b0;
		end
	end
//U-type
	else if (opcode == 7'b1110011) begin
		if (funct3 == 3'b001 && imm12 == 12'h0) begin // sw
			op = 4'bX;
			alusrc = 1'bX;
			regwrite = 1'b1;
			regsel = 2'b00;
			gpio_we = 1'b0;
		end  
		else if (funct3 == 3'b001 && imm12 == 12'h2) begin // hex out
			op = 4'bX;
			alusrc = 1'bX;
			regsel = 2'bX;
			regwrite = 1'b0;
			gpio_we = 1'b1;
		end 
	end
		else if (opcode == 7'b0110111) begin // lui
			alusrc = 1'bX;
			regwrite = 1'b1;
			regsel = 2'b01;
			op = 4'bX;
			gpio_we = 1'b0;
		end





//B-type
	else if(opcode == 7'b1100011) begin
		stall_FETCH = 1'b1;
		alusrc = 1'b0;
		regwrite = 1'b0;
		if (funct3 == 3'b000) begin // beq
			pcsrc = 2'b01;
			x_EX = 1'b1;
			branch = 3'b000;
			op = 4'b0100;
		end
		if (funct3 == 3'b101) begin // bge
			pcsrc = 2'b01;
			x_EX = 1'b1;
			branch = 3'b001;
			op = 4'b1100;
			
		end
		if (funct3 == 3'b111) begin // bgeu
			pcsrc = 2'b01;
			x_EX = 1'b1;
			branch = 3'b010;
			op = 4'b1101;
		end
		if (funct3 == 3'b100) begin // blt
			pcsrc = 2'b01;
			x_EX = 1'b0;
			branch = 3'b011;
			op = 4'b1100;
			
		end
		if (funct3 == 3'b110) begin // bltu
			pcsrc = 2'b01;
			x_EX = 1'b0;
			branch = 3'b100;
			op = 4'b1101;
		end
		
	end
//J-type
	else if (opcode == 7'b1101111) begin // jal
		pcsrc = 2'b10;
		stall_FETCH = 1'b1;
		regsel = 2'b11;
		regwrite = 1'b1;
	end
	
	else if (opcode == 7'b1100111 && funct3 == 3'b000) begin // jalr
		pcsrc = 2'b11;
		stall_FETCH = 1'b1;
		regsel = 2'b11;
		regwrite = 1'b1;
	end
	if(stall_EX == 1'b1) begin
		regwrite = 1'b0;
	end
	
end


endmodule



 

