 module RISCV (
                    input clk,
                    input reset,Stall,
                    input[31:0] Rdata,
                    input[31:0] inst_data,
                    output[11:0] Data_addr,
                    output[1:0] we,re,
                    output[31:0] Wdata,
                    output[31:0] PC,
                    output[31:0] reg_data
                                               );
                                 
                                 





 
wire[31:0] PC_NXT;
wire[31:0] data_to_reg; 
wire[31:0] reg1,reg2;
wire zero;
wire[3:0] ALUControl;
wire[2:0] immsrc;
wire[1:0] MemtoReg,MemWrite;
wire ALUSrc,RegWrite,PCsrc;
wire[31:0] ALUResult;
wire[31:0] immgen;
wire PC_sel;               
wire[1:0] branch;
wire compare;






//assign imm_sel = (inst_data[6:0]==7'b0000011 || inst_data[6:0]==7'b0010011 || inst_data[6:0]==7'b0100011 || inst_data[6:0]==7'b0010111 || inst_data[6:0]==7'b0110111 );

assign PC_sel = ( inst_data[6:0]==7'b0010111 );

assign Wdata = (inst_data[14:12]==3'b000) ? reg2 & 32'h0000_00ff :(inst_data[14:12]==3'b001) ? reg2 & 32'h0000_ffff : reg2;

assign branch = ( inst_data[6:0]==7'b1100011) ? 2'b00 : ( inst_data[6:0]==7'b1100111) ? 2'b01 : ( inst_data[6:0]==7'b1101111) ? 2'b10 : 2'b11;

assign Data_addr = (re || we) ? ALUResult : 0;

assign we = ( MemWrite && inst_data[14:12]==3'b000) ? 1 : ( MemWrite && inst_data[14:12]==3'b001) ? 2 :( MemWrite && inst_data[14:12]==3'b010) ? 3 : 0;

assign re = ( inst_data[6:0]==7'b0000011 && (inst_data[14:12]==3'b000 || inst_data[14:12]==3'b100)) ? 1 : ( inst_data[6:0]==7'b0000011 && (inst_data[14:12]==3'b001 || inst_data[14:12]==3'b101)) ? 2 :( inst_data[6:0]==7'b0000011 && inst_data[14:12]==3'b010) ? 3 : 0;

assign PC_NXT = (branch==2'b00 && PCsrc) ? PC+immgen : (branch==2'b01  && PCsrc ) ? reg1+immgen : (branch==2'b10 && PCsrc) ? PC+immgen : PC+4 ;

assign compare = (reg1 > reg2);

assign data_to_reg = MemtoReg ? Rdata : (((branch==2'b10 || branch==2'b01) && PCsrc) ? PC+4:(inst_data[6:0]==7'b0110111) ? immgen : ALUResult);



PC Program_counter (.clk(clk),.reset(reset),.PC( Stall ? PC : PC_NXT ),.PC_Out(PC));

 
 
//instr_mem Instr_mem (.addr(PC_Out),.inst(inst_data));



Control_Unit Contrl_Unit (.op_code(inst_data[6:0]),.funct3(inst_data[14:12]),.funct7(inst_data[31:25]),.zero(zero),.compare(compare),.ALUControl(ALUControl),.immsrc(immsrc),.MemtoReg(MemtoReg),.MemWrite(MemWrite),.ALUSrc(ALUSrc),.RegWrite(RegWrite),.PCsrc(PCsrc));                           



ImmGen Immdiate_gen (.imm(immsrc),.inst_data(inst_data),.immgen(immgen) );


                                 
reg_file Reg_File (.clk(clk),.reset(reset),.Stall(Stall),.read_register1(inst_data[19:15]),.read_register2(inst_data[24:20]),.write_register(inst_data[11:7]),.write_data(data_to_reg),.write_en(RegWrite),.read_data1(reg1),.read_data2(reg2),.reg_data(reg_data));



ALU alu (.A( (PC_sel)? PC : reg1),.B( ALUSrc ? immgen : ( ( branch==2'b01 || branch==2'b10 ) ? 4 : reg2) ),.ALUControl(ALUControl),.zero(zero),.ALUResult(ALUResult));
  
                                                               


                                 
                                 
endmodule 

