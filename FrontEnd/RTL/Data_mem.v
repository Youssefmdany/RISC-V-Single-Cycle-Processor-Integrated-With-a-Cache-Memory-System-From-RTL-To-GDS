module DataMem (

                     input clk,reset,miss,hit,
                     input [11:0] Data_addr,
                     input [31:0] Wdata,
                     input[1:0]  we,re,		
                     output reg [127:0] Rdata,
                     output reg ready
		                                           );
		 
		 
		 
		 
reg [7:0] memory [2**12-1:0];
reg[2:0] c_r,c_w;
reg[1:0] ready_count;
wire[11:0] block_addr;



assign block_addr = {Data_addr[11:4],4'b0000};


integer i;

  

initial begin 

 for (i=0; i<2**12; i=i+1)begin

            memory[i]= 32'b0;

          end

end 


always@(posedge clk,posedge reset) begin
  
  
  if(reset) begin
    
    c_r<= 0;
    c_w<= 0;
    ready <=0;
    ready_count<=0;
    
  end
  
  

 //ready <= 0;
  
 else if((we != 2'b00)  && (re == 2'b00) && !ready) begin
     
      
      if(c_w == 3 ) begin
       
             if(we == 1) begin 
           
                    memory[Data_addr]<= Wdata[7:0] ;     
           
             end
         
         
         
             else if(we == 2) begin
          
                    memory[Data_addr+1]<= Wdata[15:8] ;
                    memory[Data_addr]<= Wdata[7:0] ;               
          
             end
        
        
             else  begin
          
                    memory[Data_addr+3]<= Wdata[31:24];
                    memory[Data_addr+2]<= Wdata[23:16] ;
                    memory[Data_addr+1]<= Wdata[15:8] ;
                    memory[Data_addr]<= Wdata[7:0] ;               
          
             end
           
                   
            ready <= 1;
            c_w <= 0;
          
        end
      
      else  begin
        
             if(ready_count<2)
                 c_w <= c_w + 1;   
             ready_count <= 0;    
        end
        
  end





else if((re != 2'b00) && miss && (we == 2'b00) && !ready) begin
   
    
    if(c_r == 3 ) begin 
          Rdata <= {memory[block_addr+15], memory[block_addr+14], memory[block_addr+13], memory[block_addr+12], 
                     memory[block_addr+11], memory[block_addr+10], memory[block_addr+9], memory[block_addr+8], 
                     memory[block_addr+7], memory[block_addr+6], memory[block_addr+5], memory[block_addr+4], 
                     memory[block_addr+3], memory[block_addr+2], memory[block_addr+1], memory[block_addr]};
          ready <= 1;
          c_r <= 0;
     end
     
           
    else  begin
             if(ready_count<2)  
                 c_r <= c_r + 1;  
             ready_count <= 0; 
        end
   
  end
  
  
  
  
else begin
      ready <= 0;
      if(ready_count !=3 )
          ready_count <= ready_count+1; 
end



end

   


	
	
endmodule









/* module mem_tb();
  
   
reg clk,reset,miss,hit;
reg [31:0] Data_addr;
reg [31:0] Wdata;
reg  we,re;
wire[127:0] Rdata;
wire ready;
		                                           
  
initial begin

clk =0;

  forever begin
  
    clk = #10 ~clk;
  
  end


end  



DataMem dut(.clk(clk),.reset(reset),.miss(miss),.hit(hit),.Data_addr(Data_addr),.Wdata(Wdata),.we(we),.re(re),.Rdata(Rdata),.ready(ready));




initial begin
reset = 1;
#20
reset = 0;
#20
Data_addr = 1;
we = 1;
Wdata =7;
miss = 1; 
  
 #100 
we = 0; 
Data_addr = 1;
re = 1;
miss = 1;

#100 
re = 0;
miss = 0;
Data_addr = 3;
we = 1;
Wdata =10;
hit = 1; 
  

 #100
 hit = 0; 
we = 0; 
Data_addr = 3;
re = 1;
miss = 1; 
  
  
  
end


  
  
endmodule */
