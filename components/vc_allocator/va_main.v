/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         va_main.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-08
 *
 *   Description:      This is the main part of the VC allocator.
 *                     Described in the non-grey-block zone in Fig.7.13 
 *                     @ P-127.
 *
 *   Annotation:       This is an allocator that combines multiple arbiters
 *                     together, each arbiter executes independently, so the
 *                     arbitration results are distributed, which means multiple
 *                     request bits from the same input can be granted 
 *                     simultaneously by different outputs, implying an illegal 
 *                     allocation pattern (except for synchronous multicast).
 *                     As a consequence, this allocator cannot handle cases
 *                     where one input may request multiple outputs. In other 
 *                     words, the input VC request signals must be one-hots. 
 *
*****************************************************************************/

module va_main(
    input       wire                        clk,
    input       wire                        rstn,

    // input VC request
    input       wire        [`N*`V-1 : 0]   reqVC_from_P0_VC0,
    input       wire        [`N*`V-1 : 0]   reqVC_from_P0_VC1,
    input       wire        [`N*`V-1 : 0]   reqVC_from_P0_VC2,
    input       wire        [`N*`V-1 : 0]   reqVC_from_P0_VC3,

    input       wire        [`N*`V-1 : 0]   reqVC_from_P1_VC0,
    input       wire        [`N*`V-1 : 0]   reqVC_from_P1_VC1,
    input       wire        [`N*`V-1 : 0]   reqVC_from_P1_VC2,
    input       wire        [`N*`V-1 : 0]   reqVC_from_P1_VC3,

    input       wire        [`N*`V-1 : 0]   reqVC_from_P2_VC0,
    input       wire        [`N*`V-1 : 0]   reqVC_from_P2_VC1,
    input       wire        [`N*`V-1 : 0]   reqVC_from_P2_VC2,
    input       wire        [`N*`V-1 : 0]   reqVC_from_P2_VC3,

    input       wire        [`N*`V-1 : 0]   reqVC_from_P3_VC0,
    input       wire        [`N*`V-1 : 0]   reqVC_from_P3_VC1,
    input       wire        [`N*`V-1 : 0]   reqVC_from_P3_VC2,
    input       wire        [`N*`V-1 : 0]   reqVC_from_P3_VC3,

    input       wire        [`N*`V-1 : 0]   reqVC_from_P4_VC0,
    input       wire        [`N*`V-1 : 0]   reqVC_from_P4_VC1,
    input       wire        [`N*`V-1 : 0]   reqVC_from_P4_VC2,
    input       wire        [`N*`V-1 : 0]   reqVC_from_P4_VC3,

    // output VC granted
    output      wire                        VCgranted_to_P0_VC0,
    output      wire                        VCgranted_to_P0_VC1,
    output      wire                        VCgranted_to_P0_VC2,
    output      wire                        VCgranted_to_P0_VC3,

    output      wire                        VCgranted_to_P1_VC0,
    output      wire                        VCgranted_to_P1_VC1,
    output      wire                        VCgranted_to_P1_VC2,
    output      wire                        VCgranted_to_P1_VC3,

    output      wire                        VCgranted_to_P2_VC0,
    output      wire                        VCgranted_to_P2_VC1,
    output      wire                        VCgranted_to_P2_VC2,
    output      wire                        VCgranted_to_P2_VC3,

    output      wire                        VCgranted_to_P3_VC0,
    output      wire                        VCgranted_to_P3_VC1,
    output      wire                        VCgranted_to_P3_VC2,
    output      wire                        VCgranted_to_P3_VC3,

    output      wire                        VCgranted_to_P4_VC0,
    output      wire                        VCgranted_to_P4_VC1,
    output      wire                        VCgranted_to_P4_VC2,
    output      wire                        VCgranted_to_P4_VC3
);

wire    [`N*`V-1 : 0]   arb_P0_VC0_req, arb_P0_VC0_grant;
wire    [`N*`V-1 : 0]   arb_P0_VC1_req, arb_P0_VC1_grant;
wire    [`N*`V-1 : 0]   arb_P0_VC2_req, arb_P0_VC2_grant;
wire    [`N*`V-1 : 0]   arb_P0_VC3_req, arb_P0_VC3_grant;
wire    [`N*`V-1 : 0]   arb_P1_VC0_req, arb_P1_VC0_grant;
wire    [`N*`V-1 : 0]   arb_P1_VC1_req, arb_P1_VC1_grant;
wire    [`N*`V-1 : 0]   arb_P1_VC2_req, arb_P1_VC2_grant;
wire    [`N*`V-1 : 0]   arb_P1_VC3_req, arb_P1_VC3_grant;
wire    [`N*`V-1 : 0]   arb_P2_VC0_req, arb_P2_VC0_grant;
wire    [`N*`V-1 : 0]   arb_P2_VC1_req, arb_P2_VC1_grant;
wire    [`N*`V-1 : 0]   arb_P2_VC2_req, arb_P2_VC2_grant;
wire    [`N*`V-1 : 0]   arb_P2_VC3_req, arb_P2_VC3_grant;
wire    [`N*`V-1 : 0]   arb_P3_VC0_req, arb_P3_VC0_grant;
wire    [`N*`V-1 : 0]   arb_P3_VC1_req, arb_P3_VC1_grant;
wire    [`N*`V-1 : 0]   arb_P3_VC2_req, arb_P3_VC2_grant;
wire    [`N*`V-1 : 0]   arb_P3_VC3_req, arb_P3_VC3_grant;
wire    [`N*`V-1 : 0]   arb_P4_VC0_req, arb_P4_VC0_grant;
wire    [`N*`V-1 : 0]   arb_P4_VC1_req, arb_P4_VC1_grant;
wire    [`N*`V-1 : 0]   arb_P4_VC2_req, arb_P4_VC2_grant;
wire    [`N*`V-1 : 0]   arb_P4_VC3_req, arb_P4_VC3_grant;

wire    [`N*`V-1 : 0]   grantVC_for_P0_VC0;
wire    [`N*`V-1 : 0]   grantVC_for_P0_VC1;
wire    [`N*`V-1 : 0]   grantVC_for_P0_VC2;
wire    [`N*`V-1 : 0]   grantVC_for_P0_VC3;
wire    [`N*`V-1 : 0]   grantVC_for_P1_VC0;
wire    [`N*`V-1 : 0]   grantVC_for_P1_VC1;
wire    [`N*`V-1 : 0]   grantVC_for_P1_VC2;
wire    [`N*`V-1 : 0]   grantVC_for_P1_VC3;
wire    [`N*`V-1 : 0]   grantVC_for_P2_VC0;
wire    [`N*`V-1 : 0]   grantVC_for_P2_VC1;
wire    [`N*`V-1 : 0]   grantVC_for_P2_VC2;
wire    [`N*`V-1 : 0]   grantVC_for_P2_VC3;
wire    [`N*`V-1 : 0]   grantVC_for_P3_VC0;
wire    [`N*`V-1 : 0]   grantVC_for_P3_VC1;
wire    [`N*`V-1 : 0]   grantVC_for_P3_VC2;
wire    [`N*`V-1 : 0]   grantVC_for_P3_VC3;
wire    [`N*`V-1 : 0]   grantVC_for_P4_VC0;
wire    [`N*`V-1 : 0]   grantVC_for_P4_VC1;
wire    [`N*`V-1 : 0]   grantVC_for_P4_VC2;
wire    [`N*`V-1 : 0]   grantVC_for_P4_VC3;

arbiter #(`N*`V) arb_P0_VC0(clk, rstn, arb_P0_VC0_req, arb_P0_VC0_grant);
arbiter #(`N*`V) arb_P0_VC1(clk, rstn, arb_P0_VC1_req, arb_P0_VC1_grant);
arbiter #(`N*`V) arb_P0_VC2(clk, rstn, arb_P0_VC2_req, arb_P0_VC2_grant);
arbiter #(`N*`V) arb_P0_VC3(clk, rstn, arb_P0_VC3_req, arb_P0_VC3_grant);
arbiter #(`N*`V) arb_P1_VC0(clk, rstn, arb_P1_VC0_req, arb_P1_VC0_grant);
arbiter #(`N*`V) arb_P1_VC1(clk, rstn, arb_P1_VC1_req, arb_P1_VC1_grant);
arbiter #(`N*`V) arb_P1_VC2(clk, rstn, arb_P1_VC2_req, arb_P1_VC2_grant);
arbiter #(`N*`V) arb_P1_VC3(clk, rstn, arb_P1_VC3_req, arb_P1_VC3_grant);
arbiter #(`N*`V) arb_P2_VC0(clk, rstn, arb_P2_VC0_req, arb_P2_VC0_grant);
arbiter #(`N*`V) arb_P2_VC1(clk, rstn, arb_P2_VC1_req, arb_P2_VC1_grant);
arbiter #(`N*`V) arb_P2_VC2(clk, rstn, arb_P2_VC2_req, arb_P2_VC2_grant);
arbiter #(`N*`V) arb_P2_VC3(clk, rstn, arb_P2_VC3_req, arb_P2_VC3_grant);
arbiter #(`N*`V) arb_P3_VC0(clk, rstn, arb_P3_VC0_req, arb_P3_VC0_grant);
arbiter #(`N*`V) arb_P3_VC1(clk, rstn, arb_P3_VC1_req, arb_P3_VC1_grant);
arbiter #(`N*`V) arb_P3_VC2(clk, rstn, arb_P3_VC2_req, arb_P3_VC2_grant);
arbiter #(`N*`V) arb_P3_VC3(clk, rstn, arb_P3_VC3_req, arb_P3_VC3_grant);
arbiter #(`N*`V) arb_P4_VC0(clk, rstn, arb_P4_VC0_req, arb_P4_VC0_grant);
arbiter #(`N*`V) arb_P4_VC1(clk, rstn, arb_P4_VC1_req, arb_P4_VC1_grant);
arbiter #(`N*`V) arb_P4_VC2(clk, rstn, arb_P4_VC2_req, arb_P4_VC2_grant);
arbiter #(`N*`V) arb_P4_VC3(clk, rstn, arb_P4_VC3_req, arb_P4_VC3_grant);

transpose_20 pre_arbiter_cross(
    // the input order is unimportant
    // as long as it is consistent with the order of the signals after 2-level's transpose
    reqVC_from_P0_VC0,
    reqVC_from_P0_VC1,
    reqVC_from_P0_VC2,
    reqVC_from_P0_VC3,
    reqVC_from_P1_VC0,
    reqVC_from_P1_VC1,
    reqVC_from_P1_VC2,
    reqVC_from_P1_VC3,
    reqVC_from_P2_VC0,
    reqVC_from_P2_VC1,
    reqVC_from_P2_VC2,
    reqVC_from_P2_VC3,
    reqVC_from_P3_VC0,
    reqVC_from_P3_VC1,
    reqVC_from_P3_VC2,
    reqVC_from_P3_VC3,
    reqVC_from_P4_VC0,
    reqVC_from_P4_VC1,
    reqVC_from_P4_VC2,
    reqVC_from_P4_VC3,

    // the output order is important
    // because we need to distinct each output VC that each arbiter stands for
    arb_P0_VC0_req,
    arb_P0_VC1_req,
    arb_P0_VC2_req,
    arb_P0_VC3_req,
    arb_P1_VC0_req,
    arb_P1_VC1_req,
    arb_P1_VC2_req,
    arb_P1_VC3_req,
    arb_P2_VC0_req,
    arb_P2_VC1_req,
    arb_P2_VC2_req,
    arb_P2_VC3_req,
    arb_P3_VC0_req,
    arb_P3_VC1_req,
    arb_P3_VC2_req,
    arb_P3_VC3_req,
    arb_P4_VC0_req,
    arb_P4_VC1_req,
    arb_P4_VC2_req,
    arb_P4_VC3_req
);

transpose_20 post_arbiter_cross(
    arb_P0_VC0_grant,
    arb_P0_VC1_grant,
    arb_P0_VC2_grant,
    arb_P0_VC3_grant,
    arb_P1_VC0_grant,
    arb_P1_VC1_grant,
    arb_P1_VC2_grant,
    arb_P1_VC3_grant,
    arb_P2_VC0_grant,
    arb_P2_VC1_grant,
    arb_P2_VC2_grant,
    arb_P2_VC3_grant,
    arb_P3_VC0_grant,
    arb_P3_VC1_grant,
    arb_P3_VC2_grant,
    arb_P3_VC3_grant,
    arb_P4_VC0_grant,
    arb_P4_VC1_grant,
    arb_P4_VC2_grant,
    arb_P4_VC3_grant,

    grantVC_for_P0_VC0,
    grantVC_for_P0_VC1,
    grantVC_for_P0_VC2,
    grantVC_for_P0_VC3,
    grantVC_for_P1_VC0,
    grantVC_for_P1_VC1,
    grantVC_for_P1_VC2,
    grantVC_for_P1_VC3,
    grantVC_for_P2_VC0,
    grantVC_for_P2_VC1,
    grantVC_for_P2_VC2,
    grantVC_for_P2_VC3,
    grantVC_for_P3_VC0,
    grantVC_for_P3_VC1,
    grantVC_for_P3_VC2,
    grantVC_for_P3_VC3,
    grantVC_for_P4_VC0,
    grantVC_for_P4_VC1,
    grantVC_for_P4_VC2,
    grantVC_for_P4_VC3
);



endmodule