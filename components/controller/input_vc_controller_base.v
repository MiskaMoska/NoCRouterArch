/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         input_vc_controller_base.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-09
 *
 *   Description:      This is a basic input VC controller, which manages all
 *                     request and grant signals from routing computation unit,
 *                     VC allocator, and switch allocator.
 *                     Presented in Fig.7.11 @ P-125.
 *
 *   Annotation:       This module is designed for non-pipelined router only.
 *
*****************************************************************************/

module input_vc_controller_base(
    input       wire                        clk,
    input       wire                        rstn,

    // signals concerned with input buffer
    input       wire        [`DW-1 : 0]     data, // the data signal exposed on the output bus of the input buffer (FIFO)
    input       wire                        valid, // FIFO not empty
    
    // signals concerned with RC
    output      wire        [7 : 0]         dst,
    input       wire        [`N-1 : 0]      candidateOutPort, // must be one-hot
    input       wire        [`V-1 : 0]      candidateOutVC, // may be multi-bit asserted

    // signals concerned with VA
    output      wire        [`N-1 : 0]      reqPort,
    output      wire        [`V-1 : 0]      reqVC,
    input       wire                        VCgranted,
    input       wire        [`V-1 : 0]      selOutVC,

    // signals concerned with SA
    output      wire        [`N-1 : 0]      reqSA,
    input       wire                        inputGrantedSA, 

    // not necessary for the following 2 signals to feedback to input controller
    // they can be fed to crossbar directly from switch allocator
    // input       wire        [`V-1 : 0]      inputVCSelect,
    // input       wire        [`N-1 : 0]      outputSelect,

    // VC ready signals from all output VCs
    input       wire        [`V-1 : 0]      readyVC_from_OP0,
    input       wire        [`V-1 : 0]      readyVC_from_OP1,
    input       wire        [`V-1 : 0]      readyVC_from_OP2,
    input       wire        [`V-1 : 0]      readyVC_from_OP3,
    input       wire        [`V-1 : 0]      readyVC_from_OP4
);

reg     [`N-1 : 0]  outPort;
reg     [`V-1 : 0]  outVC;
reg                 outVCLock;
wire    [1 : 0]     flit_header;
wire    [`V-1 : 0]  _readyVC;
wire                readyVC;
wire                time_to_reqSA;

assign flit_header = data[`DW-3 : `DW-4];
assign dst = data[7 : 0];

//--------------------------------------------------------------------
//                          RC Control
//--------------------------------------------------------------------

assign data_to_rc = data;

always @(posedge clk or negedge rstn) begin
    if(~rstn) begin
        outPort <= 0;
    end else begin
        if(flit_header == `HEAD) begin
            outPort <= candidateOutPort;
        end
    end
end


//--------------------------------------------------------------------
//                          VA Control
//--------------------------------------------------------------------

always @(posedge clk or negedge rstn) begin
    if(~rstn) begin
        outVCLock <= 0;
        outVC <= 0;
    end else begin
        if(VCgranted) begin
            outVCLock <= 1;
            outVC <= selOutVC
        end else if(inputGrantedSA & (flit_header == `TAIL)) begin
            outVCLock <= 0;
            outVC <= 0; // optional
        end
    end
end

assign reqVC = (flit_header == `HEAD) & (~outVCLock) ? candidateOutPort : 0;
assign reqPort = (flit_header == `HEAD) ? candidateOutPort : outPort;


//--------------------------------------------------------------------
//                          ready VC Control
//--------------------------------------------------------------------

mux_5 #(`V) mux_readyVC_stage1(
    reqPort,
    readyVC_from_OP0,
    readyVC_from_OP1,
    readyVC_from_OP2,
    readyVC_from_OP3,
    readyVC_from_OP4,
    _readyVC
);

mux_4 #(1) mux_readyVC_stage2(
    outVCLock ? outVC : selOutVC,
    _readyVC[0],
    _readyVC[1],
    _readyVC[2],
    _readyVC[3],
    readyVC
);


//--------------------------------------------------------------------
//                          SA Control
//--------------------------------------------------------------------

assign time_to_reqSA = (VCgranted | outVCLock) & valid & readyVC;

demux_5 #(1) demux_for_reqSA(
    reqPort,
    time_to_reqSA,
    reqSA[0],
    reqSA[1],
    reqSA[2],
    reqSA[3],
    reqSA[4]
);


endmodule