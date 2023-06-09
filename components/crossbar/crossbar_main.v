/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         crossbar_main.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-09
 *
 *   Description:      This is the main part of the crossbar.
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

module crossbar_main(
    // selected input ports for each output port
    input       wire        [`N-1 : 0]      sel_for_OP0,
    input       wire        [`N-1 : 0]      sel_for_OP1,
    input       wire        [`N-1 : 0]      sel_for_OP2,
    input       wire        [`N-1 : 0]      sel_for_OP3,
    input       wire        [`N-1 : 0]      sel_for_OP4,

    // input data signals from each input port
    input       wire        [`DW-1 : 0]     data_from_P0, 
    input       wire        [`DW-1 : 0]     data_from_P1, 
    input       wire        [`DW-1 : 0]     data_from_P2, 
    input       wire        [`DW-1 : 0]     data_from_P3, 
    input       wire        [`DW-1 : 0]     data_from_P4,

    // input valid signals from each input port
    input       wire                        valid_from_P0,
    input       wire                        valid_from_P1,
    input       wire                        valid_from_P2,
    input       wire                        valid_from_P3,
    input       wire                        valid_from_P4,

    // output data signals to each output port
    output      wire        [`DW-1 : 0]     data_to_P0,
    output      wire        [`DW-1 : 0]     data_to_P1,
    output      wire        [`DW-1 : 0]     data_to_P2,
    output      wire        [`DW-1 : 0]     data_to_P3,
    output      wire        [`DW-1 : 0]     data_to_P4,

    // output valid signals to each output port
    output      wire                        valid_to_P0,
    output      wire                        valid_to_P1,
    output      wire                        valid_to_P2,
    output      wire                        valid_to_P3,
    output      wire                        valid_to_P4
);

mux_5 #(`DW) mux_data_for_OP0(
    sel_for_OP0,
    data_from_P0,
    data_from_P1,
    data_from_P2,
    data_from_P3,
    data_from_P4,
    data_to_P0
);

mux_5 #(`DW) mux_data_for_OP1(
    sel_for_OP1,
    data_from_P0,
    data_from_P1,
    data_from_P2,
    data_from_P3,
    data_from_P4,
    data_to_P1
);

mux_5 #(`DW) mux_data_for_OP2(
    sel_for_OP2,
    data_from_P0,
    data_from_P1,
    data_from_P2,
    data_from_P3,
    data_from_P4,
    data_to_P2
);

mux_5 #(`DW) mux_data_for_OP3(
    sel_for_OP3,
    data_from_P0,
    data_from_P1,
    data_from_P2,
    data_from_P3,
    data_from_P4,
    data_to_P3
);

mux_5 #(`DW) mux_data_for_OP4(
    sel_for_OP4,
    data_from_P0,
    data_from_P1,
    data_from_P2,
    data_from_P3,
    data_from_P4,
    data_to_P4
);

mux_5 #(1) mux_valid_for_OP0(
    sel_for_OP0,
    data_from_P0,
    data_from_P1,
    data_from_P2,
    data_from_P3,
    data_from_P4,
    data_to_P0
);

mux_5 #(1) mux_valid_for_OP1(
    sel_for_OP1,
    data_from_P0,
    data_from_P1,
    data_from_P2,
    data_from_P3,
    data_from_P4,
    data_to_P1
);

mux_5 #(1) mux_valid_for_OP2(
    sel_for_OP2,
    data_from_P0,
    data_from_P1,
    data_from_P2,
    data_from_P3,
    data_from_P4,
    data_to_P2
);

mux_5 #(1) mux_valid_for_OP3(
    sel_for_OP3,
    data_from_P0,
    data_from_P1,
    data_from_P2,
    data_from_P3,
    data_from_P4,
    data_to_P3
);

mux_5 #(1) mux_valid_for_OP4(
    sel_for_OP4,
    data_from_P0,
    data_from_P1,
    data_from_P2,
    data_from_P3,
    data_from_P4,
    data_to_P4
);

endmodule