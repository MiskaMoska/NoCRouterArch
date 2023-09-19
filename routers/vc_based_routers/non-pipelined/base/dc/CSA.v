module CSA #(
    parameter width = 8
)(
    input   wire    [width-1:0]     x,
    input   wire    [width-1:0]     y,
    input   wire    [width-1:0]     cin,

    output  wire    [width-1:0]     s,
    output  wire    [width-1:0]     cout
);

generate
    genvar i;
    for(i=0; i<width; i=i+1) begin: gen_block
        assign s[i] = x[i] ^ y[i] ^ cin[i];
        assign cout[i] = x[i]&y[i] | (x[i] ^ y[i]) & cin[i];
        // assign {cout[i], s[i]} = x[i] + y[i] + cin[i];
    end
endgenerate

endmodule