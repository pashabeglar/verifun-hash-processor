`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2018 06:59:25 PM
// Design Name: 
// Module Name: MIPSALU_11
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


module ALU(Sel, DataIn1, DataIn2, Result, Zero);
input [3:1] Sel;
input [31:0] DataIn1, DataIn2;
output reg [31:0] Result;
output Zero;
assign Zero=(Result==0);
always@(Sel, DataIn1, DataIn2)
   begin 
      case(Sel)
         0: Result = DataIn1 & DataIn2;
         1: Result = DataIn1 | DataIn2;
         2: Result = DataIn1 + DataIn2;
         6: Result = DataIn1 - DataIn2;
         7: Result = DataIn1 < DataIn2 ? 1:0;
         12: Result = ~(DataIn1 | DataIn2);  //NOR 
         default: Result=0;
       endcase
    end
endmodule
