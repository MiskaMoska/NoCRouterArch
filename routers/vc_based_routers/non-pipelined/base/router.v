/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         router.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-27
 *
 *   Description:      This is the top module of a basic non-pipelined router, 
 *                     composed of 5 input port stages, 5 output port stages, 
 *                     1 VC allocator (main part), 1 switch allocator (main part),
 *                     and 1 crossbar. 
 *
*****************************************************************************/
`include    "params.vh"

module router #(    
    parameter                               CUR_X = 0,
    parameter                               CUR_Y = 0
)(
    input       wire                        clk,
    input       wire                        rstn,

    /* local input port (Port 0) */
    input       wire                        valid_i_local,
    input       wire        [`DW-1 : 0]     data_i_local,
    output      wire        [`V-1  : 0]     credit_upd_o_local,

    /* local output port (Port 0) */
    output      wire                        valid_o_local,
    output      wire        [`DW-1 : 0]     data_o_local,
    input       wire        [`V-1  : 0]     credit_upd_i_local,

    /* west input port (Port 1) */  
    input       wire                        valid_i_west,
    input       wire        [`DW-1 : 0]     data_i_west,
    output      wire        [`V-1  : 0]     credit_upd_o_west,

    /* west output port (Port 1) */
    output      wire                        valid_o_west,
    output      wire        [`DW-1 : 0]     data_o_west,
    input       wire        [`V-1  : 0]     credit_upd_i_west,

    /* east input port (Port 2) */  
    input       wire                        valid_i_east,
    input       wire        [`DW-1 : 0]     data_i_east,
    output      wire        [`V-1  : 0]     credit_upd_o_east,

    /* east output port (Port 2) */
    output      wire                        valid_o_east,
    output      wire        [`DW-1 : 0]     data_o_east,
    input       wire        [`V-1  : 0]     credit_upd_i_east,

    /* north input port (Port 3) */  
    input       wire                        valid_i_north,
    input       wire        [`DW-1 : 0]     data_i_north,
    output      wire        [`V-1  : 0]     credit_upd_o_north,

    /* north output port (Port 3) */
    output      wire                        valid_o_north,
    output      wire        [`DW-1 : 0]     data_o_north,
    input       wire        [`V-1  : 0]     credit_upd_i_north,

    /* south input port (Port 4) */  
    input       wire                        valid_i_south,
    input       wire        [`DW-1 : 0]     data_i_south,
    output      wire        [`V-1  : 0]     credit_upd_o_south,

    /* south output port (Port 4) */
    output      wire                        valid_o_south,
    output      wire        [`DW-1 : 0]     data_o_south,
    input       wire        [`V-1  : 0]     credit_upd_i_south

);

wire    [`V-1 : 0]      readyVC_from_OP0;
wire    [`V-1 : 0]      readyVC_from_OP1;
wire    [`V-1 : 0]      readyVC_from_OP2;
wire    [`V-1 : 0]      readyVC_from_OP3;
wire    [`V-1 : 0]      readyVC_from_OP4;

wire    [`V-1 : 0]      outVCAvailable_P0;
wire    [`V-1 : 0]      outVCAvailable_P1;
wire    [`V-1 : 0]      outVCAvailable_P2;
wire    [`V-1 : 0]      outVCAvailable_P3;
wire    [`V-1 : 0]      outVCAvailable_P4;

wire                    VCgranted_to_P0_VC0;
wire                    VCgranted_to_P0_VC1;
wire                    VCgranted_to_P0_VC2;
wire                    VCgranted_to_P0_VC3;

wire                    VCgranted_to_P1_VC0;
wire                    VCgranted_to_P1_VC1;
wire                    VCgranted_to_P1_VC2;
wire                    VCgranted_to_P1_VC3;

wire                    VCgranted_to_P2_VC0;
wire                    VCgranted_to_P2_VC1;
wire                    VCgranted_to_P2_VC2;
wire                    VCgranted_to_P2_VC3;

wire                    VCgranted_to_P3_VC0;
wire                    VCgranted_to_P3_VC1;
wire                    VCgranted_to_P3_VC2;
wire                    VCgranted_to_P3_VC3;

wire                    VCgranted_to_P4_VC0;
wire                    VCgranted_to_P4_VC1;
wire                    VCgranted_to_P4_VC2;
wire                    VCgranted_to_P4_VC3;

wire    [`N*`V-1 : 0]   reqVC_from_P0_VC0;
wire    [`N*`V-1 : 0]   reqVC_from_P0_VC1;
wire    [`N*`V-1 : 0]   reqVC_from_P0_VC2;
wire    [`N*`V-1 : 0]   reqVC_from_P0_VC3;

wire    [`N*`V-1 : 0]   reqVC_from_P1_VC0;
wire    [`N*`V-1 : 0]   reqVC_from_P1_VC1;
wire    [`N*`V-1 : 0]   reqVC_from_P1_VC2;
wire    [`N*`V-1 : 0]   reqVC_from_P1_VC3;

wire    [`N*`V-1 : 0]   reqVC_from_P2_VC0;
wire    [`N*`V-1 : 0]   reqVC_from_P2_VC1;
wire    [`N*`V-1 : 0]   reqVC_from_P2_VC2;
wire    [`N*`V-1 : 0]   reqVC_from_P2_VC3;

wire    [`N*`V-1 : 0]   reqVC_from_P3_VC0;
wire    [`N*`V-1 : 0]   reqVC_from_P3_VC1;
wire    [`N*`V-1 : 0]   reqVC_from_P3_VC2;
wire    [`N*`V-1 : 0]   reqVC_from_P3_VC3;

wire    [`N*`V-1 : 0]   reqVC_from_P4_VC0;
wire    [`N*`V-1 : 0]   reqVC_from_P4_VC1;
wire    [`N*`V-1 : 0]   reqVC_from_P4_VC2;
wire    [`N*`V-1 : 0]   reqVC_from_P4_VC3;

wire                    inputGrantSA_to_IP0;
wire                    inputGrantSA_to_IP1;
wire                    inputGrantSA_to_IP2;
wire                    inputGrantSA_to_IP3;
wire                    inputGrantSA_to_IP4;

wire    [`N-1 : 0]      reqSA_from_P0;
wire    [`N-1 : 0]      reqSA_from_P1;
wire    [`N-1 : 0]      reqSA_from_P2;
wire    [`N-1 : 0]      reqSA_from_P3;
wire    [`N-1 : 0]      reqSA_from_P4;

wire    [`DW-1 : 0]     data_from_P0;
wire    [`DW-1 : 0]     data_from_P1;
wire    [`DW-1 : 0]     data_from_P2;
wire    [`DW-1 : 0]     data_from_P3;
wire    [`DW-1 : 0]     data_from_P4;

wire                    valid_from_P0;
wire                    valid_from_P1;
wire                    valid_from_P2;
wire                    valid_from_P3;
wire                    valid_from_P4;

wire    [`V-1 : 0]      outVCAvailableReset_to_P0;
wire    [`V-1 : 0]      outVCAvailableReset_to_P1;
wire    [`V-1 : 0]      outVCAvailableReset_to_P2;
wire    [`V-1 : 0]      outVCAvailableReset_to_P3;
wire    [`V-1 : 0]      outVCAvailableReset_to_P4;

wire    [`N-1 : 0]      selInPort_for_OP0;
wire    [`N-1 : 0]      selInPort_for_OP1;
wire    [`N-1 : 0]      selInPort_for_OP2;
wire    [`N-1 : 0]      selInPort_for_OP3;
wire    [`N-1 : 0]      selInPort_for_OP4;

input_port_stage #(
    .CUR_X                           (CUR_X),
    .CUR_Y                           (CUR_Y)
)input_stage_local(
    .clk                             (clk),
    .rstn                            (rstn),
    .valid                           (valid_i_local),
    .data                            (data_i_local),
    .credit_upd                      (credit_upd_o_local),
    .readyVC_from_OP0                (readyVC_from_OP0),
    .readyVC_from_OP1                (readyVC_from_OP1),
    .readyVC_from_OP2                (readyVC_from_OP2),
    .readyVC_from_OP3                (readyVC_from_OP3),
    .readyVC_from_OP4                (readyVC_from_OP4),
    .outVCAvailable_P0               (outVCAvailable_P0),
    .outVCAvailable_P1               (outVCAvailable_P1),
    .outVCAvailable_P2               (outVCAvailable_P2),
    .outVCAvailable_P3               (outVCAvailable_P3),
    .outVCAvailable_P4               (outVCAvailable_P4),
    .VCgranted_to_VC0                (VCgranted_to_P0_VC0),
    .VCgranted_to_VC1                (VCgranted_to_P0_VC1),
    .VCgranted_to_VC2                (VCgranted_to_P0_VC2),
    .VCgranted_to_VC3                (VCgranted_to_P0_VC3),
    .reqVCOut_from_VC0               (reqVC_from_P0_VC0),
    .reqVCOut_from_VC1               (reqVC_from_P0_VC1),
    .reqVCOut_from_VC2               (reqVC_from_P0_VC2),
    .reqVCOut_from_VC3               (reqVC_from_P0_VC3),
    .inputGrantSAIn                  (inputGrantSA_to_IP0),
    .reqSAOut                        (reqSA_from_P0),
    .data_out                        (data_from_P0),
    .valid_out                       (valid_from_P0)
);

input_port_stage #(
    .CUR_X                           (CUR_X),
    .CUR_Y                           (CUR_Y)
)input_stage_west(
    .clk                             (clk),
    .rstn                            (rstn),
    .valid                           (valid_i_west),
    .data                            (data_i_west),
    .credit_upd                      (credit_upd_o_west),
    .readyVC_from_OP0                (readyVC_from_OP0),
    .readyVC_from_OP1                (readyVC_from_OP1),
    .readyVC_from_OP2                (readyVC_from_OP2),
    .readyVC_from_OP3                (readyVC_from_OP3),
    .readyVC_from_OP4                (readyVC_from_OP4),
    .outVCAvailable_P0               (outVCAvailable_P0),
    .outVCAvailable_P1               (outVCAvailable_P1),
    .outVCAvailable_P2               (outVCAvailable_P2),
    .outVCAvailable_P3               (outVCAvailable_P3),
    .outVCAvailable_P4               (outVCAvailable_P4),
    .VCgranted_to_VC0                (VCgranted_to_P1_VC0),
    .VCgranted_to_VC1                (VCgranted_to_P1_VC1),
    .VCgranted_to_VC2                (VCgranted_to_P1_VC2),
    .VCgranted_to_VC3                (VCgranted_to_P1_VC3),
    .reqVCOut_from_VC0               (reqVC_from_P1_VC0),
    .reqVCOut_from_VC1               (reqVC_from_P1_VC1),
    .reqVCOut_from_VC2               (reqVC_from_P1_VC2),
    .reqVCOut_from_VC3               (reqVC_from_P1_VC3),
    .inputGrantSAIn                  (inputGrantSA_to_IP1),
    .reqSAOut                        (reqSA_from_P1),
    .data_out                        (data_from_P1),
    .valid_out                       (valid_from_P1)
);

input_port_stage #(
    .CUR_X                           (CUR_X),
    .CUR_Y                           (CUR_Y)
)input_stage_east(
    .clk                             (clk),
    .rstn                            (rstn),
    .valid                           (valid_i_east),
    .data                            (data_i_east),
    .credit_upd                      (credit_upd_o_east),
    .readyVC_from_OP0                (readyVC_from_OP0),
    .readyVC_from_OP1                (readyVC_from_OP1),
    .readyVC_from_OP2                (readyVC_from_OP2),
    .readyVC_from_OP3                (readyVC_from_OP3),
    .readyVC_from_OP4                (readyVC_from_OP4),
    .outVCAvailable_P0               (outVCAvailable_P0),
    .outVCAvailable_P1               (outVCAvailable_P1),
    .outVCAvailable_P2               (outVCAvailable_P2),
    .outVCAvailable_P3               (outVCAvailable_P3),
    .outVCAvailable_P4               (outVCAvailable_P4),
    .VCgranted_to_VC0                (VCgranted_to_P2_VC0),
    .VCgranted_to_VC1                (VCgranted_to_P2_VC1),
    .VCgranted_to_VC2                (VCgranted_to_P2_VC2),
    .VCgranted_to_VC3                (VCgranted_to_P2_VC3),
    .reqVCOut_from_VC0               (reqVC_from_P2_VC0),
    .reqVCOut_from_VC1               (reqVC_from_P2_VC1),
    .reqVCOut_from_VC2               (reqVC_from_P2_VC2),
    .reqVCOut_from_VC3               (reqVC_from_P2_VC3),
    .inputGrantSAIn                  (inputGrantSA_to_IP2),
    .reqSAOut                        (reqSA_from_P2),
    .data_out                        (data_from_P2),
    .valid_out                       (valid_from_P2)
);

input_port_stage #(
    .CUR_X                           (CUR_X),
    .CUR_Y                           (CUR_Y)
)input_stage_north(
    .clk                             (clk),
    .rstn                            (rstn),
    .valid                           (valid_i_north),
    .data                            (data_i_north),
    .credit_upd                      (credit_upd_o_north),
    .readyVC_from_OP0                (readyVC_from_OP0),
    .readyVC_from_OP1                (readyVC_from_OP1),
    .readyVC_from_OP2                (readyVC_from_OP2),
    .readyVC_from_OP3                (readyVC_from_OP3),
    .readyVC_from_OP4                (readyVC_from_OP4),
    .outVCAvailable_P0               (outVCAvailable_P0),
    .outVCAvailable_P1               (outVCAvailable_P1),
    .outVCAvailable_P2               (outVCAvailable_P2),
    .outVCAvailable_P3               (outVCAvailable_P3),
    .outVCAvailable_P4               (outVCAvailable_P4),
    .VCgranted_to_VC0                (VCgranted_to_P3_VC0),
    .VCgranted_to_VC1                (VCgranted_to_P3_VC1),
    .VCgranted_to_VC2                (VCgranted_to_P3_VC2),
    .VCgranted_to_VC3                (VCgranted_to_P3_VC3),
    .reqVCOut_from_VC0               (reqVC_from_P3_VC0),
    .reqVCOut_from_VC1               (reqVC_from_P3_VC1),
    .reqVCOut_from_VC2               (reqVC_from_P3_VC2),
    .reqVCOut_from_VC3               (reqVC_from_P3_VC3),
    .inputGrantSAIn                  (inputGrantSA_to_IP3),
    .reqSAOut                        (reqSA_from_P3),
    .data_out                        (data_from_P3),
    .valid_out                       (valid_from_P3)
);

input_port_stage #(
    .CUR_X                           (CUR_X),
    .CUR_Y                           (CUR_Y)
)input_stage_south(
    .clk                             (clk),
    .rstn                            (rstn),
    .valid                           (valid_i_south),
    .data                            (data_i_south),
    .credit_upd                      (credit_upd_o_south),
    .readyVC_from_OP0                (readyVC_from_OP0),
    .readyVC_from_OP1                (readyVC_from_OP1),
    .readyVC_from_OP2                (readyVC_from_OP2),
    .readyVC_from_OP3                (readyVC_from_OP3),
    .readyVC_from_OP4                (readyVC_from_OP4),
    .outVCAvailable_P0               (outVCAvailable_P0),
    .outVCAvailable_P1               (outVCAvailable_P1),
    .outVCAvailable_P2               (outVCAvailable_P2),
    .outVCAvailable_P3               (outVCAvailable_P3),
    .outVCAvailable_P4               (outVCAvailable_P4),
    .VCgranted_to_VC0                (VCgranted_to_P4_VC0),
    .VCgranted_to_VC1                (VCgranted_to_P4_VC1),
    .VCgranted_to_VC2                (VCgranted_to_P4_VC2),
    .VCgranted_to_VC3                (VCgranted_to_P4_VC3),
    .reqVCOut_from_VC0               (reqVC_from_P4_VC0),
    .reqVCOut_from_VC1               (reqVC_from_P4_VC1),
    .reqVCOut_from_VC2               (reqVC_from_P4_VC2),
    .reqVCOut_from_VC3               (reqVC_from_P4_VC3),
    .inputGrantSAIn                  (inputGrantSA_to_IP4),
    .reqSAOut                        (reqSA_from_P4),
    .data_out                        (data_from_P4),
    .valid_out                       (valid_from_P4)
);

output_port_stage output_stage_local(
    .clk                             (clk),
    .rstn                            (rstn),
    .valid                           (valid_o_local),
    .data                            (data_o_local),
    .credit_upd                      (credit_upd_i_local),
    .outVCAvailableReset             (outVCAvailableReset_to_P0),
    .outVCAvailable                  (outVCAvailable_P0),
    .outVCReady                      (readyVC_from_OP0)
);

output_port_stage output_stage_west(
    .clk                             (clk),
    .rstn                            (rstn),
    .valid                           (valid_o_west),
    .data                            (data_o_west),
    .credit_upd                      (credit_upd_i_west),
    .outVCAvailableReset             (outVCAvailableReset_to_P1),
    .outVCAvailable                  (outVCAvailable_P1),
    .outVCReady                      (readyVC_from_OP1)
);

output_port_stage output_stage_east(
    .clk                             (clk),
    .rstn                            (rstn),
    .valid                           (valid_o_east),
    .data                            (data_o_east),
    .credit_upd                      (credit_upd_i_east),
    .outVCAvailableReset             (outVCAvailableReset_to_P2),
    .outVCAvailable                  (outVCAvailable_P2),
    .outVCReady                      (readyVC_from_OP2)
);

output_port_stage output_stage_north(
    .clk                             (clk),
    .rstn                            (rstn),
    .valid                           (valid_o_north),
    .data                            (data_o_north),
    .credit_upd                      (credit_upd_i_north),
    .outVCAvailableReset             (outVCAvailableReset_to_P3),
    .outVCAvailable                  (outVCAvailable_P3),
    .outVCReady                      (readyVC_from_OP3)
);

output_port_stage output_stage_south(
    .clk                             (clk),
    .rstn                            (rstn),
    .valid                           (valid_o_south),
    .data                            (data_o_south),
    .credit_upd                      (credit_upd_i_south),
    .outVCAvailableReset             (outVCAvailableReset_to_P4),
    .outVCAvailable                  (outVCAvailable_P4),
    .outVCReady                      (readyVC_from_OP4)
);

va_main va(
    .clk                             (clk),
    .rstn                            (rstn),
    .reqVC_from_P0_VC0               (reqVC_from_P0_VC0),
    .reqVC_from_P0_VC1               (reqVC_from_P0_VC1),
    .reqVC_from_P0_VC2               (reqVC_from_P0_VC2),
    .reqVC_from_P0_VC3               (reqVC_from_P0_VC3),
    .reqVC_from_P1_VC0               (reqVC_from_P1_VC0),
    .reqVC_from_P1_VC1               (reqVC_from_P1_VC1),
    .reqVC_from_P1_VC2               (reqVC_from_P1_VC2),
    .reqVC_from_P1_VC3               (reqVC_from_P1_VC3),
    .reqVC_from_P2_VC0               (reqVC_from_P2_VC0),
    .reqVC_from_P2_VC1               (reqVC_from_P2_VC1),
    .reqVC_from_P2_VC2               (reqVC_from_P2_VC2),
    .reqVC_from_P2_VC3               (reqVC_from_P2_VC3),
    .reqVC_from_P3_VC0               (reqVC_from_P3_VC0),
    .reqVC_from_P3_VC1               (reqVC_from_P3_VC1),
    .reqVC_from_P3_VC2               (reqVC_from_P3_VC2),
    .reqVC_from_P3_VC3               (reqVC_from_P3_VC3),
    .reqVC_from_P4_VC0               (reqVC_from_P4_VC0),
    .reqVC_from_P4_VC1               (reqVC_from_P4_VC1),
    .reqVC_from_P4_VC2               (reqVC_from_P4_VC2),
    .reqVC_from_P4_VC3               (reqVC_from_P4_VC3),
    .VCgranted_to_P0_VC0             (VCgranted_to_P0_VC0),
    .VCgranted_to_P0_VC1             (VCgranted_to_P0_VC1),
    .VCgranted_to_P0_VC2             (VCgranted_to_P0_VC2),
    .VCgranted_to_P0_VC3             (VCgranted_to_P0_VC3),
    .VCgranted_to_P1_VC0             (VCgranted_to_P1_VC0),
    .VCgranted_to_P1_VC1             (VCgranted_to_P1_VC1),
    .VCgranted_to_P1_VC2             (VCgranted_to_P1_VC2),
    .VCgranted_to_P1_VC3             (VCgranted_to_P1_VC3),
    .VCgranted_to_P2_VC0             (VCgranted_to_P2_VC0),
    .VCgranted_to_P2_VC1             (VCgranted_to_P2_VC1),
    .VCgranted_to_P2_VC2             (VCgranted_to_P2_VC2),
    .VCgranted_to_P2_VC3             (VCgranted_to_P2_VC3),
    .VCgranted_to_P3_VC0             (VCgranted_to_P3_VC0),
    .VCgranted_to_P3_VC1             (VCgranted_to_P3_VC1),
    .VCgranted_to_P3_VC2             (VCgranted_to_P3_VC2),
    .VCgranted_to_P3_VC3             (VCgranted_to_P3_VC3),
    .VCgranted_to_P4_VC0             (VCgranted_to_P4_VC0),
    .VCgranted_to_P4_VC1             (VCgranted_to_P4_VC1),
    .VCgranted_to_P4_VC2             (VCgranted_to_P4_VC2),
    .VCgranted_to_P4_VC3             (VCgranted_to_P4_VC3),
    .outVCAvailableReset_to_P0       (outVCAvailableReset_to_P0),
    .outVCAvailableReset_to_P1       (outVCAvailableReset_to_P1),
    .outVCAvailableReset_to_P2       (outVCAvailableReset_to_P2),
    .outVCAvailableReset_to_P3       (outVCAvailableReset_to_P3),
    .outVCAvailableReset_to_P4       (outVCAvailableReset_to_P4)
);

sa_main sa(
    .clk                             (clk),
    .rstn                            (rstn),
    .reqSA_from_P0                   (reqSA_from_P0),
    .reqSA_from_P1                   (reqSA_from_P1),
    .reqSA_from_P2                   (reqSA_from_P2),
    .reqSA_from_P3                   (reqSA_from_P3),
    .reqSA_from_P4                   (reqSA_from_P4),
    .inputGrantSA_to_IP0             (inputGrantSA_to_IP0),
    .inputGrantSA_to_IP1             (inputGrantSA_to_IP1),
    .inputGrantSA_to_IP2             (inputGrantSA_to_IP2),
    .inputGrantSA_to_IP3             (inputGrantSA_to_IP3),
    .inputGrantSA_to_IP4             (inputGrantSA_to_IP4),
    .selInPort_for_OP0               (selInPort_for_OP0),
    .selInPort_for_OP1               (selInPort_for_OP1),
    .selInPort_for_OP2               (selInPort_for_OP2),
    .selInPort_for_OP3               (selInPort_for_OP3),
    .selInPort_for_OP4               (selInPort_for_OP4)
);

xb_main xb(
    .sel_for_OP0                     (selInPort_for_OP0),
    .sel_for_OP1                     (selInPort_for_OP1),
    .sel_for_OP2                     (selInPort_for_OP2),
    .sel_for_OP3                     (selInPort_for_OP3),
    .sel_for_OP4                     (selInPort_for_OP4),
    .data_from_P0                    (data_from_P0),
    .data_from_P1                    (data_from_P1),
    .data_from_P2                    (data_from_P2),
    .data_from_P3                    (data_from_P3),
    .data_from_P4                    (data_from_P4),
    .valid_from_P0                   (valid_from_P0),
    .valid_from_P1                   (valid_from_P1),
    .valid_from_P2                   (valid_from_P2),
    .valid_from_P3                   (valid_from_P3),
    .valid_from_P4                   (valid_from_P4),
    .data_to_P0                      (data_o_local),
    .data_to_P1                      (data_o_west),
    .data_to_P2                      (data_o_east),
    .data_to_P3                      (data_o_north),
    .data_to_P4                      (data_o_south),
    .valid_to_P0                     (valid_o_local),
    .valid_to_P1                     (valid_o_west),
    .valid_to_P2                     (valid_o_east),
    .valid_to_P3                     (valid_o_north),
    .valid_to_P4                     (valid_o_south)
);

endmodule