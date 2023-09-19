`define WALLACE

module multiplier(
    input   clk,
    input   rstn,
    input   [7:0] ai, bi,
    output  reg [15:0] po
);

wire [7:0] c0,c1,c2,c3,c4,c5,c6,c7;
reg [7:0] a, b;
wire [15:0] p;

assign c0 = b[0] ? a : 'b0;
assign c1 = b[1] ? a : 'b0;
assign c2 = b[2] ? a : 'b0;
assign c3 = b[3] ? a : 'b0;
assign c4 = b[4] ? a : 'b0;
assign c5 = b[5] ? a : 'b0;
assign c6 = b[6] ? a : 'b0;
assign c7 = b[7] ? a : 'b0;

`ifdef WALLACE

wire [15:0] s_0_0, cout_0_0;
wire [15:0] s_0_1, cout_0_1;
wire [15:0] s_1_0, cout_1_0;
wire [15:0] s_1_1, cout_1_1;
wire [15:0] s_2_0, cout_2_0;
wire [15:0] s_3_0, cout_3_0;

CSA #(16) csa_0_0((c0)|16'd0, (c1<<1)|16'd0, (c2<<2)|16'd0, s_0_0, cout_0_0);
CSA #(16) csa_0_1((c3<<3)|16'd0, (c4<<4)|16'd0, (c5<<5)|16'd0, s_0_1, cout_0_1);
CSA #(16) csa_1_0((s_0_0)|16'd0, (cout_0_0<<1)|16'd0, (s_0_1)|16'd0, s_1_0, cout_1_0);
CSA #(16) csa_1_1((cout_0_1<<1)|16'd0, (c6<<6)|16'd0, (c7<<7)|16'd0, s_1_1, cout_1_1);
CSA #(16) csa_2_0((s_1_0)|16'd0, (cout_1_0<<1)|16'd0, (s_1_1)|16'd0, s_2_0, cout_2_0);
CSA #(16) csa_3_0((s_2_0)|16'd0, (cout_2_0<<1)|16'd0, (cout_1_1<<1)|16'd0, s_3_0, cout_3_0);
adder_16bit add1(s_3_0|16'd0, (cout_3_0<<1)|16'd0, p);
// assign p = s_3_0 + (cout_3_0<<1);

`else

wire [15:0] s1,s2,s3,s4,s5,s6,s7;

// adder_16bit add1(c0|16'd0, c1|16'd0, s1);
// adder_16bit add2(s1, c2|16'd0, s2);
// adder_16bit add3(s2, c3|16'd0, s3);
// adder_16bit add4(s3, c4|16'd0, s4);
// adder_16bit add5(s4, c5|16'd0, s5);
// adder_16bit add6(s5, c6|16'd0, s6);
// adder_16bit add7(s6, c7|16'd0, s7);

adder_16bit add1(c0|16'd0, c1|16'd0, s1);
adder_16bit add2(c2|16'd0, c3|16'd0, s2);
adder_16bit add3(c4|16'd0, c5|16'd0, s3);
adder_16bit add4(c6|16'd0, c7|16'd0, s4);
adder_16bit add5(s1|16'd0, s2|16'd0, s5);
adder_16bit add6(s3|16'd0, s4|16'd0, s6);
adder_16bit add7(s5|16'd0, s6|16'd0, s7);

assign p = s7;

`endif

always @(posedge clk or negedge rstn) begin
    if(~rstn) {a, b, po} <= 0;
    else {a, b, po} <= {ai, bi, p}; 
end

endmodule