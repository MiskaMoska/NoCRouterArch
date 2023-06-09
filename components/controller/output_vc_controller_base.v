/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         output_vc_controller_base.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-09
 *
 *   Description:      This is a basic output VC controller, which manages a
 *                     credit counter and a output VC availibility flag.
 *                     Presented in Fig.7.8 @ P-122.
 *
 *   Annotation:       This module is designed for non-pipelined router only.
 *
*****************************************************************************/

module output_vc_controller_base #(
    parameter               [1 : 0]         VCID     
)(
    input       wire                        clk,
    input       wire                        rstn,

    // credit update signals from downstream
    input       wire        [`V-1 : 0]      update,

    // VA availability flag reset signal for the current output VC
    input       wire                        outVCAvailableReset, // from VC allocator

    // data path signals from the output of the crossbar
    input       wire                        valid,
    input       wire        [`DW-1 : 0]     dat,

    // output VC availability flag
    output      wire                        outVCAvailable                   
);

reg     [`BUF_DEPTH_LOG-1 : 0]  credit_cnt;
reg     [`BUF_DEPTH_LOG-1 : 0]  nxt_credit_cnt;

wire    [1 : 0]                 flit_vcid;
wire    [1 : 0]                 flit_header;
wire    [1 : 0]                 credit_cnt_ctrl;

reg                             update_reg;
reg                             _outVCAvailable;

assign flit_vcid    = data[`DW-1 : `DW-2];
assign flit_header  = data[`DW-3 : `DW-4];


//--------------------------------------------------------------------
//                     Credit Counter Control
//--------------------------------------------------------------------

assign credit_cnt_ctrl = {(flit_vcid == VCID) & valid, update_reg};

always @(posedge clk or negedge rstn) begin
    if(~rstn) begin
        update_reg <= 0;
    end else begin
        update_reg <= update;
    end
end

always_comb begin
    case(credit_cnt_ctrl)
        2'b01:  nxt_credit_cnt = credit_cnt + 1;
        2'b10:  nxt_credit_cnt = credit_cnt -1;
        default: nxt_credit_cnt = credit_cnt;
    endcase
end

always @(posedge clk or negedge rstn) begin
    if(~rstn) begin
        credit_cnt <= 0;
    end else begin
        credit_cnt <= nxt_credit_cnt;
    end
end


//--------------------------------------------------------------------
//                  Output VC Availability Control
//--------------------------------------------------------------------
always @(posedge clk or negedge rstn) begin
    if(~rstn) begin
        outVCAvailable <= 1;
    end else begin
        if(outVCAvailableReset) begin
            outVCAvailable <= 0;
        end
        else if((flit_header == `TAIL) & valid) begin
            outVCAvailable <= 1;
        end
    end
end

endmodule