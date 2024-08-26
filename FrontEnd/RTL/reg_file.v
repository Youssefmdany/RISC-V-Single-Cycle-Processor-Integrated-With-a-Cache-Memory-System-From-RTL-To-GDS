module reg_file (
input clk,reset,Stall,
input [4:0] read_register1,
input [4:0] read_register2,
input [4:0] write_register,
input [31:0] write_data,
input  write_en,

output [31:0] read_data1,read_data2,reg_data
);

//internal



reg [31:0] registers [31:0];
reg[31:0] t_addr;



//read
assign read_data1= registers[read_register1];
assign read_data2= registers[read_register2];

assign reg_data = write_data;

integer i;

  

initial begin 

 for (i=1; i<32; i=i+1)begin

            registers[i]= 32'b0;

          end

end



//write

always @(posedge clk,posedge reset) begin


     if (write_en  && !Stall) begin
        
        registers[t_addr] <= write_data;
     end

 t_addr <= write_register;
 registers[0] <= 0;


end



endmodule
