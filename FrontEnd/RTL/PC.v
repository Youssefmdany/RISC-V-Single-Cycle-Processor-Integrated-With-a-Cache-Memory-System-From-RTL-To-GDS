module PC (input clk,reset,input[31:0] PC,output reg[31:0] PC_Out);
 
 
 
  
always@(posedge clk ,posedge reset) begin
    
  if(reset)
           PC_Out <= 0;
  else
           PC_Out <= PC;
    
end
  
endmodule
