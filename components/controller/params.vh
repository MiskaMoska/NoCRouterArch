/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         params.vh
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-07-06
 *
 *   Description:      This is the header file for parameter declaration.
 *
*****************************************************************************/
`ifndef             _PARAMS_VH_
`define             _PARAMS_VH_

`define             V                           4 // fixed, don't touch
`define             N                           5 // fixed, don't touch
`define             DW                          64 
`define             BUF_DEPTH                   16        
`define             BUF_DEPTH_LOG               4        
`define             CREDIT_LBOUND               1       
`define             HEAD                        2'b00
`define             BODY                        2'b01
`define             TAIL                        2'b11

`endif
