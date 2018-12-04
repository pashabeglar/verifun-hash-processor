`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2018 08:53:47 PM
// Design Name: 
// Module Name: Cmp_Nbit
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


module Cmp_Nbit(DataIn0, DataIn1, Op);
    parameter N = 32;
   
    input[N-1:0] DataIn0;
    input[N-1:0] DataIn1;
    output reg Op;
    
    always @ (DataIn0, DataIn1)
    begin: Comparator_op
        assign Op = ~(|(DataIn0 ^ DataIn1));
    end
endmodule
