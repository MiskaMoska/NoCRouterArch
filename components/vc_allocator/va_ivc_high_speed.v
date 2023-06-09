/****************************************************************************
 *   Copyright (c) 2023 Wenxu Cao
 *  
 *   Filename:         va_ivc_high_speed.v
 *   Institution:      UESTC
 *   Author:           Wenxu Cao
 *   Version:          1.0
 *   Date:             2023-06-08
 *
 *   Description:      This is the input VC stage of the VC allocator.
 *                     Presented in the grey block in Fig.7.14 @ P-128.
 *
 *   Annotation:       This local arbitration step is for cases where one 
 *                     input VC may request multiple output VCs, if you can 
 *                     ensure that one input VC only request one output VC 
 *                     once, it means that the masked VC request signals are
 *                     natural one-hot codes, then this step can be omitted. 
 *                     If the masked VC request signals are not one-hot codes 
 *                     and you don't want local arbitration, then you can use 
 *                     a wave-front allocator to replace the multi-arbiter-
 *                     combined main allocator.
 *
*****************************************************************************/