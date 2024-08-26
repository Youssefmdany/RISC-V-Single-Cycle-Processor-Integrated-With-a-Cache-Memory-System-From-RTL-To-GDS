  module Cache_Contrl(clk,reset,addr,mem_read,mem_write,miss,fill,ready,stall,hit);
  
  
  
  parameter idle = 2'b00;
  parameter writing = 2'b01;
  parameter reading = 2'b10;    
  
  parameter lines = 32;
  parameter tags = 3;
  
  
  input clk,reset,ready;
  input[1:0] mem_read,mem_write;
  input[11:0] addr;
  output reg miss,hit,stall,fill;

  reg[tags-1:0] tags_arr [lines-1:0];
  reg valid_arr [lines-1:0];
  reg[1:0] state,next_state;  
  reg old_op;
  integer i;
  
  
  
  
  
  always@(*) begin
  
   miss = ( ( !valid_arr[addr[8:4]]) || ( tags_arr[addr[8:4]] !=  addr[11:9] ) && mem_read ) || ( ( tags_arr[addr[8:4]] !=  addr[11:9] ) && mem_write );
   hit = ( ( valid_arr[addr[8:4]]) && ( tags_arr[addr[8:4]] ==  addr[11:9] ) && (mem_write || mem_read || old_op) ) ;   //|| old_op used to elimnate glitch in hit signals 
   stall = ( ( (miss || hit ) && mem_write) || (miss && mem_read) )  ;   
   
   

  
   if(ready == 1)
               stall = 0;
   else    
               stall = stall;       
   

    
  end






 always@(negedge clk,posedge reset)begin
   
   if(reset) begin
     
     state <= idle;    
     old_op <= 0;
    // t_stall <= 0;
    // stall <= 0;
    
     for(i=0;i<32;i=i+1) begin 
            valid_arr[i] <= 0;
            tags_arr[i] <= 0;
          end
          
   end
   
   
  else begin
    
    state <= next_state;
    old_op <= mem_read || mem_write;
    
    if(mem_write && !miss) begin
      
         tags_arr[addr[8:4]] <= addr[11:9];
         valid_arr[addr[8:4]] <= 1;
      
    end
    
    else if (fill) begin
          valid_arr[addr[8:4]] <= 1; 
          tags_arr[addr[8:4]] <= addr[11:9];   
              
    end    
    
    //stall <= t_stall;
   
  end
   
   
   
   
 end






 always@(state,mem_read,mem_write,ready,miss,hit)begin
 
  fill = 0 ; 
  
  case(state)
    
    idle: begin
             
             if (mem_read) begin
                          next_state = reading;
                          //if(miss) 
                             // t_stall = 1;
                        end
                          
             else if (mem_write) begin
                          next_state = writing;
                          //if(miss || hit) 
                              // t_stall = 1;
                      end
                      
             else 
                    next_state = idle;
          end
   


    reading: begin
      
                if (miss) begin
                  if(ready) begin
                    //t_stall = 0;
                    next_state = idle;
                    fill = 1;
                    
                  end
                  
                else
                  next_state = reading;
                           
                end
                
                
                else begin
                                
                 
                    
             
                    if (mem_read)
                                 next_state = reading;
                          
                    else if (mem_write)
                                 next_state = writing;
                    
                    else 
                                 next_state = idle ;
   
                end
      
      
          end
          
 
    writing: begin
                
               if(hit || miss) begin
                 
                  if(ready) begin
                    next_state = idle;
                    //t_stall = 0;
                  end
                  
                  
                  else 
                    next_state = writing;
                    
                end
                
                  
                else begin
                           
             
                          if (mem_read)
                                 next_state = reading;
                          
                          else if (mem_write)
                                 next_state = writing;
                                 
                          else 
                                 next_state = idle ;
                    
                  end
                        
      
          end 
          
        default : begin
        
               next_state = idle;
         end   
   
  endcase




end

  
  
endmodule 







/* module Contrl_tb();
  

  reg clk,reset,ready;
  reg mem_read,mem_write;
  reg[9:0] addr;
  wire miss,stall,fill;  
  
Cache_Contrl dut(.clk(clk),.reset(reset),.ready(ready),.mem_read(mem_read),.mem_write(mem_write),.addr(addr),.miss(miss),.stall(stall),.fill(fill));  


initial begin
  
  clk = 0;
  
  forever begin
   
      clk = #10 ~clk;
  
  end  
  
  
end






initial begin
  ready = 0;
  mem_read = 0; 
  mem_write = 0; 
  reset = 0;
  #30
  reset = 1;
  #20
  reset = 0;
  mem_read = 1;
  addr = 10'b1110000000;
  #200
  mem_read = 0;
  ready = 1;
  #20
  ready = 0;
  mem_write = 1;
  addr = 10'b1010000000;
  #200
  ready = 1;
  mem_write = 0;
  #20
  mem_write = 1;
    ready = 0;
  addr = 10'b1110000000;
  #200
  mem_write = 0;
  ready = 1; 
  
  
  
  
  
  
  
  
  
end


  
  
endmodule */



