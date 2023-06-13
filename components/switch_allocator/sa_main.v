/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         sa_iport.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-09
 *
 *   Description:      This is the main part of the VC allocator.
 *                     Presented in the non-grey-block zone in Fig.7.15 @ P-129.
 *
 *   Annotation:       This module is designed for traditional 2-stage arbi-
 *                     tration structures only, where all VCs from the same 
 *                     input port should first participate in a local arbitration,
 *                     and the winner VC's request is sent to the main allo-
 *                     cator on behalf of the input port.
 *                     This module is not designed for input-speedup structures
 *                     described in P-145, where all VCs from each input port
 *                     participate in the main allocation directly.
 *
*****************************************************************************/

module sa_main(
    input       wire                        clk,
    input       wire                        rstn,

    // port request signals from each input port
    input       wire        [`N-1 : 0]      reqSA_from_P0,
    input       wire        [`N-1 : 0]      reqSA_from_P1,
    input       wire        [`N-1 : 0]      reqSA_from_P2,
    input       wire        [`N-1 : 0]      reqSA_from_P3,
    input       wire        [`N-1 : 0]      reqSA_from_P4,

    // port granted indicators to each input port
    output      wire                        inputGrantSA_to_IP0,
    output      wire                        inputGrantSA_to_IP1,
    output      wire                        inputGrantSA_to_IP2,
    output      wire                        inputGrantSA_to_IP3,
    output      wire                        inputGrantSA_to_IP4,

    // selected input ports for each output port
    output      wire        [`N-1 : 0]      selInPort_for_OP0,
    output      wire        [`N-1 : 0]      selInPort_for_OP1,
    output      wire        [`N-1 : 0]      selInPort_for_OP2,
    output      wire        [`N-1 : 0]      selInPort_for_OP3,
    output      wire        [`N-1 : 0]      selInPort_for_OP4,

    //selected output ports for each input port
    output      wire        [`N-1 : 0]      selOutPort_for_IP0, 
    output      wire        [`N-1 : 0]      selOutPort_for_IP1, 
    output      wire        [`N-1 : 0]      selOutPort_for_IP2, 
    output      wire        [`N-1 : 0]      selOutPort_for_IP3, 
    output      wire        [`N-1 : 0]      selOutPort_for_IP4
);

wire    [`N-1 : 0]   arb_P0_req, arb_P0_grant;
wire    [`N-1 : 0]   arb_P1_req, arb_P1_grant;
wire    [`N-1 : 0]   arb_P2_req, arb_P2_grant;
wire    [`N-1 : 0]   arb_P3_req, arb_P3_grant;
wire    [`N-1 : 0]   arb_P4_req, arb_P4_grant;

arbiter #(`N) arb_P0(clk, rstn, arb_P0_req, arb_P0_grant);
arbiter #(`N) arb_P1(clk, rstn, arb_P1_req, arb_P1_grant);
arbiter #(`N) arb_P2(clk, rstn, arb_P2_req, arb_P2_grant);
arbiter #(`N) arb_P3(clk, rstn, arb_P3_req, arb_P3_grant);
arbiter #(`N) arb_P4(clk, rstn, arb_P4_req, arb_P4_grant);

transpose_5 pre_arbiter_cross(
    reqSA_from_P0,
    reqSA_from_P1,
    reqSA_from_P2,
    reqSA_from_P3,
    reqSA_from_P4,

    arb_P0_req,
    arb_P1_req,
    arb_P2_req,
    arb_P3_req,
    arb_P4_req,
);

transpose_5 pre_arbiter_cross(
    arb_P0_grant,
    arb_P1_grant,
    arb_P2_grant,
    arb_P3_grant,
    arb_P4_grant,

    selOutPort_for_IP0,
    selOutPort_for_IP1,
    selOutPort_for_IP2,
    selOutPort_for_IP3,
    selOutPort_for_IP4,
);

assign selInPort_for_OP0 = arb_P0_grant;
assign selInPort_for_OP1 = arb_P1_grant;
assign selInPort_for_OP2 = arb_P2_grant;
assign selInPort_for_OP3 = arb_P3_grant;
assign selInPort_for_OP4 = arb_P4_grant;

assign inputGrantSA_to_IP0 = | selOutPort_for_IP0;
assign inputGrantSA_to_IP1 = | selOutPort_for_IP1;
assign inputGrantSA_to_IP2 = | selOutPort_for_IP2;
assign inputGrantSA_to_IP3 = | selOutPort_for_IP3;
assign inputGrantSA_to_IP4 = | selOutPort_for_IP4;

endmodule