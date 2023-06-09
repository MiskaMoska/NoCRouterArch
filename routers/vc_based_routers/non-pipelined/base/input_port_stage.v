/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         input_port_stage.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-09
 *
 *   Description:      This is the input port stage for per-port data staging,
 *                     composed of 4 VC buffers, 4 input VC controllers, 4 
 *                     routing computation units, 4 VC allocator input stages, 
 *                     1 switch allocator input stage and 1 crossbar input stage.
 *
*****************************************************************************/

module input_port_stage(
    input       wire                        clk,
    input       wire                        rstn,

    // from router input port
    input       wire                        valid,
    input       wire        [`DW-1 : 0]     data,
    output      wire                        ready,


);

// for input buffers
wire    [`DW-1 : 0]     buf0_dout;
wire    [`DW-1 : 0]     buf1_dout;
wire    [`DW-1 : 0]     buf2_dout;
wire    [`DW-1 : 0]     buf3_dout;

wire                    buf0_read;
wire                    buf1_read;
wire                    buf2_read;
wire                    buf3_read;

wire                    buf0_write;
wire                    buf1_write;
wire                    buf2_write;
wire                    buf3_write;

wire                    buf0_empty;
wire                    buf1_empty;
wire                    buf2_empty;
wire                    buf3_empty;

// for routing computation
wire    [7 : 0]         dst0;
wire    [7 : 0]         dst1;
wire    [7 : 0]         dst2;
wire    [7 : 0]         dst3;

wire    [`N-1 : 0]      candidateOutPort0;
wire    [`N-1 : 0]      candidateOutPort1;
wire    [`N-1 : 0]      candidateOutPort2;
wire    [`N-1 : 0]      candidateOutPort3;

wire    [`V-1 : 0]      candidateOutVC0;
wire    [`V-1 : 0]      candidateOutVC1;
wire    [`V-1 : 0]      candidateOutVC2;
wire    [`V-1 : 0]      candidateOutVC3;

fifo #(
    .width                   (`DW),
    .depth                   (`BUF_DEPTH),
    .depth_LOG               (`BUF_DEPTH_LOG),
    .FWFT                    (1)
)buf0(
    .clk_i                   (clk),
    .rst_i                   (~rstn),
    .read_i                  (buf0_read),
    .write_i                 (buf0_write),
    .full_o                  (),
    .empty_o                 (buf0_empty),
    .data_i                  (data),
    .data_o                  (buf0_dout)
);

fifo #(
    .width                   (`DW),
    .depth                   (`BUF_DEPTH),
    .depth_LOG               (`BUF_DEPTH_LOG),
    .FWFT                    (1)
)buf1(
    .clk_i                   (clk),
    .rst_i                   (~rstn),
    .read_i                  (buf1_read),
    .write_i                 (buf1_write),
    .full_o                  (),
    .empty_o                 (buf1_empty),
    .data_i                  (data),
    .data_o                  (buf1_dout)
);

fifo #(
    .width                   (`DW),
    .depth                   (`BUF_DEPTH),
    .depth_LOG               (`BUF_DEPTH_LOG),
    .FWFT                    (1)
)buf2(
    .clk_i                   (clk),
    .rst_i                   (~rstn),
    .read_i                  (buf2_read),
    .write_i                 (buf2_write),
    .full_o                  (),
    .empty_o                 (buf2_empty),
    .data_i                  (data),
    .data_o                  (buf2_dout)
);

fifo #(
    .width                   (`DW),
    .depth                   (`BUF_DEPTH),
    .depth_LOG               (`BUF_DEPTH_LOG),
    .FWFT                    (1)
)buf3(
    .clk_i                   (clk),
    .rst_i                   (~rstn),
    .read_i                  (buf3_read),
    .write_i                 (buf3_write),
    .full_o                  (),
    .empty_o                 (buf3_empty),
    .data_i                  (data),
    .data_o                  (buf3_dout)
);

input_vc_controller_base vcc0(
    .clk                            (clk),
    .rstn                           (rstn),
    .data                           (buf0_dout),
    .valid                          (~buf0_empty),
    .dst                            (dst0),
    .candidateOutPort               (),
    .candidateOutVC                 (),
    .reqPort                        (),
    .reqVC                          (),
    .VCgranted                      (),
    .selOutVC                       (),
    .reqSA                          (),
    .inputGrantedSA                 (),
    .readyVC_from_OP0               (),
    .readyVC_from_OP1               (),
    .readyVC_from_OP2               (),
    .readyVC_from_OP3               (),
    .readyVC_from_OP4               ()
);


endmodule