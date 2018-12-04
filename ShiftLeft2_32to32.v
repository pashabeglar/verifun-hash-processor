`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2018 11:01:34 AM
// Design Name: 
// Module Name: ShiftLeftTwo
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


module ShiftLeft2_32to32(DataIn, DataOut);
    input[31:0] DataIn;
    output[31:0] DataOut;
    assign DataOut = DataIn << 2;  //shift left two bits
endmodule