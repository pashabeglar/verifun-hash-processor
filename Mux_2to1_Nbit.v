`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2018 08:47:09 AM
// Design Name: 
// Module Name: MUX2to1_6_8_10
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


module Mux_2to1_Nbit(DataIn0, DataIn1, Sel, DataOut);
    parameter N = 32;
        
    input[N-1:0] DataIn0;
    input[N-1:0] DataIn1;
    input Sel;
    output reg [N-1:0] DataOut;
    always @ (DataIn0, DataIn1, Sel)
    begin
        case(Sel)
            0: DataOut = DataIn0;
            1: DataOut = DataIn1;
        endcase
    end
endmodule
