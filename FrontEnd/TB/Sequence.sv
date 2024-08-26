
///////////////////////////////
//Base_sequence/////////////////////////////
///////////////////////////////

class Base_sequence extends uvm_sequence #(RISCV_seq_item);

  
  
  `uvm_object_utils(Base_sequence)
   
  
  
  
  
  function  new(string name = "Base_sequence");
  
  
     super.new(name);
	  
  
  endfunction: new
  

  

endclass: Base_sequence







///////////////////////////////
//Reset_sequence/////////////////////////////
///////////////////////////////

class Reset_seq extends Base_sequence;



  `uvm_object_utils(Reset_seq)
  
  
   RISCV_seq_item reset_item;
	

   function  new(string name = "Reset_seq");
  
  
     super.new(name);
	  
  
   endfunction: new
  
  
  
  
  
  task body();
  
  
    reset_item = RISCV_seq_item::type_id::create("reset_item");
  
  
    start_item(reset_item);
	 
	 
	 if(!(reset_item.randomize() with { reset==1;  inst_data==32'b00000000000000000000000100010011;} ))
	   
		   `uvm_error(get_type_name(),"randomization failed in Reset_seq")
		
	 
	 finish_item(reset_item);
	 
  
  endtask: body
  


  
endclass: Reset_seq
















class RISCV_seq extends Base_sequence;



  `uvm_object_utils(RISCV_seq)
  
  
   RISCV_seq_item item;
	    
     
   function  new(string name = "RISCV_seq");
  
  
        super.new(name);
	  
  
     endfunction: new
  
  
  
  
  
task body();
  
  
    item = RISCV_seq_item::type_id::create("item");
	 
	   start_item(item);
	   
	   
	  if(!(item.randomize() with { reset==0;  } ))
	   
		   `uvm_error(get_type_name(),"randomization failed in RISCV_seq")
	   
	   
    
	  finish_item(item);


  endtask: body
  


  
endclass: RISCV_seq









class temp_seq extends Base_sequence;



  `uvm_object_utils(temp_seq)
  
  
   RISCV_seq_item item;
	    
     
   function  new(string name = "temp_seq");
  
  
        super.new(name);
	  
  
     endfunction: new
  
  
  
  
  
task body();
  
  
    item = RISCV_seq_item::type_id::create("item");
	 
	   start_item(item);
	   
	   
	  if(!(item.randomize() with { reset==0; inst_data[6:0] inside {7'b0110111, 7'b0010111}; item.inst_data[11:7] inside {[5'b00001:5'b11111]};  } ))
	   
		   `uvm_error(get_type_name(),"randomization failed in temp_seq")
	   
	   
    
	  finish_item(item);


  endtask: body
  
  
  endclass: temp_seq
  
  
  
  









class R_type_seq extends Base_sequence;



  `uvm_object_utils(R_type_seq)
  
  
   RISCV_seq_item item;
	    
     
   function  new(string name = "R_type_seq");
  
  
        super.new(name);
	  
  
     endfunction: new
  
  
  
  
  
task body();
  
  
    item = RISCV_seq_item::type_id::create("item");
	 
	   start_item(item);
	   
	   
	  if(!(item.randomize() with { reset==0; inst_data[6:0] inside {7'b0110011}; }))
	   
		   `uvm_error(get_type_name(),"randomization failed in R_type_seq")
	   
	   
    
	  finish_item(item);


  endtask: body
  
  
  endclass: R_type_seq





















class S_type_seq extends Base_sequence;



  `uvm_object_utils(S_type_seq)
  
  
   RISCV_seq_item item;
	    
     
   function  new(string name = "S_type_seq");
  
  
        super.new(name);
	  
  
     endfunction: new
  
  
  
  
  
task body();
  
  
    item = RISCV_seq_item::type_id::create("item");
	 
	   start_item(item);
	   
	   
	  if(!(item.randomize() with { reset==0; inst_data[6:0] inside {7'b0100011}; }))
	   
		   `uvm_error(get_type_name(),"randomization failed in S_type_seq")
	   
	   
    
	  finish_item(item);


  endtask: body
  
  
  endclass: S_type_seq















  
  
  
  
  class invalid_instr extends Base_sequence;



  `uvm_object_utils(invalid_instr)
  
  
   RISCV_seq_item item;
	    
     
   function  new(string name = "invalid_instr");
  
  
        super.new(name);
	  
  
     endfunction: new
  
  
  
  
  
task body();
  
  
    item = RISCV_seq_item::type_id::create("item");
	 
	   start_item(item);
	   
	   
	  item.reset = 0; 
	  item.inst_data[31:0] =32'b0 ; 
	   
		 
	   
	   
    
	  finish_item(item);


  endtask: body


  
endclass: invalid_instr



