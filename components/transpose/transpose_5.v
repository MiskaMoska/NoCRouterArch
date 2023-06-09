/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         transpose_5.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-08
 *   Description:      This is a matrix transpose unit.
 *
*****************************************************************************/

module transpose_5(
    input       wire        [4 : 0]        input_0,
    input       wire        [4 : 0]        input_1,
    input       wire        [4 : 0]        input_2,
    input       wire        [4 : 0]        input_3,
    input       wire        [4 : 0]        input_4

    output      wire        [4 : 0]        output_0,
    output      wire        [4 : 0]        output_1,
    output      wire        [4 : 0]        output_2,
    output      wire        [4 : 0]        output_3,
    output      wire        [4 : 0]        output_4
);

assign output_0 = {
    input_4[0],
    input_3[0],
    input_2[0],
    input_1[0],
    input_0[0]
};

assign output_1 = {
    input_4[1],
    input_3[1],
    input_2[1],
    input_1[1],
    input_0[1]
};

assign output_2 = {
    input_4[2],
    input_3[2],
    input_2[2],
    input_1[2],
    input_0[2]
};

assign output_3 = {
    input_4[3],
    input_3[3],
    input_2[3],
    input_1[3],
    input_0[3]
};

assign output_4 = {
    input_4[4],
    input_3[4],
    input_2[4],
    input_1[4],
    input_0[4]
};

endmodule