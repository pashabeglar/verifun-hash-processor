`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2018 12:47:34 PM
// Design Name: 
// Module Name: twosComp_Nbit
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


module twosComp_Nbit
        #(  //-------- Parameters --------//
            parameter N=2
        )
        
        (   //-------- Input --------//
            input [N-1:0] b,
            
            //-------- Output --------//
            output [N-1:0] tc
        );
        
    genvar gi;
    generate
    for(gi=0; gi < N; gi = gi + 1) begin: genbit
        if(gi==0) begin: ifelse
            assign tc[gi] = b[gi];
        end else if (gi==1) begin: ifelse
            assign tc[gi] = b[gi] ^ b[gi-1];
        end else if (gi==2) begin: ifelse
            wire prop_or;
            assign prop_or = b[gi-1] | b[gi-2];
            assign tc[gi] = b[gi] ^ prop_or;
        end else begin: ifelse
            wire prop_or;
            assign prop_or = b[gi-1] | genbit[gi-1].ifelse.prop_or;
            assign tc[gi] = b[gi] ^ prop_or;
        end
    end
    
    endgenerate
    
endmodule
