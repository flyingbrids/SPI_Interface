`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Liqing Shen
// 
// Create Date: 04/15/2022 11:46:39 AM
// Design Name: 
// Module Name: Fx3RegisterInterface
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This module handles register data between Fx3 and FPGA
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module Fx3RegisterInterface
#(      
     parameter    		   REG_DWIDTH = 32  
    ,parameter             REG_ALINES =  7 
    ,parameter             M_NUM_REG = 2**REG_ALINES
)
(
     input  logic sys_clk
   , input  logic sys_rst
   , input  logic s_spi_clk
   , input  logic s_spi_cs_n
   , input  logic s_spi_mosi
   , output logic s_spi_miso
   , output logic [REG_DWIDTH*M_NUM_REG-1:0] top_register_data  // distribute register value to application layer
   , input  logic [REG_DWIDTH*M_NUM_REG-1:0] top_register_dfbck  // collect regigster value from application layer
);

logic                             reg_wr                       ;
logic                             reg_rd                       ;

logic            [REG_ALINES-1:0] reg_addr                     ; 
logic            [REG_DWIDTH-1:0] reg_rdata                    ; 
logic            [REG_DWIDTH-1:0] reg_wdata                    ; 
logic            [REG_DWIDTH-1:0] m_reg_rdata                  ; 
logic            [REG_DWIDTH-1:0] t_reg_rdata                  ; 
logic            [REG_DWIDTH-1:0] l_reg_rdata                  ; 
logic                             AWVALID                      ;
logic                             ARVALID                      ;

assign reg_rdata =  m_reg_rdata;

slave_spi
 #( 
    .DWIDTH      ( REG_DWIDTH    )
  , .ALINES      ( REG_ALINES    )
  )
slave_spi_i
  (
     .clk         ( sys_clk      )
   , .rst         ( sys_rst      )
   , .spi_clk     ( s_spi_clk    )
   , .spi_cs_n    ( s_spi_cs_n   )
   , .spi_mosi    ( s_spi_mosi   )
   , .spi_miso    ( s_spi_miso   )
   , .wr          ( reg_wr       )
   , .rd          ( reg_rd       )
   , .addr        ( reg_addr     )
   , .wr_data     ( reg_wdata    )
   , .rd_data     ( reg_rdata    )
  );

register_main
 #( 
    .DWIDTH      ( REG_DWIDTH    )
  , .NUM_REG     ( M_NUM_REG     )
  , .ALINES      ( REG_ALINES    )
  )
bank_0
  (
     .clk         ( sys_clk      )
   , .rst         ( sys_rst      )
   , .cs          ( 1'b1         )
   , .wr          ( reg_wr       )
   , .addr        ( reg_addr     )
   , .din         ( reg_wdata    )
   , .dout        ( m_reg_rdata  )   
   , .dfbck       ( top_register_dfbck )
   , .regdata     ( top_register_data )
  );


endmodule
