`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2018 05:19:37 PM
// Design Name: 
// Module Name: BarrelShifter_Nbit
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


module BarrelShifter_Nbit
        #(  //-------- Parameters --------//
            parameter N=4,
            parameter LVL=2,                // usually log2(N)
            parameter TYPE=2'b11,           // 00->ROTATE, 10->L_SHIFT, 01->R_SHIFT, 11->LR_SHIFT
            parameter ARITH=1'b0            // 1'b0 -> logicalshift, 1'b1 -> arithmetic shift
        )
        
        (   //-------- Input --------//
            input [N-1:0] b,
            input [DIR_SEL+LVL-1:0]shiftSel,//if TYPE==ROTATE or TYPE==LR_SHIFT, MSB selects direction
                                            // shiftSel[LVL]==1'b0 -> Rotate/Shift Rigtht
                                            // shiftSel[LVL]==1'b1 -> Rotate/Shift Left
            
            //-------- Output --------//
            output [N-1:0] s
        );
    
    //-------- local variables --------//
    localparam ROTATE = 2'b00;
    localparam L_SHIFT = 2'b10;
    localparam R_SHIFT = 2'b01;
    localparam LR_SHIFT = 2'b11;
    localparam DIR_SEL = ( (TYPE==ROTATE)||(TYPE==LR_SHIFT) ) ? 1 : 0;
    
    
    //-------- Generate Twos complement for Rotating Right or Left --------//
    generate
    if(TYPE==ROTATE) begin: gentc
        wire [LVL-1:0] shiftSelMux_out;
        wire [LVL-1:0] tc_out;
        twosComp_Nbit #(LVL)
            tc_Nbit
                (
                    .b(shiftSel[LVL-1:0]), //input
                    .tc(tc_out)
                );
                
        //shiftSel Multiplexor
        assign shiftSelMux_out = (shiftSel[LVL]) ? tc_out : shiftSel[LVL-1:0];
    end
    endgenerate
    
    
    genvar gi; //level counter
    genvar gk; //mux counter
    //-------- Generate layers of Multiplexors for Shifting --------//
    generate
    for(gi=0; gi < LVL; gi = gi + 1) begin: genlvl
        for(gk=0; gk < N; gk = gk + 1) begin: genmux
            
            //-------- ROTATE (based on Right Rotate, Left Rotate done by two's compl of shiftSel) --------//
            if(TYPE==ROTATE)begin: genrotate
                wire out, in, inShift;
                assign out = (gentc.shiftSelMux_out[gi]) ? inShift : in;
                
                //first level's input connected to input b
                if(gi==0) begin
                    assign in = b[gk];
                    //(1<<gi)-> # of bits shifted
                    if(gk + (1<<gi) > N - 1)               
                        assign inShift = b[gk+(1<<gi)-N];
                    else
                        assign inShift = b[gk+(1<<gi)];
                        
                //subsequent level's input connected
                //to previous mux's output
                end else begin
                    assign in = genlvl[gi-1].genmux[gk].genrotate.out;
                    if(gk + (1<<gi) > N - 1)
                        assign inShift = genlvl[gi-1].genmux[gk+(1<<gi)-N].genrotate.out;
                    else
                        assign inShift = genlvl[gi-1].genmux[gk+(1<<gi)].genrotate.out;
                end
            end//ifelse_genrotate
            
            
            //-------- RIGHT SHIFT (Instantiated when TYPE is R_SHIFT or LR_SHIFT) --------//
            if(TYPE[0]) begin: genRshft
                wire arithBit;
                wire out, in, inShift;
                assign out = (shiftSel[gi]) ? inShift : in;
                
                //first level's input connected to input b
                if(gi==0) begin
                    assign in = b[gk];
                    //(1<<gi)-> # of bits shifted
                    if(gk + (1<<gi) > N - 1) begin 
                        //******** when testing parameters for conditional generate, ********//
                        //******** use:         if(ARITH == 1'b1)                    ********//
                        //******** instead of:  if(ARITH)                            ********//
                        //******** the latter gave high Impedance (Z) for inShift    ********//
                        if(ARITH == 1'b1) 
                            assign inShift = b[N-1];
                        else
                            assign inShift = 1'b0;                                //shift in zero
                    end else begin
                        assign inShift = b[gk+(1<<gi)];
                    end
                    
                //subsequent level's input connected
                //to previous mux's output
                end else begin
                    assign in = genlvl[gi-1].genmux[gk].genRshft.out;
                    if(gk + (1<<gi) > N - 1) begin    
                        if(ARITH==1'b1)           
                            assign inShift = b[N-1];//genlvl[gi-1].genmux[N-1].genRshft.out;
                        else
                            assign inShift = 1'b0;
                    end else begin
                        assign inShift = genlvl[gi-1].genmux[gk+(1<<gi)].genRshft.out;
                    end
                end
            end//ifelse_genRshft
            //---------------------------------------------------------------------------//
   

            //-------- LEFT SHIFT (Instantiated when TYPE is L_SHIFT or LR_SHIFT) --------//
            if(TYPE[1]) begin: genLshft
                wire out, in, inShift;
                assign out = (shiftSel[gi]) ? inShift : in;
                
                //first level's input connected to input b
                if(gi==0) begin
                    assign in = b[gk];
                    //(1<<gi)-> # of bits shifted
                    if(gk - (1<<gi) < 0)              
                        assign inShift = 1'b0;
                    else
                        assign inShift = b[gk-(1<<gi)];
                        
                //subsequent level's input connected
                //to previous mux's output
                end else begin
                    assign in = genlvl[gi-1].genmux[gk].genLshft.out;
                    if(gk - (1<<gi) < 0)               
                        assign inShift = 1'b0;
                    else
                        assign inShift = genlvl[gi-1].genmux[gk-(1<<gi)].genLshft.out;
                end
            end//ifelse_genLshft
            //---------------------------------------------------------------------------//
            
            
        end//for_gk
    end//for_gi
    endgenerate
    
    
    
    
    //-------- Assign output s to the output of last level of mux --------//
    generate
    for(gk=0; gk < N; gk = gk + 1)begin: genout
        if(TYPE==ROTATE)
            assign s[gk] = genlvl[LVL-1].genmux[gk].genrotate.out;
        else if (TYPE==R_SHIFT)
            assign s[gk] = genlvl[LVL-1].genmux[gk].genRshft.out;
        else if (TYPE==L_SHIFT)
            assign s[gk] = genlvl[LVL-1].genmux[gk].genLshft.out;
        else begin//TYPE==LR_SHIFT
            assign s[gk] = (shiftSel[LVL]) ? genlvl[LVL-1].genmux[gk].genLshft.out :
                                             genlvl[LVL-1].genmux[gk].genRshft.out;
        end
    end
    endgenerate
    
    
endmodule
