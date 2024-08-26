class Scoreboard extends uvm_scoreboard;


  `uvm_component_utils(Scoreboard)





  RISCV_seq_item item;


  mem_ref_model mem_ref_model_h;
 
  reg_ref_model reg_ref_model_h;


  uvm_analysis_export #(RISCV_seq_item) SB_EX_port;

  uvm_tlm_analysis_fifo #(RISCV_seq_item) SB_TLM_port;

  bit[31:0] mismatching_count,inst_curr,inst_old,rd,PC = 4;





  function new(string name = "Scoreboard" , uvm_component parent);

     super.new(name,parent);
     `uvm_info(get_type_name(),"Inside constructor of Scoreboard Class",UVM_LOW)

  endfunction: new


  

  function void build_phase (uvm_phase phase);

      super.build_phase(phase);
     `uvm_info(get_type_name(),"Inside build phase of Scoreboard Class",UVM_LOW)

      SB_EX_port = new("SB_EX_port",this);
      SB_TLM_port = new("SB_TLM_port",this);
     
      if(!uvm_config_db #(mem_ref_model)::get(this,"","mem_ref_model_h",mem_ref_model_h))
          `uvm_error(get_type_name(),"error in getting mem_ref_model")


      if(!uvm_config_db #(reg_ref_model)::get(this,"","reg_ref_model_h",reg_ref_model_h))
          `uvm_error(get_type_name(),"error in getting reg_ref_model")

      reg_ref_model_h.init_reg();
      mem_ref_model_h.init_mem();


  endfunction: build_phase





  function void connect_phase (uvm_phase phase);

      super.connect_phase(phase);
     `uvm_info(get_type_name(),"Inside connect phase of Scoreboard Class",UVM_LOW)

      SB_EX_port.connect(SB_TLM_port.analysis_export);    

  endfunction: connect_phase





  task run_phase (uvm_phase phase);

      super.run_phase(phase);
     `uvm_info(get_type_name,"Inside connect phase of Scoreboard Class",UVM_LOW)
     
      item = RISCV_seq_item::type_id::create("item");
       
      mismatching_count = 0;      
 
      forever begin

           SB_TLM_port.get(item);

           Check_Results(item);
 

       end

      
     
 

  endtask: run_phase








 function void check_phase (uvm_phase phase);


    super.check_phase(phase);

     `uvm_info(get_type_name,"Inside check phase of Scoreboard Class",UVM_LOW)

     `uvm_info(get_type_name(),$sformatf("######### The num of mismatching data = %0d  #########",mismatching_count),UVM_LOW)

 endfunction: check_phase







 task Check_Results (RISCV_seq_item item);

 

   bit[31:0] rs1,rs2,data_r,imm,address,address_z,temp,BTA;
   bit branch;
   reg_ref_model_h.write_reg(0,0);
   rs1 = reg_ref_model_h.read_reg(item.inst_data[19:15]);
   rs2 = reg_ref_model_h.read_reg(item.inst_data[24:20]);
    
   inst_old = inst_curr;
   inst_curr = item.inst_data;



  if( inst_old[6:0] == I_Type_3 || inst_old[6:0] == B_Type || inst_old[6:0] ==J_Type ) begin

              

       if(PC != item.PC) begin

                  mismatching_count++;
                  `uvm_info(get_type_name(),$sformatf("invalid Program Counter address ----> the expected data = %h , while the actual data = %h",PC,item.PC),UVM_LOW)
        end


   end
 





   

   if(item.inst_data[6:0] == R_Type) begin



    if(item.inst_data[31:25] == 7'b0000000) begin

       case(item.inst_data[14:12])
          
        3'b000: rd = rs1 + rs2 ;
        3'b001: rd = rs1 << rs2[4:0] ;
        3'b010: rd = (rs1 < rs2) ;
        3'b011: rd = (rs1 < rs2) ;
        3'b100: rd = rs1 ^ rs2 ;
        3'b101: rd = rs1 >> rs2[4:0] ;
        3'b110: rd = rs1 | rs2 ;
        3'b111: rd = rs1 & rs2 ;



        endcase

     reg_ref_model_h.write_reg(item.inst_data[11:7],rd);      
    
     end








    else if(item.inst_data[31:25] == 7'b0100000) begin

       case(item.inst_data[14:12])
          
        3'b000: rd = rs1 - rs2 ;
        3'b101: rd = rs1 >>> rs2[4:0] ;

        endcase

     reg_ref_model_h.write_reg(item.inst_data[11:7],rd);     

     end




    if(rd != item.reg_data) begin

                  mismatching_count++;
                  `uvm_info(get_type_name(),$sformatf("invalid data ----> the expected data = %h , while the actual data = %h",rd,item.reg_data),UVM_LOW)
     end 

    else
           `uvm_info(get_type_name(),$sformatf("Passed ----> the expected data = %h , while the actual data = %h",rd,item.reg_data),UVM_LOW)  

   end






   else if(item.inst_data[6:0] == S_Type) begin
       

       temp = {{20{item.inst_data[31]}},item.inst_data[31:25] , item.inst_data[11:7] } ;
       address = rs1 + temp;

        

       case(item.inst_data[14:12])
          
        3'b000:begin 
                     mem_ref_model_h.write_mem(address,8,rs2);
                    if(rs2[7:0] != item.Wdata) begin

                          mismatching_count++;
                         `uvm_info(get_type_name(),$sformatf("invalid data ----> the expected data = %h , while the actual data = %h",rs2[7:0],item.Wdata),UVM_LOW)
                     end

                   else
                           `uvm_info(get_type_name(),$sformatf("Passed ----> the expected data = %h , while the actual data = %h",rs2[7:0],item.Wdata),UVM_LOW)  

               end

        3'b001: begin 
                     mem_ref_model_h.write_mem(address,16,rs2);
                    if(rs2[15:0] != item.Wdata) begin

                          mismatching_count++;
                         `uvm_info(get_type_name(),$sformatf("invalid data ----> the expected data = %h , while the actual data = %h",rs2[15:0],item.Wdata),UVM_LOW)
                     end
                   else
                           `uvm_info(get_type_name(),$sformatf("Passed ----> the expected data = %h , while the actual data = %h",rs2[15:0],item.Wdata),UVM_LOW)  

               end

        3'b010: begin 
                     mem_ref_model_h.write_mem(address,32,rs2);
                    if(rs2[31:0] != item.Wdata) begin

                          mismatching_count++;
                         `uvm_info(get_type_name(),$sformatf("invalid data ----> the expected data = %h , while the actual data = %h",rs2,item.Wdata),UVM_LOW)
                     end
                   else
                           `uvm_info(get_type_name(),$sformatf("Passed ----> the expected data = %h , while the actual data = %h",rs2[31:0],item.Wdata),UVM_LOW)  

               end


        endcase

   end






   else if(item.inst_data[6:0] == I_Type_1) begin


     address = rs1 + {{20{item.inst_data[31]}}, item.inst_data[31:20]};
     address_z = rs1 + {{20{1'b0}}, item.inst_data[31:20]};


       case(item.inst_data[14:12])
          
        3'b000: begin 
                   data_r = mem_ref_model_h.read_mem(address[11:0],8);
                    if(data_r != item.Rdata) begin

                          mismatching_count++;
                         `uvm_info(get_type_name(),$sformatf("invalid data ----> the expected data = %h , while the actual data = %h",data_r,item.Rdata),UVM_LOW)
                     end

                    else
                              reg_ref_model_h.write_reg(item.inst_data[11:7],data_r);
                              
               end

        3'b001: begin 
                   data_r = mem_ref_model_h.read_mem(address[11:0],16);
                    if(data_r != item.Rdata) begin

                          mismatching_count++;
                         `uvm_info(get_type_name(),$sformatf("invalid data ----> the expected data = %h , while the actual data = %h",data_r,item.Rdata),UVM_LOW)
                     end

                    else
                              reg_ref_model_h.write_reg(item.inst_data[11:7],data_r);
               end

        3'b010: begin 
                   data_r = mem_ref_model_h.read_mem(address,32);
                    if(data_r != item.Rdata) begin

                          mismatching_count++;
                         `uvm_info(get_type_name(),$sformatf("invalid data ----> the expected data = %h , while the actual data = %h",data_r,item.Rdata),UVM_LOW)
                     end

                    else
                              reg_ref_model_h.write_reg(item.inst_data[11:7],data_r);
               end

        3'b100: begin 
                   data_r = mem_ref_model_h.read_mem(address_z[11:0],8);
                    if(data_r != item.Rdata) begin

                          mismatching_count++;
                         `uvm_info(get_type_name(),$sformatf("invalid data ----> the expected data = %h , while the actual data = %h",data_r,item.Rdata),UVM_LOW)
                     end

                    else
                              reg_ref_model_h.write_reg(item.inst_data[11:7],data_r);
               end

        3'b101: begin 
                   data_r = mem_ref_model_h.read_mem(address_z[11:0],16);
                    if(data_r != item.Rdata) begin

                          mismatching_count++;
                         `uvm_info(get_type_name(),$sformatf("invalid data ----> the expected data = %h , while the actual data = %h",data_r,item.Rdata),UVM_LOW)
                     end

                    else
                              reg_ref_model_h.write_reg(item.inst_data[11:7],data_r);
               end

        endcase


    

   end





   else if(item.inst_data[6:0] == I_Type_2) begin
 
       imm = {{20{item.inst_data[31]}},item.inst_data[31:20]};       

       case(item.inst_data[14:12])
          
        3'b000: rd = rs1 + imm ;
        3'b001: rd = rs1 << item.inst_data[24:20] ;
        3'b010: rd = (rs1 < imm) ;
        3'b011: rd = (rs1 < imm) ;
        3'b100: rd = rs1 ^ imm ;
        3'b101: begin
                if (item.inst_data[31:25] == 7'b0000000)
                    rd = rs1 >> item.inst_data[24:20];                      // SRLI
                else if (item.inst_data[31:25] == 7'b0100000)
                    rd = rs1 >>> item.inst_data[24:20];                     // SRAI
                end
        3'b110: rd = rs1 | imm ;
        3'b111: rd = rs1 & imm ;

        endcase

     reg_ref_model_h.write_reg(item.inst_data[11:7],rd);   

    if(rd != item.reg_data) begin

                  mismatching_count++;
                  `uvm_info(get_type_name(),$sformatf("invalid data ----> the expected data = %h , while the actual data = %h  %h %h",rd,item.reg_data,imm,rs1),UVM_LOW)
     end 

    else
           `uvm_info(get_type_name(),$sformatf("Passed ----> the expected data = %h , while the actual data = %h",rd,item.reg_data),UVM_LOW)  


   end





   else if(item.inst_data[6:0] == B_Type) begin

        BTA = PC + {{20{item.inst_data[31]}}, item.inst_data[7], item.inst_data[30:25], item.inst_data[11:8], 1'b0};

        case (item.inst_data[14:12])
            3'b000: if (rs1 == rs2) PC = BTA;                        else  PC=PC+4;       // BEQ: Branch if Equal
            3'b001: if (rs1 != rs2) PC = BTA;                        else  PC=PC+4;       // BNE: Branch if Not Equal
            3'b100: if (rs1 < rs2) PC = BTA;                         else  PC=PC+4;      // BLT: Branch if Less Than
            3'b101: if (rs1 >= rs2) PC = BTA;                        else  PC=PC+4;      // BGE: Branch if Greater or Equal
            3'b110: if (rs1 < rs2) PC = BTA;                         else  PC=PC+4;      // BLTU: Branch if Less Than Unsigned
            3'b111: if (rs1 >= rs2) PC = BTA;                        else  PC=PC+4;      // BGEU: Branch if Greater or Equal Unsigned
        endcase




   end




   else if(item.inst_data[6:0] == U_Type_1) begin

        rd = {item.inst_data[31:12], 12'b0} + item.PC;                // AUIPC
        reg_ref_model_h.write_reg(item.inst_data[11:7],rd);

      if(rd != item.reg_data) begin

                  mismatching_count++;
                  `uvm_info(get_type_name(),$sformatf("invalid data ----> the expected data = %h , while the actual data = %h",rd,item.reg_data),UVM_LOW)
        end 

      else
           `uvm_info(get_type_name(),$sformatf("Passed ----> the expected data = %h , while the actual data = %h",rd,item.reg_data),UVM_LOW)  


   end






  else if(item.inst_data[6:0] == U_Type_2) begin

        rd = {item.inst_data[31:12], 12'b0};                     // LUI: Load Upper Immediate
        reg_ref_model_h.write_reg(item.inst_data[11:7],rd);


      if(rd != item.reg_data) begin

                  mismatching_count++;
                  `uvm_info(get_type_name(),$sformatf("invalid data ----> the expected data = %h , while the actual data = %h",rd,item.reg_data),UVM_LOW)
        end 

      else
           `uvm_info(get_type_name(),$sformatf("Passed ----> the expected data = %h , while the actual data = %h",rd,item.reg_data),UVM_LOW)  
        
   end






   else if(item.inst_data[6:0] == I_Type_3) begin

        rd = PC + 4;
        PC = rs1 + {{20{item.inst_data[31]}},item.inst_data[31:20]};               // JALR: Jump and Link Register
        reg_ref_model_h.write_reg(item.inst_data[11:7],rd);



      if(rd != item.reg_data) begin

                  mismatching_count++;
                  `uvm_info(get_type_name(),$sformatf("invalid data ----> the expected data = %h , while the actual data = %h",rd,item.reg_data),UVM_LOW)
        end 
       
      else
           `uvm_info(get_type_name(),$sformatf("Passed ----> the expected data = %h , while the actual data = %h",rd,item.reg_data),UVM_LOW)  


   end







   else if(item.inst_data[6:0] == J_Type) begin

        rd = PC + 4;
        PC = PC + {{12{item.inst_data[31]}}, item.inst_data[19:12], item.inst_data[20], item.inst_data[30:21], 1'b0}; // JAL: Jump and Link
        reg_ref_model_h.write_reg(item.inst_data[11:7],rd);



      if(rd != item.reg_data) begin

                  mismatching_count++;
                  `uvm_info(get_type_name(),$sformatf("invalid data ----> the expected data = %h , while the actual data = %h",rd,item.reg_data),UVM_LOW)
        end        
  
      else
           `uvm_info(get_type_name(),$sformatf("Passed ----> the expected data = %h , while the actual data = %h",rd,item.reg_data),UVM_LOW)  



   end






   if(inst_curr[6:0] != I_Type_3 && inst_curr[6:0] != B_Type && inst_curr[6:0] !=J_Type)

                 PC = PC + 4;




 endtask: Check_Results







endclass : Scoreboard
