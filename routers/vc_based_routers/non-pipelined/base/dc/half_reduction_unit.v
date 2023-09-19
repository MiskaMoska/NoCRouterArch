// this is for parallel prefix round robin arbiter

module half_reduction_unit(
    input   GPA, GRA, GPB,
    output  GPO
);

assign GPO = GPA | (GRA & GPB);
    
endmodule