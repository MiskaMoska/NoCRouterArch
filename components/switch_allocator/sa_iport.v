/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         sa_iport.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-09
 *
 *   Description:      This is the input VC stage of the VC allocator.
 *                     Presented in the grey block in Fig.7.15 @ P-129.
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

module sa_iport(
    input       wire                        clk,
    input       wire                        rstn,

    // input port request signal
    input       wire        [`N-1 : 0]      reqPort_from_VC0,
    input       wire        [`N-1 : 0]      reqPort_from_VC1,
    input       wire        [`N-1 : 0]      reqPort_from_VC2,
    input       wire        [`N-1 : 0]      reqPort_from_VC3,
    
    // output port request signal
    output      wire        [`N-1 : 0]      reqPortOut,

    // input granted signal
    input       wire                        PortgrantedIn,

    // output granted signal to each VC
    output      wire        [`N-1 : 0]      Portgranted_to_VC0,
    output      wire        [`N-1 : 0]      Portgranted_to_VC1,
    output      wire        [`N-1 : 0]      Portgranted_to_VC2,
    output      wire        [`N-1 : 0]      Portgranted_to_VC3
);

wire    reqValid_from_VC0;
wire    reqValid_from_VC1;
wire    reqValid_from_VC2;
wire    reqValid_from_VC3;

wire    [`V-1 : 0]  local_arb_req, local_arb_grant;

wire    [`N-1 : 0]  

assign reqValid_from_VC0 = | reqPort_from_VC0;
assign reqValid_from_VC1 = | reqPort_from_VC1;
assign reqValid_from_VC2 = | reqPort_from_VC2;
assign reqValid_from_VC3 = | reqPort_from_VC3;

assign local_arb_req = {
    reqValid_from_VC3, 
    reqValid_from_VC2, 
    reqValid_from_VC1, 
    reqValid_from_VC0
};

arbiter #(`V) local_arb(
    clk, rstn, local_arb_req, local_arb_grant
);

mux_4 #(`N) req_mux(
    local_arb_grant,
    reqPort_from_VC0,
    reqPort_from_VC1,
    reqPort_from_VC2,
    reqPort_from_VC3,
    reqPortOut
);

demux_4 #(`N) req_mux(
    local_arb_grant,
    PortgrantedIn,
    Portgranted_to_VC0,
    Portgranted_to_VC1,
    Portgranted_to_VC2,
    Portgranted_to_VC3
)

endmodule