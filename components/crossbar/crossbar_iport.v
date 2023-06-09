/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         crossbar_iport.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-09
 *
 *   Description:      This is the input port stage of the crossbar, mainly
 *                     for local mutiplexing for VCs in the same input port.
 *                     Presented in Fig.7.11 @ P-125.
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

module crossbar_iport(
    input       wire                        clk,
    input       wire                        rstn,

    // selection signal for local multiplexing
    input       wire        [`V-1 : 0]      sel,

    // input data signals from all VCs of the current input port
    input       wire        [`DW-1 : 0]     data_from_VC0,
    input       wire        [`DW-1 : 0]     data_from_VC1,
    input       wire        [`DW-1 : 0]     data_from_VC2,
    input       wire        [`DW-1 : 0]     data_from_VC3,

    // input valid signals from all VCs of the current input port
    input       wire                        valid_from_VC0,
    input       wire                        valid_from_VC1,
    input       wire                        valid_from_VC2,
    input       wire                        valid_from_VC3,

    // output data signal to the main part of the crossbar
    output      wire        [`DW-1 : 0]     data_out,

    // output valid signal to the main part of the crossbar
    output      wire                        valid_out,            
);

mux_4 #(`DW) data_mux(
    sel,
    data_from_VC0,
    data_from_VC1,
    data_from_VC2,
    data_from_VC3,
    data_out
);

mux_4 #(1) valid_mux(
    sel,
    valid_from_VC0,
    valid_from_VC1,
    valid_from_VC2,
    valid_from_VC3,
    valid_out
);

endmodule