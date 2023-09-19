module FA (
    input   wire     x,
    input   wire     y,
    input   wire     cin,

    output  wire     s,
    output  wire     cout
);

assign s = x ^ y ^ cin;
assign cout = x & y | (x ^ y) & cin;

endmodule