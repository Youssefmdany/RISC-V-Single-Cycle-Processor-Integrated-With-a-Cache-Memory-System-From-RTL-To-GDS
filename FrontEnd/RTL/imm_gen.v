

module ImmGen(

                input [2:0] imm,
                input [31:0] inst_data,
                output reg[31:0] immgen
                                        );
	
		 
						 

always@(*) begin 


  case(imm) 
  
    3'b000: immgen = {{20{inst_data[31]}},inst_data[31:20]};//LW JALR ALUI
    
    3'b001: immgen = {{20{inst_data[31]}},inst_data[31:25],inst_data[11:7]}; //SW
    
    3'b010: immgen = {inst_data[31:12],{12{1'b0}}}; //LUI AUIPC
    
    3'b011: immgen = {{12{inst_data[31]}}, inst_data[19:12], inst_data[20], inst_data[30:21], 1'b0}; //JAL
    
    3'b100: immgen = {{20{inst_data[31]}},inst_data[7],inst_data[30:25],inst_data[11:8],1'b0}; //BEQ
    
    3'b101: immgen = {{20{1'b0}},inst_data[31:20]}; //LU
    
	 default: immgen ={{20{inst_data[31]}},inst_data[31:20]};
	 
  endcase



end	






endmodule
