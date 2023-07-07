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
`include    "params.vh"

module input_port_stage #(
    parameter                               CUR_X = 0,
    parameter                               CUR_Y = 0
)(
    input       wire                        clk,
    input       wire                        rstn,

    // from router input port
    input       wire                        valid,
    input       wire        [`DW-1 : 0]     data,

    // credit update signals to upstream
    output      wire        [`V-1  : 0]     credit_upd,

    // output VC ready signals
    input       wire        [`V-1 : 0]      readyVC_from_OP0,
    input       wire        [`V-1 : 0]      readyVC_from_OP1,
    input       wire        [`V-1 : 0]      readyVC_from_OP2,
    input       wire        [`V-1 : 0]      readyVC_from_OP3,
    input       wire        [`V-1 : 0]      readyVC_from_OP4,

    // output VC availability flags
    input       wire        [`V-1 : 0]      outVCAvailable_P0,
    input       wire        [`V-1 : 0]      outVCAvailable_P1,
    input       wire        [`V-1 : 0]      outVCAvailable_P2,
    input       wire        [`V-1 : 0]      outVCAvailable_P3,
    input       wire        [`V-1 : 0]      outVCAvailable_P4,

    // from VC allocator main part
    input       wire                        VCgranted_to_VC0,
    input       wire                        VCgranted_to_VC1,
    input       wire                        VCgranted_to_VC2,
    input       wire                        VCgranted_to_VC3,

    // to VC allocator main part
    output      wire        [`N*`V-1 : 0]   reqVCOut_from_VC0,                    
    output      wire        [`N*`V-1 : 0]   reqVCOut_from_VC1,                    
    output      wire        [`N*`V-1 : 0]   reqVCOut_from_VC2,                    
    output      wire        [`N*`V-1 : 0]   reqVCOut_from_VC3,

    // from switch allocator main part
    input       wire                        inputGrantSAIn,        

    // to switch allocator main part
    output      wire        [`N-1 : 0]      reqSAOut,

    // to crossbar main part
    output      wire        [`DW-1 : 0]     data_out,
    output      wire                        valid_out
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

// for VC allocation
wire    [`N-1 : 0]      reqPort0;
wire    [`N-1 : 0]      reqPort1;
wire    [`N-1 : 0]      reqPort2;
wire    [`N-1 : 0]      reqPort3;

wire    [`V-1 : 0]      reqVC0;
wire    [`V-1 : 0]      reqVC1;
wire    [`V-1 : 0]      reqVC2;
wire    [`V-1 : 0]      reqVC3;

wire                    VCgranted0;
wire                    VCgranted1;
wire                    VCgranted2;
wire                    VCgranted3;

wire    [`V-1 : 0]      selOutVC0;
wire    [`V-1 : 0]      selOutVC1;
wire    [`V-1 : 0]      selOutVC2;
wire    [`V-1 : 0]      selOutVC3;

// for switch allocation
wire    [`N-1 : 0]      reqSA0;
wire    [`N-1 : 0]      reqSA1;
wire    [`N-1 : 0]      reqSA2;
wire    [`N-1 : 0]      reqSA3;

wire                    inputGrantSA0;
wire                    inputGrantSA1;
wire                    inputGrantSA2;
wire                    inputGrantSA3;

// for local VC mux
wire    [`V-1 : 0]      inputVCSelect;

// for VCID replacement
wire    [`DW-1 : 0]     data_new_vc0;
wire    [`DW-1 : 0]     data_new_vc1;
wire    [`DW-1 : 0]     data_new_vc2;
wire    [`DW-1 : 0]     data_new_vc3;

//--------------------------------------------------------------------
//                          VC Buffers
//--------------------------------------------------------------------

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

//--------------------------------------------------------------------
//                      Input VC Controllers
//--------------------------------------------------------------------

assign VCgranted0 = VCgranted_to_VC0;
assign VCgranted1 = VCgranted_to_VC1;
assign VCgranted2 = VCgranted_to_VC2;
assign VCgranted3 = VCgranted_to_VC3;

input_vc_controller_base vcc0(
    .clk                            (clk),
    .rstn                           (rstn),
    .data                           (buf0_dout),
    .valid                          (~buf0_empty),
    .dst                            (dst0),
    .candidateOutPort               (candidateOutPort0),
    .candidateOutVC                 (candidateOutVC0),
    .reqPort                        (reqPort0),
    .reqVC                          (reqVC0),
    .VCgranted                      (VCgranted0),
    .selOutVC                       (selOutVC0),
    .reqSA                          (reqSA0),
    .inputGrantSA                   (inputGrantSA0),
    .readyVC_from_OP0               (readyVC_from_OP0),
    .readyVC_from_OP1               (readyVC_from_OP1),
    .readyVC_from_OP2               (readyVC_from_OP2),
    .readyVC_from_OP3               (readyVC_from_OP3),
    .readyVC_from_OP4               (readyVC_from_OP4)
);

input_vc_controller_base vcc1(
    .clk                            (clk),
    .rstn                           (rstn),
    .data                           (buf1_dout),
    .valid                          (~buf1_empty),
    .dst                            (dst1),
    .candidateOutPort               (candidateOutPort1),
    .candidateOutVC                 (candidateOutVC1),
    .reqPort                        (reqPort1),
    .reqVC                          (reqVC1),
    .VCgranted                      (VCgranted1),
    .selOutVC                       (selOutVC1),
    .reqSA                          (reqSA1),
    .inputGrantSA                   (inputGrantSA1),
    .readyVC_from_OP0               (readyVC_from_OP0),
    .readyVC_from_OP1               (readyVC_from_OP1),
    .readyVC_from_OP2               (readyVC_from_OP2),
    .readyVC_from_OP3               (readyVC_from_OP3),
    .readyVC_from_OP4               (readyVC_from_OP4)
);

input_vc_controller_base vcc2(
    .clk                            (clk),
    .rstn                           (rstn),
    .data                           (buf2_dout),
    .valid                          (~buf2_empty),
    .dst                            (dst2),
    .candidateOutPort               (candidateOutPort2),
    .candidateOutVC                 (candidateOutVC2),
    .reqPort                        (reqPort2),
    .reqVC                          (reqVC2),
    .VCgranted                      (VCgranted2),
    .selOutVC                       (selOutVC2),
    .reqSA                          (reqSA2),
    .inputGrantSA                   (inputGrantSA2),
    .readyVC_from_OP0               (readyVC_from_OP0),
    .readyVC_from_OP1               (readyVC_from_OP1),
    .readyVC_from_OP2               (readyVC_from_OP2),
    .readyVC_from_OP3               (readyVC_from_OP3),
    .readyVC_from_OP4               (readyVC_from_OP4)
);

input_vc_controller_base vcc3(
    .clk                            (clk),
    .rstn                           (rstn),
    .data                           (buf3_dout),
    .valid                          (~buf3_empty),
    .dst                            (dst3),
    .candidateOutPort               (candidateOutPort3),
    .candidateOutVC                 (candidateOutVC3),
    .reqPort                        (reqPort3),
    .reqVC                          (reqVC3),
    .VCgranted                      (VCgranted3),
    .selOutVC                       (selOutVC3),
    .reqSA                          (reqSA3),
    .inputGrantSA                   (inputGrantSA3),
    .readyVC_from_OP0               (readyVC_from_OP0),
    .readyVC_from_OP1               (readyVC_from_OP1),
    .readyVC_from_OP2               (readyVC_from_OP2),
    .readyVC_from_OP3               (readyVC_from_OP3),
    .readyVC_from_OP4               (readyVC_from_OP4)
);

//--------------------------------------------------------------------
//                          RC Units
//--------------------------------------------------------------------

rc #(CUR_X, CUR_Y)rc0(
    .dst                            (dst0),
    .candidateOutPort               (candidateOutPort0),
    .candidateOutVC                 (candidateOutVC0)
);

rc #(CUR_X, CUR_Y)rc1(
    .dst                            (dst1),
    .candidateOutPort               (candidateOutPort1),
    .candidateOutVC                 (candidateOutVC1)
);

rc #(CUR_X, CUR_Y)rc2(
    .dst                            (dst2),
    .candidateOutPort               (candidateOutPort2),
    .candidateOutVC                 (candidateOutVC2)
);

rc #(CUR_X, CUR_Y)rc3(
    .dst                            (dst3),
    .candidateOutPort               (candidateOutPort3),
    .candidateOutVC                 (candidateOutVC3)
);

//--------------------------------------------------------------------
//                       VA Input VC Stages
//--------------------------------------------------------------------

va_ivc_low_cost va_ivc0(
    .clk                             (clk),
    .rstn                            (rstn),
    .reqPort                         (reqPort0),
    .reqVC                           (reqVC0),
    .outVCAvailable_P0               (outVCAvailable_P0),
    .outVCAvailable_P1               (outVCAvailable_P1),
    .outVCAvailable_P2               (outVCAvailable_P2),
    .outVCAvailable_P3               (outVCAvailable_P3),
    .outVCAvailable_P4               (outVCAvailable_P4),
    .selOutVC                        (selOutVC0),
    .reqVCOut                        (reqVCOut_from_VC0)
);

va_ivc_low_cost va_ivc1(
    .clk                             (clk),
    .rstn                            (rstn),
    .reqPort                         (reqPort1),
    .reqVC                           (reqVC1),
    .outVCAvailable_P0               (outVCAvailable_P0),
    .outVCAvailable_P1               (outVCAvailable_P1),
    .outVCAvailable_P2               (outVCAvailable_P2),
    .outVCAvailable_P3               (outVCAvailable_P3),
    .outVCAvailable_P4               (outVCAvailable_P4),
    .selOutVC                        (selOutVC1),
    .reqVCOut                        (reqVCOut_from_VC1)
);

va_ivc_low_cost va_ivc2(
    .clk                             (clk),
    .rstn                            (rstn),
    .reqPort                         (reqPort2),
    .reqVC                           (reqVC2),
    .outVCAvailable_P0               (outVCAvailable_P0),
    .outVCAvailable_P1               (outVCAvailable_P1),
    .outVCAvailable_P2               (outVCAvailable_P2),
    .outVCAvailable_P3               (outVCAvailable_P3),
    .outVCAvailable_P4               (outVCAvailable_P4),
    .selOutVC                        (selOutVC2),
    .reqVCOut                        (reqVCOut_from_VC2)
);

va_ivc_low_cost va_ivc3(
    .clk                             (clk),
    .rstn                            (rstn),
    .reqPort                         (reqPort3),
    .reqVC                           (reqVC3),
    .outVCAvailable_P0               (outVCAvailable_P0),
    .outVCAvailable_P1               (outVCAvailable_P1),
    .outVCAvailable_P2               (outVCAvailable_P2),
    .outVCAvailable_P3               (outVCAvailable_P3),
    .outVCAvailable_P4               (outVCAvailable_P4),
    .selOutVC                        (selOutVC3),
    .reqVCOut                        (reqVCOut_from_VC3)
);

//--------------------------------------------------------------------
//                      SA Input Port Stage
//--------------------------------------------------------------------

sa_iport sa_iport(
    .clk                             (clk),
    .rstn                            (rstn),
    .reqSA_from_VC0                  (reqSA0),
    .reqSA_from_VC1                  (reqSA1),
    .reqSA_from_VC2                  (reqSA2),
    .reqSA_from_VC3                  (reqSA3),
    .reqSAOut                        (reqSAOut),
    .inputGrantSAIn                  (inputGrantSAIn),
    .inputGrantSA_to_VC0             (inputGrantSA0),
    .inputGrantSA_to_VC1             (inputGrantSA1),
    .inputGrantSA_to_VC2             (inputGrantSA2),
    .inputGrantSA_to_VC3             (inputGrantSA3),
    .inputVCSelect                   (inputVCSelect)
);


//--------------------------------------------------------------------
//                      VCID Replacement
//
// for VCID replacement, the selOutVC signal is enough,
// because only head flit need replacement, and the selOutVC
// is generated by VA as soon as the head flit exposes.
//--------------------------------------------------------------------

vc_replacement vc_replacement0(
    .selOutVC                         (selOutVC0),
    .data_i                           (buf0_dout),
    .data_o                           (data_new_vc0)
);

vc_replacement vc_replacement1(
    .selOutVC                         (selOutVC1),
    .data_i                           (buf1_dout),
    .data_o                           (data_new_vc1)
);

vc_replacement vc_replacement2(
    .selOutVC                         (selOutVC2),
    .data_i                           (buf2_dout),
    .data_o                           (data_new_vc2)
);

vc_replacement vc_replacement3(
    .selOutVC                         (selOutVC3),
    .data_i                           (buf3_dout),
    .data_o                           (data_new_vc3)
);


//--------------------------------------------------------------------
//                   Crossbar Input Port Stage
//--------------------------------------------------------------------

xb_iport xb_iport(
    .clk                          (clk),
    .rstn                         (rstn),
    .sel                          (inputVCSelect),
    .data_from_VC0                (data_new_vc0),
    .data_from_VC1                (data_new_vc1),
    .data_from_VC2                (data_new_vc2),
    .data_from_VC3                (data_new_vc3),
    .valid_from_VC0               (~buf0_empty),
    .valid_from_VC1               (~buf1_empty),
    .valid_from_VC2               (~buf2_empty),
    .valid_from_VC3               (~buf3_empty),
    .data_out                     (data_out),
    .valid_out                    (valid_out)
);

//--------------------------------------------------------------------
//                   Credit Update
//--------------------------------------------------------------------
assign credit_upd = {buf3_read, buf2_read, buf1_read, buf0_read};

endmodule