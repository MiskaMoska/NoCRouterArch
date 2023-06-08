# for i in range(5):
#     for j in range(4):    
# #         print(f'''
# # mux_5 #(`V) out_avail_mux_p{i}_vc{j}(
# #     reqPort_from_P{i}_VC{j},
# #     outVCAvailable_P0,
# #     outVCAvailable_P1,
# #     outVCAvailable_P2,
# #     outVCAvailable_P3,
# #     outVCAvailable_P4,
# #     outVCAvailable_to_P{i}_VC{j}
# # );''')
#         print(f"arbiter #(`V) local_arb_(clk, rstn, masked_reqVC_from_P{i}_VC{j}, onehot_reqVC_from_P{i}_VC{j});")


# for i in range(5):
#     for j in range(4):
#         for m in range(4):
#             print(f'''
# demux_5 #(1) demux_at_P{i}_VC{j}_for_reqVC{m}(
#     reqPort_from_P{i}_VC{j}
#     onehot_reqVC_from_P{i}_VC{i}[{m}],
#     req_P0_VC{m}_from_P{i}_VC{i},
#     req_P1_VC{m}_from_P{i}_VC{i},
#     req_P2_VC{m}_from_P{i}_VC{i},
#     req_P3_VC{m}_from_P{i}_VC{i},
#     req_P4_VC{m}_from_P{i}_VC{i}
# );''')

for i in range(20):
    print(
    f'''
assign output_{i} = <<
    input_19[{i}], 
    input_18[{i}],
    input_17[{i}],
    input_16[{i}],
    input_15[{i}],
    input_14[{i}],
    input_13[{i}],
    input_12[{i}],
    input_11[{i}],
    input_10[{i}],
    input_9[{i}],
    input_8[{i}],
    input_7[{i}],
    input_6[{i}],
    input_5[{i}],
    input_4[{i}],
    input_3[{i}],
    input_2[{i}],
    input_1[{i}],
    input_0[{i}]
>>;''')