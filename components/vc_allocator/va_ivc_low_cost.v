/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         va_ivc_low_cost.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-08
 *
 *   Description:      This is the input VC stage of the VC allocator.
 *                     Described in the grey block in Fig.7.13 @ P-127.
 *
 *   Annotation:       This local arbitration step is for cases where one 
 *                     input VC may request multiple output VCs, if you can 
 *                     ensure that one input VC only request one output VC 
 *                     once, it means that the masked VC request signals are
 *                     natural one-hot codes, then this step can be omitted. 
 *                     If the masked VC request signals are not one-hot codes 
 *                     and you don't want local arbitration, then you can use 
 *                     a wave-front allocator to replace the multi-arbiter-
 *                     combined main allocator.
 *
*****************************************************************************/

module va_ivc_low_cost(
    input       wire                        clk,
    input       wire                        rstn,

    // input port and VC request
    input       wire        [`N-1 : 0]      reqPort,
    input       wire        [`V-1 : 0]      reqVC,

    // output VC availability indicators
    input       wire        [`V-1 : 0]      outVCAvailable_P0,
    input       wire        [`V-1 : 0]      outVCAvailable_P1,
    input       wire        [`V-1 : 0]      outVCAvailable_P2,
    input       wire        [`V-1 : 0]      outVCAvailable_P3,
    input       wire        [`V-1 : 0]      outVCAvailable_P4,

    // input and output granted signal
    input       wire                        VCgrantedIn,
    output      wire                        VCgranted,

    // output selected out VCs
    output      wire        [`V-1 : 0]      selOutVC,

    // output VC request signal to the main allocator
    output      wire        [`N*`V-1 : 0]   reqVCOut
);

wire    [`V-1 : 0]  muxed_outVCAvailable;
wire    [`V-1 : 0]  masked_reqVC;
wire    [`V-1 : 0]  reqVCOut_to_P0;
wire    [`V-1 : 0]  reqVCOut_to_P1;
wire    [`V-1 : 0]  reqVCOut_to_P2;
wire    [`V-1 : 0]  reqVCOut_to_P3;
wire    [`V-1 : 0]  reqVCOut_to_P4;

assign VCgranted = VCgrantedIn;

mux_5 #(`V) out_avail_mux(
    reqPort,
    outVCAvailable_P0,
    outVCAvailable_P1,
    outVCAvailable_P2,
    outVCAvailable_P3,
    outVCAvailable_P4,
    muxed_outVCAvailable
);

assign masked_reqVC = reqVC & muxed_outVCAvailable;

arbiter #(`V) local_arb(
    clk, rstn, masked_reqVC, selOutVC
);

demux_5 #(`V) req_out_demux(
    reqPort,
    selOutVC,
    reqVCOut_to_P0,
    reqVCOut_to_P1,
    reqVCOut_to_P2,
    reqVCOut_to_P3,
    reqVCOut_to_P4
);

// the reqVCOut is organized follows:
// reqVCOut[i*`V+j] = req to port-i VC-j
assign reqVCOut = {
    reqVCOut_to_P4,
    reqVCOut_to_P3,
    reqVCOut_to_P2,
    reqVCOut_to_P1,
    reqVCOut_to_P0
};

endmodule