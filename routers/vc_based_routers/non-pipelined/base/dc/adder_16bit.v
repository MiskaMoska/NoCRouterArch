module adder_16bit(
    input   [15:0] a, b,
    output  [15:0] s
);

wire    [15:0]      cout;

FA csa0 (a[0], b[0], 1'b0, s[0], cout[0]);
FA csa1 (a[1], b[1], cout[0], s[1], cout[1]);
FA csa2 (a[2], b[2], cout[1], s[2], cout[2]);
FA csa3 (a[3], b[3], cout[2], s[3], cout[3]);
FA csa4 (a[4], b[4], cout[3], s[4], cout[4]);
FA csa5 (a[5], b[5], cout[4], s[5], cout[5]);
FA csa6 (a[6], b[6], cout[5], s[6], cout[6]);
FA csa7 (a[7], b[7], cout[6], s[7], cout[7]);
FA csa8 (a[8], b[8], cout[7], s[8], cout[8]);
FA csa9 (a[9], b[9], cout[8], s[9], cout[9]);
FA csa10 (a[10], b[10], cout[9], s[10], cout[10]);
FA csa11 (a[11], b[11], cout[10], s[11], cout[11]);
FA csa12 (a[12], b[12], cout[11], s[12], cout[12]);
FA csa13 (a[13], b[13], cout[12], s[13], cout[13]);
FA csa14 (a[14], b[14], cout[13], s[14], cout[14]);
FA csa15 (a[15], b[15], cout[14], s[15], cout[15]);

endmodule