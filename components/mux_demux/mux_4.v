/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         mux_4.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-08
 *   Description:      This is a basic 4-way mutiplexor
 *
*****************************************************************************/

module mux_4 #(
    parameter       DATA_WIDTH = 4
)(
    input       wire        [3:0]                   sel

    input       wire        [DATA_WIDTH-1 : 0]      data_i_0,       
    input       wire        [DATA_WIDTH-1 : 0]      data_i_1,       
    input       wire        [DATA_WIDTH-1 : 0]      data_i_2,       
    input       wire        [DATA_WIDTH-1 : 0]      data_i_3,

    output      wire        [DATA_WIDTH-1 : 0]      data_o      
);

reg [DATA_WIDTH-1 : 0] _data_o;

always_comb begin
    case(sel)
        4'b0001:        _data_o = data_i_0;
        4'b0010:        _data_o = data_i_1;
        4'b0100:        _data_o = data_i_2;
        4'b1000:        _data_o = data_i_3;
        default:        _data_o = 0;
    endcase
end

assign data_o = _data_o;

endmodule