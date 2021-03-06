`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2018 06:34:06 PM
// Design Name: 
// Module Name: FwdUnitHFnc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module FwdUnitHFnc(ex_mem_RegWrite,
                   ex_mem_RegisterRd,
                    mem_wb_RegWrite,
                    mem_wb_RegisterRd,
                    id_ex_RegisterRs,
                    id_ex_RegisterRt,
                    id_ex_RegisterRu,
                   ForwardA,
                   ForwardB,
                   ForwardC
                   );
input ex_mem_RegWrite;
input [4:0] ex_mem_RegisterRd;
input mem_wb_RegWrite;
input[4:0]  mem_wb_RegisterRd;
input[4:0] id_ex_RegisterRs;
input[4:0]  id_ex_RegisterRt;
input[4:0]  id_ex_RegisterRu;
output reg [1:0] ForwardA;
output reg [1:0] ForwardB;
output reg [1:0] ForwardC;

always @(*)
   begin
      //---- Forward A ----//
      if(ex_mem_RegWrite && 
        (ex_mem_RegisterRd != 0)&&
        (ex_mem_RegisterRd == id_ex_RegisterRs)) begin
            ForwardB=2'b01;  
      end else if( mem_wb_RegWrite &&
                (mem_wb_RegisterRd!=0)&&
                (mem_wb_RegisterRd ==id_ex_RegisterRs)) begin
            ForwardB=2'b10;  
      end else begin
            ForwardB=2'b00;
      end
      
      //---- Forward B ----//
      if(ex_mem_RegWrite && 
        (ex_mem_RegisterRd != 0)&&
        (ex_mem_RegisterRd == id_ex_RegisterRt)) begin
            ForwardB=2'b01;  
      end else if( mem_wb_RegWrite &&
                (mem_wb_RegisterRd!=0)&&
                (mem_wb_RegisterRd ==id_ex_RegisterRt)) begin
            ForwardB=2'b10;  
      end else begin
            ForwardB=2'b00;
      end
      
      //------Forward C------//
       if(ex_mem_RegWrite && 
             (ex_mem_RegisterRd != 0)&&
             (ex_mem_RegisterRd == id_ex_RegisterRu)) begin
                 ForwardC=2'b01;  
           end else if( mem_wb_RegWrite &&
                     (mem_wb_RegisterRd!=0)&&
                     (mem_wb_RegisterRd ==id_ex_RegisterRu)) begin
                 ForwardC=2'b10;  
           end else begin
                 ForwardC=2'b00;
        end
   end
      
endmodule
