`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2018 08:57:56 AM
// Design Name: 
// Module Name: HFnc
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

//3'b0  Ch
//3'd1 Maj
//3'd4 ¦²(256_0)
//3'd5 ¦²(256_1)
//3'd6 ¦Ò(256_0)
//3'd7 ¦Ò(256_1)


module HFnc(HFncOp,DataX,DataY,DataZ,HFnc_Result);
input [2:0] HFncOp;
input [31:0] DataX;
input [31:0] DataY;
input [31:0] DataZ;
output reg [31:0]HFnc_Result;
always @( * )
   begin
      case (HFncOp)
        0: HFnc_Result= (DataX & DataY)^(~DataX & DataZ);
        1: HFnc_Result= (DataX & DataY)^(DataX & DataZ)^(DataY & DataZ);
        4: HFnc_Result= {DataX[1:0],DataX[31:2]} ^ {DataX[12:0],DataX[31:13]}^ {DataX[21:0],DataX[31:22]};
        5: HFnc_Result= {DataX[5:0],DataX[31:6]} ^ {DataX[10:0],DataX[31:11]}^ {DataX[24:0],DataX[31:25]};
        6: HFnc_Result= {DataX[6:0],DataX[31:7]} ^ {DataX[17:0],DataX[31:18]}^ (DataX>>3);
        7: HFnc_Result= {DataX[16:0],DataX[31:17]} ^ {DataX[18:0],DataX[31:19]}^ (DataX>>10);
      endcase
   end
endmodule
