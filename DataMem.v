`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2018 11:55:40 AM
// Design Name: 
// Module Name: DataMem
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


module DataMem(clk, WrMem, RdMem, WrData, addr, RdData);
    input clk;
    input WrMem;
    input RdMem;
    input [31:0] WrData;
    input [31:0] addr;
    output reg [31:0] RdData;
    reg [31:0] mem [0:255]; //Width = 32'b, Depth = 2^8'b
        
    initial begin: Init_Mem
        $readmemb("dataRAM.mem", mem); //Needs file mem name
    end      
    
    always @ (posedge clk)
        begin: Data_In
            if(WrMem) begin
                mem[addr[31:2]] <= WrData;
            end
        end
        
    always @ (posedge clk)
    begin: Data_Out
        if(RdMem) begin
            RdData <= mem[addr[31:2]];
        end
    end
endmodule
