//*******************************************************************************************
//**
//**  File Name          : register_main.sv(SystemVerilog)
//**  Module Name        : register_main
//**                     :
//**  Module Description : Register Bank wrapper  
//**                     : 
//**                     : 
//**                     : 
//**                     :
//**  Author             : LeonShen
//**  Email              : 
//**  Phone              : 
//**                     :
//**  Creation Date      : 6/29/2021
//**                     : 
//**  Version History    : 1.0 Initial release
//**                     :
//**
//*******************************************************************************************
                                                               
module register_main
  #(
     parameter           DWIDTH = 16
   , parameter           NUM_REG = 8
   , parameter           ALINES  = 7
   )
   (	
     input   logic                       clk 
   , input   logic                       rst     
   , input   logic                       cs                          
   , input   logic                       wr                        
   , input   logic  [ALINES-1:0]         addr                        
   , input   logic  [DWIDTH-1:0]         din                         
   , input   logic  [DWIDTH*NUM_REG-1:0] dfbck              
   , output  logic  [DWIDTH*NUM_REG-1:0] regdata
   , output  logic  [NUM_REG-1:0]        decd                        
   , output  logic  [DWIDTH-1:0]         dout                        
   ) ;                  



logic [DWIDTH-1:0] dfbck_packed [0:NUM_REG-1];
logic [DWIDTH-1:0] regdata_packed [0:NUM_REG-1];
int   j; 

genvar i;
generate 
for (i=0; i<NUM_REG; i++) begin : write2reg
  assign regdata[DWIDTH*(i+1)-1: DWIDTH*i] = regdata_packed[i];   
  assign dfbck_packed[i] = dfbck[DWIDTH*(i+1)-1: DWIDTH*i] ;    
  assign decd[i] = cs && (addr==i) ? 1'b1 : 1'b0; 
     
  always_ff @(posedge clk or posedge rst) begin
    if (rst)
      case (i)
      // initialize your register values if non zeros here.... 
      // ...  
      //
      default: regdata_packed[i] <= '0;
      endcase 
    else if (wr && decd[i])
      regdata_packed[i] <= din ; 
    end
    
end
endgenerate

always @(decd) begin
  dout <= '0 ;
  for (j=0; j<NUM_REG; j++) 
    if (decd[j])    
      dout <= dfbck_packed[j];
  end         
	
	
endmodule   