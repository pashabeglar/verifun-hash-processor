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
    wire [4:0]  EX_shamtSrc;
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
    
    wire [31:0] mem_wb_del1_instr;
    wire [31:0] mem_wb_del2_instr;
    
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
            
    InstructionMem 
        IM(
            .clk    (clk), 
            .addr   (IF_pc), 
            .instr  (IF_instr));    //NEED TO ADD (Block memory, dont have module name)
    
    //**** IF/ID pipeline register stage ****//
    Register_Nbit #(.N (32)) 
        INST_if_id_del1_pc_4(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (IF_pc_4), 
            .DataOut (if_id_del1_pc_4)),     
            
        INST_if_id_pc_4(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (if_id_del1_pc_4), 
            .DataOut (if_id_pc_4)), 
            
        INST_if_id_instr(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (IF_instr),   
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
    Register_Nbit #(.N (2)) 
        id_ex_EXctrl(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (), 
            .DataOut ()),           // ?   
            
        id_ex_MEMctrl(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (), 
            .DataOut ()),           // ? 
        
        id_ex_WBctrl(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (), 
            .DataOut ());           // ? 
            
    Register_Nbit
        INST_id_ex_RdData1(
            .clk    (clk), 
            .rst    (),                 //Need reset wire
            .en     (),                 //Need control en wire
            .DataIn (ID_RdData1), 
            .DataOut(id_ex_RdData1)),
            
        INST_id_ex_RdData2(
            .clk    (clk), 
            .rst    (),                 //Need reset wire
            .en     (),                 //Need control en wire
            .DataIn (ID_RdData2), 
            .DataOut(id_ex_RdData2)),
        
        INST_id_ex_RdData3(
            .clk    (clk), 
            .rst    (),                 //Need reset wire
            .en     (),                 //Need control en wire
            .DataIn (ID_RdData3), 
            .DataOut(id_ex_RdData3)),
            
        INST_id_ex_signExt(
            .clk    (clk), 
            .rst    (),                 //Need reset wire
            .en     (),                 //Need control en wire
            .DataIn (ID_signtExt), 
            .DataOut(id_ex_signExt)),
            
        INST_id_ex_instr(
            .clk    (clk), 
            .rst    (),                 //Need reset wire
            .en     (),                 //Need control en wire
            .DataIn (if_id_instr), 
            .DataOut(id_ex_if_instr));
                                
    //**** EX stage ****//
    Mux_4to1_Nbit
        INST_FwdMuxAluA(
            .DataIn0    (id_ex_RdData1), 
            .DataIn1    (),             //?
            .DataIn2    (),             //?
            .DataIn3    (),             //Nothing is connected to DataIn3 
            .Sel        (EX_FwdSelAluA), 
            .DataOut    (EX_FwdMuxAluA)),
           
        INST_FwdMuxAluB(
            .DataIn0    (id_ex_RdData2), 
            .DataIn1    (),             //?
            .DataIn2    (),             //?
            .DataIn3    (),             //Nothing is connected to DataIn3 
            .Sel        (EX_FwdSelAluB), 
            .DataOut    (EX_FwdMuxAluB)),
            
        INST_FwdMuxHfncA(
            .DataIn0    (),             //?
            .DataIn1    (),             //?
            .DataIn2    (),             //?
            .DataIn3    (),             //Nothing is connected to DataIn3 
            .Sel        (EX_FwdSelHFncA), 
            .DataOut    (EX_FwdMuxHFncA)),
            
        INST_FwdMuxHfncB(
            .DataIn0    (),             //?
            .DataIn1    (),             //?
            .DataIn2    (),             //?
            .DataIn3    (),             //Nothing is connected to DataIn3 
            .Sel        (EX_FwdSelHFncB), 
            .DataOut    (EX_FwdMuxHFncB)),
        
        INST_FwdMuxHfncC(
            .DataIn0    (),             //?
            .DataIn1    (),             //?
            .DataIn2    (),             //?
            .DataIn3    (),             //Nothing is connected to DataIn3 
            .Sel        (EX_FwdSelHFncC), 
            .DataOut    (EX_FwdMuxHFncC));
            
    Mux_4to1_Nbit #(.N (5))
        INST_MuxShamtSrc(
            .DataIn0    (id_ex_shamt),  
            .DataIn1    (5'd0),             
            .DataIn2    (5'd0),             
            .DataIn3    (),             //Nothing is connected to DataIn3 
            .Sel        (),             //Need control select wire
            .DataOut    (EX_shamtSrc));
            
    Mux_2to1_Nbit
        INST_MuxRegWrAddr(
            .DataIn0    (id_ex_RegisterRt),  
            .DataIn1    (id_ex_RegisterRd),             
            .Sel        (),                 //Need control select wire
            .DataOut    (EX_MuxRegWrAddr)),
            
        INST_MuxALUSrcB(
            .DataIn0    (EX_FwdMuxAluB),  
            .DataIn1    (id_ex_signExt),             
            .Sel        (),                 //Need control select wire
            .DataOut    (EX_MuxAluSrcB)),
            
        INST_MuxResult(
            .DataIn0    (EX_ALUResult),  
            .DataIn1    (EX_HFncResult),             
            .Sel        (),                 //Need control select wire
            .DataOut    (EX_MuxResult));
    
    FwdUnitHFnc
        INST_FwdUnitHFnc(
            .ex_mem_RegWrite    (), //?
            .ex_mem_RegisterRd  (), //?
            .mem_wb_RegWrite    (), //?
            .mem_wb_RegisterRd  (), //?
            .id_ex_RegisterRs   (), //?
            .id_ex_RegisterRt   (), //?
            .id_ex_RegisterRu   (), //?
            .ForwardA           (EX_FwdSelHFncA), 
            .ForwardB           (EX_FwdSelHFncB),
            .ForwardC           (EX_FwdSelHFncC));
            
    HFnc
        INST_HFnc(
            .HFncOp         (),                 //Need control HFncOp wire
            .DataX          (EX_FwdMuxHFncA),
            .DataY          (EX_FwdMuxHFncB),
            .DataZ          (EX_FwdMuxHFncC),
            .HFnc_Result    (EX_HFncResult));
            
    BarrelShifter_Nbit # (  //NEED TO CREATE MODULE
        .N      (32),
        .LVL    (5),
        .TYPE   (2'b10),
        .ARITH  (1'b0))
        
        INST_BarrelShifter(
            .DataIn     (EX_MuxAluSrcB),  
            .Sel        (EX_shamtSrc),             
            .DataOut    (EX_BarrelShifter));
                                
    FwdUnitAlu
        INST_FwdUnitAlu(
            .ex_mem_RegWrite    (), //?
            .ex_mem_RegisterRd  (), //?
            .mem_wb_RegWrite    (), //?
            .mem_wb_RegisterRd  (), //?
            .id_ex_RegisterRs   (), //?
            .id_ex_RegisterRt   (), //?
            .ForwardA           (EX_FwdSelAluA),
            .ForwardB           (EX_FwdSelAluB));
    
    Alu
        INST_Alu(
            .Sel        (),     //Need control select wire
            .DataIn1    (EX_FwdMuxAluA), 
            .DataIn2    (EX_BarrelShifter), 
            .Result     (EX_ALUResult), 
            .Zero       (EX_ALUZero));

    //**** EX/MEM pipeline register stage ****//
    Register_Nbit #(.N (2)) 
        ex_mem_MEMctrl(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (), 
            .DataOut ()),           // ?   
            
        INST_ex_mem_WBctrl(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (), 
            .DataOut ());           // ? 
    
    Register_Nbit #(.N (32)) 
        INST_ex_mem_Result(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (EX_MuxResult), 
            .DataOut ()),           // ?   
            
        INST_ex_mem_RdData2(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (id_ex_RdData2), 
            .DataOut ()),           // ? 
            
        INST_ex_mem_RegWrAddr(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (EX_MuxRegWrAddr), 
            .DataOut (ex_mem_RegWrAddr)),   // ?           
    
        INST_ex_mem_instr(
                .clk     (clk), 
                .rst     (),            //Need reset wire
                .en      (),            //Need control en wire
                .DataIn  (id_ex_if_instr), 
                .DataOut ());           // ?  

    //**** MEM stage ****//
    DataMem
        DM(
            .clk    (clk), 
            .WrMem  (), 
            .RdMem  (), 
            .WrData (), 
            .addr   (), 
            .RdData (EX_MemRdData));   //NEED TO ADD (Block memory, dont have module name)
    
    //**** MEM/WB pipeline register stage ****//
    Register_Nbit #(.N (2)) 
        mem_wb_del1_WBctrl(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (), 
            .DataOut ()),           // ?   
            
        mem_wb_del2_WBctrl(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (), 
            .DataOut ()),           // ?     
        
        mem_wb_WBctrl(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (), 
            .DataOut ());           // ? 
    
    Register_Nbit #(.N (32)) 
        INST_mem_wb_del1_Result(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (), 
            .DataOut ()),           // ?   
            
        INST_mem_wb_del1_RegWrAddr(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (), 
            .DataOut ()),   // ?           
    
        INST_mem_wb_del1_instr(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (), 
            .DataOut ()),           // ?  
    
        INST_mem_wb_del2_Result(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (), 
            .DataOut ()),           // ?   
            
        INST_mem_wb_del2_RegWrAddr(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (), 
            .DataOut ()),   // ?           
    
        INST_mem_wb_del2_instr(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (), 
            .DataOut ()),           // ?
            
        INST_mem_wb_Result(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (), 
            .DataOut ()),           // ?   
            
        INST_mem_wb_RegWrAddr(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (), 
            .DataOut ()),   // ?           
    
        INST_mem_wb_instr(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (), 
            .DataOut ()),           // ?    //**** WB stage wires ****//
            
        INST_mem_wb_MemRdData(
            .clk     (clk), 
            .rst     (),            //Need reset wire
            .en      (),            //Need control en wire
            .DataIn  (EX_MemRdData), 
            .DataOut ());           // ?    //**** WB stage wires ****//
      
    //**** WB stage ****//
    Mux_2to1_Nbit
        INST_MuxRegWrData(
            .DataIn0    (mem_wb_Result),    //Create wires
            .DataIn1    (mem_wb_MemRdData), //Create wires            
            .Sel        (mem_wb_MemToReg),  //Create wires
            .DataOut    (WB_MuxRegWrData)); //Create wires

endmodule
