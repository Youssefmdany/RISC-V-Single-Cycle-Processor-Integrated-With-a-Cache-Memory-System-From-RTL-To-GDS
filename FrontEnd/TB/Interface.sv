


interface Interface (input logic clk);


	         

  logic reset;
  logic[31:0] Rdata;
  logic[31:0] inst_data;
  logic[11:0] Data_addr;
  logic[31:0] Wdata;
  logic[1:0] we,re;    
  logic[31:0] reg_data;
  logic [31:0] PC;
  logic Stall;




endinterface 
