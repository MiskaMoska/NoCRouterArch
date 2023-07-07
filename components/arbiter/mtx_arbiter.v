/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         mtx_arbiter.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-07-07
 *   Description:      This is a parameterized matrix arbiter.
 *
*****************************************************************************/

module mtx_arbiter #(
    parameter   LEN =                       3
)(
    input       wire                        clk,
    input       wire                        rstn,
    input       wire        [LEN-1:0]       request,
    output      reg         [LEN-1:0]       grant
);

integer i,j;
reg [LEN-1:0] dsbl;
reg [LEN-1:0] w [LEN-1:0]; 
// w[i][j] = 1 indicates the priority of REQi is higher than REQj
// w[i][j] = 0 indicates the priority of REQi is lower than REQj

wire update;
assign update = | grant;

always@(*) begin
    for(i=0; i<LEN; i=i+1) begin
        for(j=0; j<LEN+1; j=j+1) begin
            if(j == 0) dsbl[i] = 0;
            else if(j-1 != i) dsbl[i] = dsbl[i] | (request[j-1] & w[j-1][i]);
            else  dsbl[i] = dsbl[i];     
        end            
        grant[i] = request[i] & (~dsbl[i]);
    end
end

always@(posedge clk or negedge rstn) begin
    if(~rstn) begin
        for(i=0; i<LEN; i=i+1) begin
            for(j=0; j<LEN; j=j+1) begin
                if(i>j) w[i][j] <= 0;
                else w[i][j] <= 1;
                //after reset,REQ0 has the highest priority
            end
        end
    end else begin
        if(update) begin
            for(i=0; i<LEN; i=i+1) begin
                if(grant[i]) begin
                    for(j=0; j<LEN; j=j+1) begin
                        w[i][j] <= 0;
                        w[j][i] <= 1;
                    end
                end
            end
        end
    end
end

endmodule