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

module #(    
    parameter                               CUR_X = 0,
    parameter                               CUR_Y = 0
)(
    input       wire                        clk,
    input       wire                        rstn,

    /* local input port (Port 0) */
    input       wire                        valid_local,
    input       wire        [`DW-1 : 0]     data_local,
    output      wire        [`V-1  : 0]     credit_upd_local,

    /* west input port (Port 1) */  
    input       wire                        valid_west,
    input       wire        [`DW-1 : 0]     data_west,
    output      wire        [`V-1  : 0]     credit_upd_west,

    /* east input port (Port 2) */  
    input       wire                        valid_east,
    input       wire        [`DW-1 : 0]     data_east,
    output      wire        [`V-1  : 0]     credit_upd_east,

    /* north input port (Port 3) */  
    input       wire                        valid_north,
    input       wire        [`DW-1 : 0]     data_north,
    output      wire        [`V-1  : 0]     credit_upd_north,

    /* south input port (Port 4) */  
    input       wire                        valid_south,
    input       wire        [`DW-1 : 0]     data_south,
    output      wire        [`V-1  : 0]     credit_upd_south

);

input_port_stage #(
    .CUR_X                           (CUR_X),
    .CUR_Y                           (CUR_Y)
)input_stage_local(
    .clk                             (clk),
    .rstn                            (rstn),
    .valid                           (valid_local),
    .data                            (data_local),
    .credit_upd                      (credit_upd_local),
    .readyVC_from_OP0                (readyVC_from_OP0),
    .readyVC_from_OP1                (readyVC_from_OP1),
    .readyVC_from_OP2                (readyVC_from_OP2),
    .readyVC_from_OP3                (readyVC_from_OP3),
    .readyVC_from_OP4                (readyVC_from_OP4),
    .outVCAvailable_P0               (outVCAvailable_P0),
    .outVCAvailable_P1               (outVCAvailable_P1),
    .outVCAvailable_P2               (outVCAvailable_P2),
    .outVCAvailable_P3               (outVCAvailable_P3),
    .outVCAvailable_P3               (outVCAvailable_P4),
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

endmodule