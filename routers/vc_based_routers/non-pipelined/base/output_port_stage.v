/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         output_port_stage.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-27
 *
 *   Description:      This is the output port stage for per-port data staging,
 *                     composed of 4 output VC controllers.
 *
*****************************************************************************/

module(
    input       wire                        clk,
    input       wire                        rstn,

    // data path signals from the output of the crossbar
    input       wire                        valid,
    input       wire        [`DW-1 : 0]     data,

    // credit update signals from downstream
    input       wire        [`V-1 : 0]      credit_upd,

    // VA availability flag reset signal for the current output VC
    input       wire        [`V-1 : 0]      outVCAvailableReset, // from VC allocator

    // output VC availability flag
    output      wire        [`V-1 : 0]      outVCAvailable,

    // output VC ready (plenty credit)
    output      wire        [`V-1 : 0]      outVCReady

);

output_vc_controller_base #(
    .VCID                              (0)
)ovcc0(
    .clk                               (clk),
    .rstn                              (rstn),
    .valid                             (valid),
    .data                              (data),
    .credit_upd                        (credit_upd[0]),
    .outVCAvailableReset               (outVCAvailable[0]),
    .outVCAvailable                    (outVCAvailable[0]),
    .outVCReady                        (outVCReady[0])
);

output_vc_controller_base #(
    .VCID                              (1)
)ovcc1(
    .clk                               (clk),
    .rstn                              (rstn),
    .valid                             (valid),
    .data                              (data),
    .credit_upd                        (credit_upd[1]),
    .outVCAvailableReset               (outVCAvailable[1]),
    .outVCAvailable                    (outVCAvailable[1]),
    .outVCReady                        (outVCReady[1])
);

output_vc_controller_base #(
    .VCID                              (2)
)ovcc2(
    .clk                               (clk),
    .rstn                              (rstn),
    .valid                             (valid),
    .data                              (data),
    .credit_upd                        (credit_upd[2]),
    .outVCAvailableReset               (outVCAvailable[2]),
    .outVCAvailable                    (outVCAvailable[2]),
    .outVCReady                        (outVCReady[2])
);

output_vc_controller_base #(
    .VCID                              (3)
)ovcc3(
    .clk                               (clk),
    .rstn                              (rstn),
    .valid                             (valid),
    .data                              (data),
    .credit_upd                        (credit_upd[3]),
    .outVCAvailableReset               (outVCAvailable[3]),
    .outVCAvailable                    (outVCAvailable[3]),
    .outVCReady                        (outVCReady[3])
);

endmodule