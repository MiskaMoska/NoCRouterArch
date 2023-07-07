/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         vc_replacement.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-09
 *
 *   Description:      This is a VC replacement unit for cross VC traverse.
 *
*****************************************************************************/
`include    "params.vh"

module vc_replacement(
    input   wire        [`V-1 : 0]      selOutVC,
    input   wire        [`DW-1 : 0]     data_i,
    output  reg         [`DW-1 : 0]     data_o
);  

function [1:0] encode(input [3:0] in);
    reg [1:0] res;
    begin
        case(in)
            4'b0001: res = 2'b00;
            4'b0010: res = 2'b01;
            4'b0100: res = 2'b10;
            4'b1000: res = 2'b11;
            default: res = 2'b00;
        endcase
        encode = res;
    end
endfunction

always@(*) begin
    data_o = data_i;
    if (data_i[`DW-1 : `DW-2] == `HEAD)
        data_o[`DW-1 : `DW-2] = encode(selOutVC);
end

endmodule