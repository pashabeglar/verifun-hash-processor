`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/18/2018 07:25:53 PM
// Design Name: 
// Module Name: Add
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

module Add (DataIn0, DataIn1, DataOut);
    input [31:0] DataIn0;
    input [31:0] DataIn1;
    output reg [31:0] DataOut;
    always @ (DataIn0, DataIn1)
    begin
        DataOut = DataIn0 + DataIn1;
    end
endmodule
