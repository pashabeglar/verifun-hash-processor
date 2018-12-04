`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2018 07:32:55 AM
// Design Name: 
// Module Name: hashcpu
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


module hashcpu(clk, reset);
    //-------- Input --------//
    input clk;
    input reset;

    //-------- Internal Variables --------//
    
    //**** IF stage wires ****//
    wire [31:0] IF_MuxPc;
    wire [31:0] IF_pc;
    wire [31:0] IF_pc_4;
    wire [31:0] IF_instr;
    
    //**** IF/ID pipeline register wires ****//
    wire [31:0] if_id_instr;
    wire [5:0]  if_id_opcode;
    wire [4:0]  if_id_RegisterRs; // R-type, I-type
    wire [4:0]  if_id_RegisterRt; // R-type, I-type
    wire [4:0]  if_id_RegisterRd; // R-type
    wire [4:0]  if_id_shamt;      // R-type
    wire [5:0]  if_id_func;       // R-type and H-type
    wire [15:0] if_id_imm;        // I-type
    wire [25:0] if_id_jumpAddr26; // J-type
    wire [4:0]  if_id_RegisterRu; // H-type
    
    assign if_id_opcode     = if_id_instr[31:26];
    assign if_id_RegisterRs = if_id_instr[25:21];
    assign if_id_RegisterRt = if_id_instr[20:16];
    assign if_id_RegisterRd = if_id_instr[15:11];
    assign if_id_shamt      = if_id_instr[10:6];
    assign if_id_func       = if_id_instr[5:0];
    assign if_id_imm        = if_id_instr[15:0];
    assign if_id_jumpAddr26 = if_id_instr[25:0];
    assign if_id_RegisterRu = if_id_instr[10:6];

    wire [31:0] if_id_del1_pc_4;
    wire [31:0] if_id_del2_pc_4;
    wire [31:0] if_id_pc_4;
    
    //**** ID stage wires ****//
    wire [31:0] ID_shiftLeft2;
    wire [31:0] ID_signtExt;
    wire [31:0] ID_add;
    wire [27:0] ID_jumpAddr28;
    wire [31:0] ID_jumpAddr32;
    wire [31:0] ID_RdData1;
    wire [31:0] ID_RdData2;
    wire [31:0] ID_RdData3;
    
    wire [1:0]  ID_FwdSelCmpA;
    wire [1:0]  ID_FwdSelCmpB;
    wire [31:0] ID_FwdMuxCmpA;
    wire [31:0] ID_FwdMuxCmpB;
    wire [31:0] ID_Cmp;    
                            
    //**** ID/EX pipeline register wires ****//
    wire [31:0] id_ex_if_instr;
    wire [5:0]  id_ex_opcode;
    wire [4:0]  id_ex_RegisterRs; // R-type, I-type
    wire [4:0]  id_ex_RegisterRt; // R-type, I-type
    wire [4:0]  id_ex_RegisterRd; // R-type
    wire [4:0]  id_ex_shamt;      // R-type
    wire [5:0]  id_ex_func;       // R-type and H-type
    wire [15:0] id_ex_imm;        // I-type
    wire [25:0] id_ex_jumpAddr26; // J-type
    wire [4:0]  id_ex_RegisterRu; // H-type
    
    wire [31:0] id_ex_RdData1;
    wire [31:0] id_ex_RdData2;
    wire [31:0] id_ex_RdData3;
    wire [31:0] id_ex_signExt;
    
    //**** EX stage wires ****//
    wire [1:0]  EX_FwdSelAluA;
    wire [1:0]  EX_FwdSelAluB;
    wire [31:0] EX_FwdMuxAluA;
    wire [31:0] EX_FwdMuxAluB;
    wire [31:0] EX_MuxAluSrcB;
    wire [31:0] EX_BarrelShifter;
    wire [31:0] EX_ALUResult;
    wire        EX_ALUZero;
    
    wire [1:0]  EX_FwdSelHFncA;
    wire [1:0]  EX_FwdSelHFncB;
    wire [1:0]  EX_FwdSelHFncC;
    wire [31:0] EX_FwdMuxHFncA;
    wire [31:0] EX_FwdMuxHFncB;
    wire [31:0] EX_FwdMuxHFncC;
    wire [31:0] EX_HFncResult;
    
    wire [31:0] EX_MuxResult;
    wire [4:0]  EX_MuxRegWrAddr;
    
    //**** EX/MEM pipeline register wires ****//
    wire [31:0] ex_mem_if_instr;
    wire [5:0]  ex_mem_opcode;
    wire [4:0]  ex_mem_RegisterRs; // R-type, I-type
    wire [4:0]  ex_mem_RegisterRt; // R-type, I-type
    wire [4:0]  ex_mem_RegisterRd; // R-type
    wire [4:0]  ex_mem_shamt;      // R-type
    wire [5:0]  ex_mem_func;       // R-type and H-type
    wire [15:0] ex_mem_imm;        // I-type
    wire [25:0] ex_mem_jumpAddr26; // J-type
    wire [4:0]  ex_mem_RegisterRu; // H-type
    
    wire [31:0] ex_mem_Result;
    wire [31:0] ex_mem_RdData2;
    wire [4:0]  ex_mem_RegWrAddr;
    
    //**** MEM stage wires ****//
    wire [31:0] EX_MemRdData;
    
    //**** MEM/WB pipeline register wires ****//
    wire [31:0] mem_wb_if_instr;
    wire [5:0]  mem_wb_opcode;
    wire [4:0]  mem_wb_RegisterRs; // R-type, I-type
    wire [4:0]  mem_wb_RegisterRt; // R-type, I-type
    wire [4:0]  mem_wb_RegisterRd; // R-type
    wire [4:0]  mem_wb_shamt;      // R-type
    wire [5:0]  mem_wb_func;       // R-type and H-type
    wire [15:0] mem_wb_imm;        // I-type
    wire [25:0] mem_wb_jumpAddr26; // J-type
    wire [4:0]  mem_wb_RegisterRu; // H-type
    
    wire [31:0] mem_wb_del1_Result;
    wire [31:0] mem_wb_del2_Result;
    wire [31:0] mem_wb_Result;
    
    wire [4:0]  mem_wb_del1_RegWrAddr;
    wire [4:0]  mem_wb_del2_RegWrAddr;
    wire [4:0]  mem_wb_RegWrAddr;
    
    wire [31:0] mem_wb_MemRdData;
    
    //**** WB stage wires ****//
    
    wire [31:0] WB_MuxRegWrData;
   
    //-------- Instantiate --------//

    //**** IF stage ****//
    Mux_4to1_Nbit 
        PC_Mux(
            .DataIn0    (IF_pc_4),
            .DataIn1    (ID_add), 
            .DataIn2    (ID_jumpAddr32), 
            .DataIn3    (),             //Nothing is connected to DataIn3 
            .Sel        (),             //Need control select wire
            .DataOut    (IF_MuxPc)); 
            
    Register_Nbit #(.N (32)) 
        pc(
            .clk       (clk), 
            .rst       (),          //Need reset wire
            .en        (),          //Need control en wire
            .DataIn    (IF_MuxPc), 
            .DataOut   (IF_pc));    
                        
    Add 
        add_pc_4(
            .DataIn0 (IF_pc), 
            .DataIn1 (32'd4), 
            .DataOut (IF_pc_4));
            
    InstructionMem IM();    //NEED TO ADD (Block memory, dont have module name)
    
    //**** IF/ID pipeline register stage ****//
    Register_Nbit #(.N (32)) 
        INST_if_id_del1_pc_4(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (IF_pc_4), 
            .DataOut (if_id_del1_pc_4)),   
            
        INST_if_id_del2_pc_4(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (if_id_del1_pc_4), 
            .DataOut (if_id_del2_pc_4)),   
            
        INST_if_id_pc_4(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (if_id_del2_pc_4), 
            .DataOut (if_id_pc_4)), 
            
        INST_if_id_instr(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (),            //Need output from Instruction Memory
            .DataOut (if_id_instr)); 
    
    //**** ID stage ****//
    ShiftLeft2_26to28 
        INST_ShiftLeft2_26to28(
            .DataIn (if_id_jumpAddr26), 
            .DataOut(ID_jumpAddr28));
        
    assign ID_jumpAddr32 = {if_id_pc_4[31:28], ID_jumpAddr28}; //Concatenate
    
    ShiftLeft2_32to32 
        INST_ShiftLeft2_32to32(
            .DataIn (ID_signtExt), 
            .DataOut(ID_shiftLeft2));
            
    SignedExtend
        INST_SignedExtend(
            .DataIn (if_id_imm), 
            .DataOut(ID_signtExt));
    
    Add 
        add_branchAddr(
            .DataIn0(if_id_pc_4), 
            .DataIn1(ID_shiftLeft2), 
            .DataOut(ID_add));
            
    RegisterFile 
        INST_RegisterFile(
            .clk        (clk),    
            .RegWrite   (),                 //Need control RegWrite wire
            .rd_addr1   (if_id_RegisterRs),
            .rd_addr2   (if_id_RegisterRt),
            .rd_addr3   (if_id_RegisterRu),
            .wr_addr    (),                 //I think need to attach something from WB
            .wr_data    (WB_MuxRegWrData),  //I believe this is the correct wire?
            .rd_data1   (ID_RdData1),
            .rd_data2   (ID_RdData2),
            .rd_data3   (ID_RdData3));
    
    FwdUnitCmp 
        INST_FwdUnitCmp(
            .ex_mem_RegWrite    (), // Need ex_mem_RegWire
            .ex_mem_RegisterRd  (), 
            .mem_wb_RegWrite    (),
            .mem_wb_RegisterRd  (),
            .if_id_RegisterRs   (if_id_RegisterRs), //Assumption
            .if_id_RegisterRt   (if_id_RegisterRt), //Assumption
            .ForwardA           (ID_FwdSelCmpA),
            .ForwardB           (ID_FwdSelCmpB));
    
    Mux_4to1_Nbit
        INST_FwdMuxCmpA(
            .DataIn0    (ID_RdData1), 
            .DataIn1    (),             //?
            .DataIn2    (),             //?
            .DataIn3    (),             //Nothing is connected to DataIn3 
            .Sel        (ID_FwdSelCmpA), 
            .DataOut    (ID_FwdMuxCmpA)),
            
        INST_FwdMuxCmpB(
            .DataIn0    (ID_RdData2), 
            .DataIn1    (),             //?
            .DataIn2    (),             //?
            .DataIn3    (),             //Nothing is connected to DataIn3 
            .Sel        (ID_FwdSelCmpB), 
            .DataOut    (ID_FwdMuxCmpB));
            
    Cmp_Nbit
        INST_Cmp(
            .DataIn0    (ID_FwdMuxCmpA), 
            .DataIn1    (ID_FwdMuxCmpB), 
            .Op         (ID_Cmp));
    
    //**** ID/EX pipeline register stage ****//
        
endmodule
