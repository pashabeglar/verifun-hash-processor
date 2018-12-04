`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2018 10:59:35 AM
// Design Name: 
// Module Name: SignedExtend
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


module SignedExtend(DataIn, DataOut);
    input  [15:0] DataIn;
    output [31:0] DataOut;
    assign DataOut = {{16{DataIn[15]}}, DataIn};
endmodule
