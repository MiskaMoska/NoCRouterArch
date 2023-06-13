/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         output_port_stage.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-09
 *
 *   Description:      This is the output port stage for per-port data staging,
 *                     composed of 4 output VC controllers.
 *
*****************************************************************************/

module(
    input       wire                        clk,
    input       wire                        rstn,


);

output_vc_controller_base #(
    .VCID                              (0)
)aa(
    .clk                               (clk),
    .rstn                              (rstn),
    .update                            (update),
    .outVCAvailableReset               (),
    .valid                             (),
    .dat                               (),
    .outVCAvailable                    (),
    .outVCReady                        ()
);

endmodule