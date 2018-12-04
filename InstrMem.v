`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2018 11:37:00 AM
// Design Name: 
// Module Name: InstructionMem
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


module InstructionMem(clk, addr, instr);
    input clk;
    input [31:0] addr;
    output reg [31:0] instr;
    reg [31:0] mem [0:31];
        
    initial begin: Init_Mem
        $readmemb("instrROM.mem", mem); //Needs file mem name
    end      
    
    always @ (posedge clk)
    begin: IM_Out
        instr <= mem[addr[31:2]];
    end
endmodule
