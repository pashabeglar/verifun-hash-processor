`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2018 09:15:54 PM
// Design Name: 
// Module Name: ShiftLeft2_26to28
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

module ShiftLeft2_26to28(DataIn, DataOut);
    input[25:0] DataIn;
    output[27:0] DataOut;
    assign DataOut = DataIn << 2;  //shift left two bits
endmodule