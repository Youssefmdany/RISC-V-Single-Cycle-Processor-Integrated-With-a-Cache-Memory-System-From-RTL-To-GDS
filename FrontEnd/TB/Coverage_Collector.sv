class Coverage_Collector  extends uvm_subscriber #(RISCV_seq_item);





  `uvm_component_utils(Coverage_Collector)
  
  
  
  
  
  RISCV_seq_item item;
  
  
  
 covergroup Basic_signals_cover ;


   Reset_cov: coverpoint item.reset; 


endgroup: Basic_signals_cover
  
  




  covergroup instructions_cover ; 
  
        option.per_instance = 1;


        R_Type: coverpoint item.inst_data[14:12] iff( !item.reset & item.inst_data[6:0]==R_Type)
        
        {
        
          bins ADD = {3'b000} iff(item.inst_data[31:25]==7'b0000000);
          bins SUB = {3'b000} iff(item.inst_data[31:25]==7'b0100000);
          bins SLL = {3'b001};
          bins SLT = {3'b010};
          bins SLTU = {3'b011};
          bins XOR = {3'b100};
          bins SRL = {3'b101} iff(item.inst_data[31:25]==7'b0000000);
          bins SRA = {3'b101} iff(item.inst_data[31:25]==7'b0100000);
          bins OR = {3'b110};
          bins AND = {3'b111};        
                      
        }






       I_Type: coverpoint item.inst_data[14:12] iff( !item.reset & (item.inst_data[6:0]==I_Type_1 || item.inst_data[6:0]==I_Type_2 || item.inst_data[6:0]==I_Type_3))
        
        {
        
          bins LB = {3'b000} iff(item.inst_data[31:25]==7'b0000000);
          bins LH = {3'b001} iff(item.inst_data[31:25]==7'b0100000);
          bins LW = {3'b010};
          bins LBU = {3'b100};
          bins LHU = {3'b101};
          bins ADDI = {3'b000} iff(item.inst_data[6:0]==7'b0010011);
          bins SLLI = {3'b001} iff(item.inst_data[31:25]==7'b0000000 && item.inst_data[6:0]==7'b0010011);
          bins SLTI = {3'b010} iff(item.inst_data[6:0]==7'b0010011);
          bins SLTIU = {3'b011} iff(item.inst_data[6:0]==7'b0010011);
          bins XORI = {3'b100} iff(item.inst_data[6:0]==7'b0010011);       
          bins SRLI = {3'b101} iff(item.inst_data[31:25]==7'b0000000 && item.inst_data[6:0]==7'b0010011);
          bins SRAI = {3'b101} iff(item.inst_data[31:25]==7'b0100000 && item.inst_data[6:0]==7'b0010011);
          bins ORI = {3'b110} iff(item.inst_data[6:0]==7'b0010011);
          bins ANDI = {3'b111} iff(item.inst_data[6:0]==7'b0010011);
          bins JALR = {3'b000} iff(item.inst_data[6:0]==7'b1100111);         
          
          
          
        }
        
      
      
      
      
      
       S_Type: coverpoint item.inst_data[14:12] iff( !item.reset & (item.inst_data[6:0]==S_Type))
        
        {
        
          bins SB = {3'b000};
          bins SH = {3'b001};
          bins SW = {3'b010};
          
                   
        }






    	  B_Type: coverpoint item.inst_data[14:12] iff( !item.reset & (item.inst_data[6:0]==B_Type))
        
        {
        
          bins BEQ = {3'b000};
          bins BNQ = {3'b001};
          bins BLT = {3'b100};
          bins BGE = {3'b101};
          bins BLTU = {3'b110};
          bins BGEU = {3'b111};
                   
        }  
     	 
     	 
     	 
     	 
     	 
     	  
      	J_Type: coverpoint item.inst_data[14:12] iff( !item.reset & (item.inst_data[6:0]==J_Type))
        
        {
        
          wildcard bins JAL = {3'b???};   
                         
        }   







      U_Type: coverpoint item.inst_data[14:12] iff( !item.reset & (item.inst_data[6:0]==U_Type_1 || item.inst_data[6:0]==U_Type_2))
        
        {
        
          wildcard bins AUIPC = {3'b???} iff(item.inst_data[6:0]==U_Type_1);
          
          wildcard bins LUI = {3'b???}  iff(item.inst_data[6:0]==U_Type_2);
          
          
                         
        }   

     	 
     	 
     	 
     	      
  
  endgroup: instructions_cover
  
  
  









  
  function new(string name = "Coverage_collector" ,uvm_component parent);
  
  
    super.new(name,parent);
  
    `uvm_info(get_type_name(),"Inside constructor of coverage collector Class",UVM_LOW)
  
    instructions_cover = new();
    
    Basic_signals_cover = new();
    
  endfunction :new
    
  
  
  
  
  
  function void build_phase(uvm_phase phase);
  
  
    super.build_phase(phase);
    
	 
	 `uvm_info(get_type_name(),"Inside build phase of coverage collector Class",UVM_LOW)
	 
  
  endfunction :build_phase 
  
  
  
  
  
  
  
  
  function void connect_phase (uvm_phase phase);
  
  
    super.connect_phase(phase);
	 
	 
	 `uvm_info(get_type_name(),"Inside connect phase of coverage collector Class",UVM_LOW)
	 
  
  endfunction :connect_phase
  
  
  
  
  
  
  
  task  run_phase(uvm_phase phase);
  
  
    super.run_phase(phase);
  
  
	 `uvm_info(get_type_name(),"Inside run phase of coverage collector Class",UVM_LOW)
    
  
 
  endtask :run_phase
  
  
  
  
  
  
  
  
  
  function void write (RISCV_seq_item  t);


      item = RISCV_seq_item::type_id::create("item");
      
      $cast(item,t);
      
      instructions_cover.sample();
	
      Basic_signals_cover.sample(); 
	    
  
     
     
  endfunction: write
  
  
  
  
  
  
  
  
  
  
  
  
  
  
endclass :Coverage_Collector
