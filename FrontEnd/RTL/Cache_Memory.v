module Cache_Memory (clk,addr,byte_sel,mem_block,mem_read,mem_write,data_in,data_out,fill,miss,hit,ready);
  
  
  
  parameter line_size = 128;
  parameter lines = 32;
  parameter word = 2;
  
  
  
  
    
  input fill,miss,hit,ready,clk;
  input[6:0] addr;
  input[1:0] byte_sel;
  input[127:0] mem_block;
  input[31:0] data_in;
  input[1:0] mem_read,mem_write;
  output reg[31:0] data_out;
  reg[31:0] data_out_t;
  wire[7:0] offset;  

  reg[line_size-1:0] cache_mem [lines-1:0];

  
  
 assign offset =  {addr[1:0],byte_sel[1:0]} << 3;
  
  
  
  
  always@(negedge clk) begin
    
 



 if (mem_read && !miss && hit && !fill) begin

            if (mem_read == 2'b01 && offset < 121)
                data_out <= cache_mem[addr[6:2]][offset +: 8]; // 8-bit read
            else if (mem_read == 2'b10 && offset < 113)
                data_out <= cache_mem[addr[6:2]][offset +: 16]; // 16-bit read
            else if (mem_read == 2'b11 && offset < 97)
                data_out <= cache_mem[addr[6:2]][offset +: 32]; // 32-bit read


        end 

           else if (mem_write && hit) begin

            if (mem_write == 2'b01 && offset < 121)
                cache_mem[addr[6:2]][offset +: 8] <= data_in[7:0]; // 8-bit write
            else if (mem_write == 2'b10 && offset < 113)
                cache_mem[addr[6:2]][offset +: 16] <= data_in[15:0]; // 16-bit write
            else if (mem_write == 2'b11 && offset < 97)
                cache_mem[addr[6:2]][offset +: 32] <= data_in[31:0]; // 32-bit write


        end 



           else if (fill) begin

            cache_mem[addr[6:2]] <= mem_block; // Fill cache line with mem_block data
            case (mem_read)
                2'b01: data_out <= mem_block[offset +: 8]; // 8-bit read after fill
                2'b10: data_out <= mem_block[offset +: 16]; // 16-bit read after fill
                2'b11: data_out <= mem_block[offset +: 32]; // 32-bit read after fi
            endcase

        end

    end
  
  
  
  
  
  
  
  
  
endmodule







/* module test_bench();
  
  reg fill;
  reg[9:0] addr;
  reg[127:0] mem_block;
  reg[31:0] data_in;
  reg mem_read,mem_write;
  reg miss;
  wire[31:0] data_out; 
  
  
  Cache_Memory dut (.fill(fill),.addr(addr),.mem_block(mem_block),.data_in(data_in),.mem_read(mem_read),.mem_write(mem_write),.miss(miss),.data_out(data_out));
  
  
  

  
  
  
  
  
  
  initial begin
    
  
    
    #100
    fill = 0;
    miss =0;
    addr = 10'b1110000000;
    mem_read = 1;
    
    #100
    
    fill = 1;
    mem_block = 7;
    
    
    
    #25
    
    fill =0;
    
    
    
    
    addr = 10'b1110000000;
    mem_read = 1;
    
 
 
 
 
     #100
    fill = 0;
    miss =1;
        mem_read = 0;
    addr = 10'b1000000000;
    mem_write = 1;
    data_in = 2024;
    
    #100
    
    
    addr = 10'b1000000000;
    mem_read = 1;
    
    


     #100
    fill = 0;
    miss = 0;
        mem_read = 0;
    addr = 10'b1110000000;
    mem_write = 1;
    data_in = 10;
    
    #100
    
    
    addr = 10'b1110000000;
    mem_read = 1;
    
    
    
    
    
  end
  
  
  
  
  
  
endmodule
*/
