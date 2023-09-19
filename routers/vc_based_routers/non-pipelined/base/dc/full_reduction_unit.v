// this is for parallel prefix round robin arbiter

module full_reduction_unit(
    input   GPA, GRA, GPB, GRB,
    output  GPO, GRO
);

assign GPO = GPA | (GRA & GPB);
assign GRO = GRA & GRB;
    
endmodule