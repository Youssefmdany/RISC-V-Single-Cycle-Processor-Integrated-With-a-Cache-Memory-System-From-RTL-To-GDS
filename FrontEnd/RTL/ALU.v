module ALU (input[31:0] A,B,input[3:0] ALUControl,output reg zero,output reg[31:0] ALUResult);
  
  
  
  
  
  always@* begin
    
    
    if( ALUControl == 4'b0000 )
    
                  ALUResult = A + B ;
                  
    else if(ALUControl == 4'b1000 )
    
                  ALUResult = A - B ;
                  
    else if(ALUControl == 4'b0001 )
    
                  ALUResult = A << B[4:0] ;

    else if( ALUControl == 4'b0010 || ALUControl == 4'b0011 )
    
                  ALUResult = ( A < B ) ;   
                  
    else if(ALUControl == 4'b0100)
    
                  ALUResult = A ^ B ;   
                  
    else if(ALUControl == 4'b0101)
    
                  ALUResult = A >> B[4:0] ;   
                  
    else if(ALUControl == 4'b1101)
    
                  ALUResult = A >>> B[4:0] ;                     
                  
    else if(ALUControl == 4'b0110)
    
                  ALUResult = A | B ;                                          
                  
    else if(ALUControl == 4'b0111)
    
                  ALUResult = A & B ;     
                               
    else 
                  ALUResult = 0;   
    
    if(ALUResult == 0) 
                       zero = 1 ; 
    else 
                       zero = 0 ;          
                   
 end
  
  
  
  
endmodule
