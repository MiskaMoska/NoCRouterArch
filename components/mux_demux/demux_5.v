/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         demux_5.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-08
 *   Description:      This is a basic 5-way de-multiplexor
 *
*****************************************************************************/

module demux_5 #(
    parameter       DATA_WIDTH = 4
)(
    input       wire        [4:0]                   sel,

    input       wire        [DATA_WIDTH-1 : 0]      data_i,

    output      wire        [DATA_WIDTH-1 : 0]      data_o_0,       
    output      wire        [DATA_WIDTH-1 : 0]      data_o_1,       
    output      wire        [DATA_WIDTH-1 : 0]      data_o_2,       
    output      wire        [DATA_WIDTH-1 : 0]      data_o_3,
    output      wire        [DATA_WIDTH-1 : 0]      data_o_4
);

assign data_o_0 = sel[0] ? data_i : 0;
assign data_o_1 = sel[1] ? data_i : 0;
assign data_o_2 = sel[2] ? data_i : 0;
assign data_o_3 = sel[3] ? data_i : 0;
assign data_o_4 = sel[4] ? data_i : 0;

endmodule