module Data_Memory_System (clk,reset,mem_read,mem_write,byte_address,DataIn,DataOut,Stall);
  
input clk,reset;
input[1:0]  mem_read,mem_write ;
input[11:0] byte_address ;
input[31:0] DataIn;
output[31:0] DataOut;
output Stall;

wire ready,fill,miss,hit;
wire[127:0] mem_block;




Cache_Contrl cache_contrl(.clk(clk),.reset(reset),.ready(ready),.mem_read(mem_read),.mem_write(mem_write),.addr(byte_address),.miss(miss),.hit(hit),.stall(Stall),.fill(fill));


Cache_Memory cache_mem(.clk(clk),.fill(fill),.miss(miss),.hit(hit),.ready(ready),.addr(byte_address[8:2]),.byte_sel(byte_address[1:0]),.mem_block(mem_block),.data_in(DataIn),.mem_read(mem_read),.mem_write(mem_write),.data_out(DataOut));


DataMem data_mem(.clk(clk),.reset(reset),.miss(miss),.hit(hit),.re(mem_read),.we(mem_write),.Data_addr(byte_address),.Wdata(DataIn),.Rdata(mem_block),.ready(ready));


  
  
  
endmodule 





/* module data_mem_sys_tb();
 
 
 
reg clk,reset;
reg  mem_read,mem_write ;
reg[9:0] byte_address ;
reg[31:0] DataIn;
wire[31:0] DataOut;
wire Stall;
  
  
Data_Memory_System dut (.clk(clk),.reset(reset),.mem_read(mem_read),.mem_write(mem_write),.byte_address(byte_address),.DataIn(DataIn),.DataOut(DataOut),.Stall(Stall));

initial begin
  
    clk=0;
    
   forever begin
     
      clk =#10 ~clk;
 
   end 
  
end
  
 

 
 initial begin
   reset = 1;
   #20
   reset = 0;

   mem_read = 0;  
   mem_write = 1; 
   byte_address = 10'b1110000000;
   DataIn = 7;
   
   @(negedge Stall );
   #20 
   mem_write = 0;   
   mem_read = 1;
   byte_address = 10'b1110000000;
   
   @(negedge Stall );
   #20 
   mem_write = 1; 
   mem_read = 0;
   byte_address = 10'b1110000000;
   DataIn = 10;
   
   @(negedge Stall );
   #20 
   mem_write = 0; 
   mem_read = 1;
   byte_address = 10'b1110000000;
   
   
   #80  
   mem_write = 1; 
   mem_read = 0;
   byte_address = 10'b1110000001;
   DataIn = 11;    
   
   #80 
   mem_write = 1; 
   mem_read = 0;
   byte_address = 10'b1110000010;
   DataIn = 12;      

   #80   
   mem_write = 1; 
   mem_read = 0;
   byte_address = 10'b1110000011;
   DataIn = 13;    
   
   #80  
   mem_write = 0; 
   mem_read = 1;
   byte_address = 10'b1110000001; 
   
   #100  
   mem_write = 0; 
   mem_read = 1;
   byte_address = 10'b1110000010; 
   
   #100   
   mem_write = 0; 
   mem_read = 1;
   byte_address = 10'b1110000011; 
   
  
 end
 
 
 
 
  
endmodule 

*/

