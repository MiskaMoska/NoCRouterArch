/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         input_vc_controller_base.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-09
 *
 *   Description:      This is a user-defined routing computation unit.
 *
 *   Annotation:       This module can be applied to any router architecture.
 *
*****************************************************************************/
`include    "params.vh"

module rc #(
    parameter                               CUR_X = 0,
    parameter                               CUR_Y = 0
)(
    input       wire        [7 : 0]         dst,
    output      wire        [`N-1 : 0]      candidateOutPort,
    output      wire        [`V-1 : 0]      candidateOutVC
);

// dummy routing function
assign candidateOutPort = 1;
assign candidateOutVC = 1;

endmodule