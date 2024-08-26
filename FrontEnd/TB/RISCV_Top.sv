`include "Interface.sv"




module RISCV_Top ( );
                                 
    


                             
import RISCV_pkg::*;

import uvm_pkg::*;

logic clk;
 




Interface intf (.clk(clk));
 

RISCV risc_v (   .clk(intf.clk),
                 .reset(intf.reset),
                 .inst_data(intf.inst_data),
                 .Wdata(intf.Wdata),
                 .Rdata(intf.Rdata),
                 .Data_addr(intf.Data_addr),
                 .we(intf.we),
                 .re(intf.re),
                 .PC(intf.PC),
                 .reg_data(intf.reg_data),
                 .Stall(intf.Stall)          );
                                                                              
 
Data_Memory_System data_mem_sys (     .clk(intf.clk),
                                      .reset(intf.reset),
                                      .mem_read(intf.re),
                                      .mem_write(intf.we),
                                      .byte_address(intf.Data_addr),
                                      .DataIn(intf.Wdata),
                                      .DataOut(intf.Rdata),
                                      .Stall(intf.Stall)         );
  









initial begin 


  clk = 1;
  
  forever  #20 clk = ~clk;


end







initial begin 


  uvm_config_db #(virtual Interface)::set(null,"*","intf",intf);
  
  
  run_test("RISCV_Test");
  

end







initial begin 


  #40000000

  $finish();


end








                                 
endmodule 
