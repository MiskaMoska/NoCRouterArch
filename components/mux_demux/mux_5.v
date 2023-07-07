/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         mux_5.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-08
 *   Description:      This is a basic 5-way multiplexor
 *
*****************************************************************************/

module mux_5 #(
    parameter       DATA_WIDTH = 4
)(
    input       wire        [4:0]                   sel,

    input       wire        [DATA_WIDTH-1 : 0]      data_i_0,       
    input       wire        [DATA_WIDTH-1 : 0]      data_i_1,       
    input       wire        [DATA_WIDTH-1 : 0]      data_i_2,       
    input       wire        [DATA_WIDTH-1 : 0]      data_i_3,       
    input       wire        [DATA_WIDTH-1 : 0]      data_i_4, 

    output      wire        [DATA_WIDTH-1 : 0]      data_o      
);

reg [DATA_WIDTH-1 : 0] _data_o;

always@(*) begin
    case(sel)
        5'b00001:       _data_o = data_i_0;
        5'b00010:       _data_o = data_i_1;
        5'b00100:       _data_o = data_i_2;
        5'b01000:       _data_o = data_i_3;
        5'b10000:       _data_o = data_i_4;
        default:        _data_o = 0;
    endcase
end

assign data_o = _data_o;

endmodule