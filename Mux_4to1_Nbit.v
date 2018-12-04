`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2018 08:48:05 AM
// Design Name: 
// Module Name: Mux_4to1
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
// Sel:  00==> DataIn0
// Sel:  01==> DataIn1
// Sel:  10==> DataIn2
// Sel:  11==> DataIn3
// Sel:  default==> DataIn0
//////////////////////////////////////////////////////////////////////////////////

module Mux_4to1_Nbit(DataIn0, DataIn1, DataIn2, DataIn3, Sel, DataOut);
    parameter N = 32;
   
    input[N-1:0] DataIn0;
    input[N-1:0] DataIn1;
    input[N-1:0] DataIn2;
    input[N-1:0] DataIn3;
    input [1:0] Sel;
    output reg [N-1:0] DataOut;
    always @ (DataIn0, DataIn1, DataIn2, DataIn3, Sel)
       begin
          case(Sel)
             0: DataOut = DataIn0;
             1: DataOut = DataIn1;
             2: DataOut = DataIn2;
             3: DataOut = DataIn3;
             default: DataOut = DataIn0;
          endcase
       end
endmodule

