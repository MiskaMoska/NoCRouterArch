// parallel prefix round robin arbiter following end-around-carry approach

`define PPA
`define PSPPA

module rra(
    input clk, rstn,
    input [7:0] req,
    output [7:0] grant
);

reg [7:0] p;
wire any_grant;

always @(posedge clk or negedge rstn) begin
    if(~rstn) begin
        p <= 1;
    end else begin
        if (any_grant) begin
            p <= {p[6:0],p[7]};
        end
    end
end

`ifdef PPA
wire [7:0] r;
wire [7:0] redu_s1_gp, redu_s1_gr, redu_s2_gp, redu_s2_gr, redu_s3_gp, redu_s3_gr;
wire [7:0] x;

assign r = {req[6:0], req[7]};

/* Stage 1 */
full_reduction_unit fru_s1_b7(p[7], ~r[6], p[6], ~r[5], redu_s1_gp[7], redu_s1_gr[7]);
full_reduction_unit fru_s1_b6(p[6], ~r[5], p[5], ~r[4], redu_s1_gp[6], redu_s1_gr[6]);
full_reduction_unit fru_s1_b5(p[5], ~r[4], p[4], ~r[3], redu_s1_gp[5], redu_s1_gr[5]);
full_reduction_unit fru_s1_b4(p[4], ~r[3], p[3], ~r[2], redu_s1_gp[4], redu_s1_gr[4]);
full_reduction_unit fru_s1_b3(p[3], ~r[2], p[2], ~r[1], redu_s1_gp[3], redu_s1_gr[3]);
full_reduction_unit fru_s1_b2(p[2], ~r[1], p[1], ~r[0], redu_s1_gp[2], redu_s1_gr[2]);
full_reduction_unit fru_s1_b1(p[1], ~r[0], p[0], ~r[7], redu_s1_gp[1], redu_s1_gr[1]);

assign redu_s1_gp[0] = p[0];
assign redu_s1_gr[0] = ~r[0];

/* Stage 2 */
full_reduction_unit fru_s2_b7(redu_s1_gp[7], redu_s1_gr[7], redu_s1_gp[5], redu_s1_gr[5], redu_s2_gp[7], redu_s2_gr[7]);
full_reduction_unit fru_s2_b6(redu_s1_gp[6], redu_s1_gr[6], redu_s1_gp[4], redu_s1_gr[4], redu_s2_gp[6], redu_s2_gr[6]);
full_reduction_unit fru_s2_b5(redu_s1_gp[5], redu_s1_gr[5], redu_s1_gp[3], redu_s1_gr[3], redu_s2_gp[5], redu_s2_gr[5]);
full_reduction_unit fru_s2_b4(redu_s1_gp[4], redu_s1_gr[4], redu_s1_gp[2], redu_s1_gr[2], redu_s2_gp[4], redu_s2_gr[4]);
full_reduction_unit fru_s2_b3(redu_s1_gp[3], redu_s1_gr[3], redu_s1_gp[1], redu_s1_gr[1], redu_s2_gp[3], redu_s2_gr[3]);
full_reduction_unit fru_s2_b2(redu_s1_gp[2], redu_s1_gr[2], redu_s1_gp[0], redu_s1_gr[0], redu_s2_gp[2], redu_s2_gr[2]);

assign redu_s2_gp[1] = redu_s1_gp[1];
assign redu_s2_gr[1] = redu_s1_gr[1];
assign redu_s2_gp[0] = redu_s1_gp[0];
assign redu_s2_gr[0] = redu_s1_gr[0];


/* Stage 3 */
full_reduction_unit fru_s3_b7(redu_s2_gp[7], redu_s2_gr[7], redu_s2_gp[3], redu_s2_gr[3], redu_s3_gp[7], redu_s3_gr[7]);
full_reduction_unit fru_s3_b6(redu_s2_gp[6], redu_s2_gr[6], redu_s2_gp[2], redu_s2_gr[2], redu_s3_gp[6], redu_s3_gr[6]);
full_reduction_unit fru_s3_b5(redu_s2_gp[5], redu_s2_gr[5], redu_s2_gp[1], redu_s2_gr[1], redu_s3_gp[5], redu_s3_gr[5]);
full_reduction_unit fru_s3_b4(redu_s2_gp[4], redu_s2_gr[4], redu_s2_gp[0], redu_s2_gr[0], redu_s3_gp[4], redu_s3_gr[4]);

assign redu_s3_gp[3] = redu_s2_gp[3];
assign redu_s3_gr[3] = redu_s2_gr[3];
assign redu_s3_gp[2] = redu_s2_gp[2];
assign redu_s3_gr[2] = redu_s2_gr[2];
assign redu_s3_gp[1] = redu_s2_gp[1];
assign redu_s3_gr[1] = redu_s2_gr[1];
assign redu_s3_gp[0] = redu_s2_gp[0];
assign redu_s3_gr[0] = redu_s2_gr[0];

/* Stage 4 */
assign x[7] = redu_s3_gp[7];
half_reduction_unit hru_s4_6(redu_s3_gp[6], redu_s3_gr[6], x[7], x[6]);
half_reduction_unit hru_s4_5(redu_s3_gp[5], redu_s3_gr[5], x[7], x[5]);
half_reduction_unit hru_s4_4(redu_s3_gp[4], redu_s3_gr[4], x[7], x[4]);
half_reduction_unit hru_s4_3(redu_s3_gp[3], redu_s3_gr[3], x[7], x[3]);
half_reduction_unit hru_s4_2(redu_s3_gp[2], redu_s3_gr[2], x[7], x[2]);
half_reduction_unit hru_s4_1(redu_s3_gp[1], redu_s3_gr[1], x[7], x[1]);
half_reduction_unit hru_s4_0(redu_s3_gp[0], redu_s3_gr[0], x[7], x[0]);

/* Output */
assign grant = x & req;
assign any_grant = ~redu_s3_gr[7];

`else 

`ifdef PSPPA

wire [7:0] x;
wire [7:0] nr;

assign nr = ~req;

assign x[0] =   p[0] + 
                (& nr[7:1]) & p[1] +
                (& nr[7:2]) & p[2] +
                (& nr[7:3]) & p[3] +
                (& nr[7:4]) & p[4] +
                (& nr[7:5]) & p[5] +
                (& nr[7:6]) & p[6] +
                nr[7] & p[7];

assign x[1] =   p[1] +
                (& nr[7:2]) & nr[0] & p[2] +
                (& nr[7:3]) & nr[0] & p[3] +
                (& nr[7:4]) & nr[0] & p[4] +
                (& nr[7:5]) & nr[0] & p[5] +
                (& nr[7:6]) & nr[0] & p[6] +
                nr[7] & nr [0] & p[7] +
                nr[0] & p[0];

assign x[2] =   p[2] +
                (& nr[7:3]) & (& nr[1:0]) & p[3] +
                (& nr[7:4]) & (& nr[1:0]) & p[4] +
                (& nr[7:5]) & (& nr[1:0]) & p[5] +
                (& nr[7:6]) & (& nr[1:0]) & p[6] +
                nr[7] & (& nr[1:0]) & p[7] +
                (& nr[1:0]) & p[0] +
                nr[1] & p[1];

assign x[3] =   p[3] +
                (& nr[7:4]) & (& nr[2:0]) & p[4] +
                (& nr[7:5]) & (& nr[2:0]) & p[5] +
                (& nr[7:6]) & (& nr[2:0]) & p[6] +
                nr[7] & (& nr[2:0]) & p[7] +
                (& nr[2:0]) & p[0] +
                (& nr[2:1]) & p[1] +
                nr[2] & p[2];

assign x[4] =   p[4] +
                (& nr[7:5]) & (& nr[3:0]) & p[5] +
                (& nr[7:6]) & (& nr[3:0]) & p[6] +
                nr[7] & (& nr[3:0]) & p[7] +
                (& nr[3:0]) & p[0] +
                (& nr[3:1]) & p[1] +
                (& nr[3:2]) & p[2] +
                nr[3] & p[3];

assign x[5] =   p[5] +
                (& nr[7:6]) & (& nr[4:0]) & p[6] +
                nr[7] & (& nr[4:0]) & p[7] +
                (& nr[4:0]) & p[0] +
                (& nr[4:1]) & p[1] +
                (& nr[4:2]) & p[2] +
                (& nr[4:3]) & p[3] +
                nr[4] & p[4];

assign x[6] =   p[6] +
                nr[7] & (& nr[5:0]) & p[7] +
                (& nr[5:0]) & p[0] +
                (& nr[5:1]) & p[1] +
                (& nr[5:2]) & p[2] +
                (& nr[5:3]) & p[3] +
                (& nr[5:4]) & p[4] +
                nr[5] & p[5];

assign x[7] =   p[7] +
                (& nr[6:0]) & p[0] +
                (& nr[6:1]) & p[1] +
                (& nr[6:2]) & p[2] +
                (& nr[6:3]) & p[3] +
                (& nr[6:4]) & p[4] +
                (& nr[6:5]) & p[5] +
                nr[6] & p[6];

assign grant = x & req;

`else

wire [15:0] d_req, d_grant;
assign d_req = {req,req};
assign d_grant = d_req & (~d_req+p);
assign grant = d_grant[15:8] | d_grant[7:0];

`endif

assign any_grant = |grant;

`endif
endmodule