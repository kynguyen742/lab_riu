module cpu (input reg clck, input reg rst_n, input reg [31:0] in, output reg [31:0] out);
	logic [31:0] inst_ram [4095:0];
	initial begin 
	$readmemh("hexcode.txt",inst_ram);
	end
		logic [11:0] PC_FETCH; 
		logic [11:0] PC_EX;
		logic [11:0] R;
		logic [12:0] branch_offset_EX; 
		logic [12:0] branch_addr_EX;
		logic [11:0] jalr_addr_EX; 
		logic [11:0] jalr_offset_EX;
		logic [11:0] jal_addr_EX;
		logic [20:0] jal_offset_EX;
		logic [31:0] instruction_EX;
		logic [4:0] regdest_WB;
		logic [31:0] A;
		logic [31:0] B;
		logic alusrc_EX;
		logic [31:0] regdata2_EX;
		logic hex_WE;
		logic regwrite_WB,regwrite_EX;
		logic [1:0] regsel_WB,regsel_EX;
		logic [31:0] lui_val_WB;
		logic [31:0] R_WB, R_EX;
		logic [31:0] writedata_WB;
		logic [3:0] aluop_EX, psrc_EX;
		logic [6:0] funct_7;
		logic [6:0] aluop_WB;
		logic [2:0] funct_3;
		logic [4:0] r1, r2, r_d;
		logic [11:0] imm12;
		logic [19:0] imm20;
		logic [31:0] in_WB;
		logic zero_cpu;
		logic x_cpu;
		logic STALL_EX, STALL_FETCH;
		logic [2:0] branch_id;
		logic [1:0] pcsrc_EX;
		 
	
	assign branch_offset_EX = {instruction_EX[31], instruction_EX[7], instruction_EX[30:25], instruction_EX[11:8], 1'b0};
	assign branch_addr_EX = PC_EX + {branch_offset_EX[12],branch_offset_EX[12:2]};
	
	assign jal_offset_EX = {instruction_EX[31], instruction_EX[19:12], instruction_EX[20], instruction_EX[30:21], 1'b0};
	assign jal_addr_EX = PC_EX + jal_offset_EX[13:2];
	
	assign jalr_offset_EX =  instruction_EX[31:20];
	assign jalr_addr_EX = A[13:2] + {{2{jalr_offset_EX[11]}},jalr_offset_EX[11:2]};

	always_ff @(posedge clck) begin
	  if (PC_FETCH > 12'd30)
	  
	  begin
	  	
	  	$finish;
	  	
	  end
	  STALL_EX <= 1'b1;
	  $display("%h %h", PC_FETCH, instruction_EX); 
	  if (~rst_n) begin
	    PC_FETCH <= 12'b0;
	    instruction_EX <= 32'b0;
	  end else begin
	  	if(pcsrc_EX == 2'b01 && zero_cpu == x_cpu && STALL_EX == 1'b0) begin
	  		PC_FETCH <= branch_addr_EX[11:0];
	  	end
	  	else if( pcsrc_EX == 2'b10 && STALL_EX == 1'b0) begin
	 	 	PC_FETCH <= jal_addr_EX;
	  	end
	  	else if( pcsrc_EX == 2'b11 && STALL_EX == 1'b0) begin
	  		PC_FETCH <= jalr_addr_EX;
	  	end
	  	else begin
	  		PC_FETCH <= PC_FETCH + 12'd1;
	  		STALL_EX <= 1'b0;
	  	end
	  	instruction_EX <= inst_ram[PC_FETCH];
		end
	end
	always_ff @(posedge clck) begin
	  if (hex_WE) begin
	  	out <= A;
	  	$display("displaying %h from reg %h", A, r1);
	  end
	  PC_EX <= PC_FETCH;
	  regsel_WB <= regsel_EX;
	  regwrite_WB <= regwrite_EX;
	  in_WB <= in;
	  regdest_WB <= instruction_EX[11:7];
	  R_WB <= R_EX;
	  lui_val_WB <= {instruction_EX[31:12], 12'b0};
	end
	


decoder myDecoder (.instructionaddr(instruction_EX), .funct7(funct_7), .rs2(r2), .rs1(r1), .funct3(funct_3), .rd(r_d), .opcode(aluop_WB), .imm20(imm20), .imm12(imm12));

regfile myReg (.clk(clck), .we(regwrite_WB), .readaddr1(instruction_EX[19:15]), .readaddr2(instruction_EX[24:20]),.writeaddr(regdest_WB), .writedata(writedata_WB), .readdata1(A), .readdata2(regdata2_EX));
 
ControlUnit myCU (.funct7(funct_7), .rs2(r2), .rs1(r1), .funct3(funct_3), .rd(r_d), .opcode(aluop_WB), .imm20(imm20), .imm12(imm12), 
						.stall_EX(STALL_EX), .alusrc(alusrc_EX), .regwrite(regwrite_EX), .regsel(regsel_EX), .op(aluop_EX), .gpio_we(hex_WE), 
						.stall_FETCH(STALL_FETCH), .pcsrc(pcsrc_EX), .branch(branch_id), .x_EX(x_cpu));


alu myAlu (.A(A), .B(B), .op(aluop_EX), .R(R_EX), .zero(zero_cpu));

// make all the mux's
assign B = alusrc_EX == 1'b0 ? regdata2_EX : {{20{instruction_EX[31]}}, instruction_EX[31:20]};

assign writedata_WB = regsel_WB == 2'b00 ? in_WB : regsel_WB == 2'b01 ? lui_val_WB : regsel_WB == 2'b10 ? R_WB : {18'b0,PC_EX, 2'b0};


endmodule



