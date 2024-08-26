

class RISCV_Test  extends uvm_test;



  `uvm_component_utils(RISCV_Test)
  
  
  
  Environment RISCV_environment;
  
  
  
  Reset_seq reset_seq;
  
  RISCV_seq seq;

  temp_seq  temp;

  R_type_seq R_t_seq ;
 
  S_type_seq S_t_seq ;
  
  
  
  
  function new(string name = "RISCV_Test" ,uvm_component parent);
  
  
    super.new(name,parent);
  
    `uvm_info(get_type_name(),"Inside constructor of RISCV Test Class",UVM_LOW)
  
  
  endfunction :new
  
  
  
  
  
  
  
  
  
  function void build_phase(uvm_phase phase);
  
  
    super.build_phase(phase);
    
	 
	 `uvm_info(get_type_name(),"Inside build phase of RISCV Test Class",UVM_LOW)

	 
	 RISCV_environment = Environment::type_id::create("RISCV_environment",this);
	 
	 
  
  endfunction :build_phase 
  
  
  
  
  
  
  
  
  function void connect_phase (uvm_phase phase);
  
  
    super.connect_phase(phase);
	 
	 
	 `uvm_info(get_type_name(),"Inside connect phase of RISCV Test Class",UVM_LOW)
	 
  
  endfunction :connect_phase
  
  
  
  
  
  
  
  
  
  task  run_phase(uvm_phase phase);
  
  
    super.run_phase(phase);
  
  
	 `uvm_info(get_type_name(),"Inside run phase of RISCV Test Class",UVM_LOW)
  
   
	
	 phase.raise_objection(this);
  
    
	    //apply reset sequence
	    
      
      reset_seq = Reset_seq::type_id::create("reset_seq");
	 
	    reset_seq.start(RISCV_environment.RISCV_Agent.RISCV_sequencer);
		 
     // #40;

	    
		 
		 repeat(50)begin	 
      		 
		   temp = temp_seq::type_id::create("temp");
	  
	     temp.start(RISCV_environment.RISCV_Agent.RISCV_sequencer);
	    
		  //#40;		 

	   end


	   
     repeat(10000)begin	 
      		 
		   R_t_seq = R_type_seq::type_id::create("R_t_seq");
	  
	          R_t_seq.start(RISCV_environment.RISCV_Agent.RISCV_sequencer);
	    
		  //#40;		 

	   end


	 	   
     repeat(10000)begin	 
      		 
		   S_t_seq = S_type_seq::type_id::create("S_t_seq");
	  
	          S_t_seq.start(RISCV_environment.RISCV_Agent.RISCV_sequencer);
	    
		  //#40;		 

	   end

		 
		 
     repeat(100000)begin	 
      		 
		   seq = RISCV_seq::type_id::create("seq");
	  
	     seq.start(RISCV_environment.RISCV_Agent.RISCV_sequencer);
	    
		  //#40;		 

	   end
	 
	 
	
	     

	 
	  
	  
	 	  
	  	  
	  
	 phase.drop_objection(this);
  
  
  
  
 
  endtask :run_phase
  
  
  
  
  
  
  
  
endclass :RISCV_Test
