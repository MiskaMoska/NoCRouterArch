#记录DC过程中对RTL做的修改，给后面形式验证等step提供
set_svf "read_rtl.svf"

#set TOP_LEVEL rr
set TOP_LEVEL rra

#读入RTL，语法分析
# analyze -f verilog -vcs +incdir+/mnt/f/git/NoCRouterArch/components/controller {
#     /mnt/f/git/NoCRouterArch/components/arbiter/mtx_arbiter.v
#     /mnt/f/git/NoCRouterArch/components/controller/input_vc_controller_base.v
#     /mnt/f/git/NoCRouterArch/components/controller/output_vc_controller_base.v
#     /mnt/f/git/NoCRouterArch/components/crossbar/xb_iport.v
#     /mnt/f/git/NoCRouterArch/components/crossbar/xb_main.v
#     /mnt/f/git/NoCRouterArch/components/fifo/fifo.v
#     /mnt/f/git/NoCRouterArch/components/mux_demux/mux_4.v
#     /mnt/f/git/NoCRouterArch/components/mux_demux/mux_5.v
#     /mnt/f/git/NoCRouterArch/components/mux_demux/demux_4.v
#     /mnt/f/git/NoCRouterArch/components/mux_demux/demux_5.v
#     /mnt/f/git/NoCRouterArch/components/routing_computation/rc.v
#     /mnt/f/git/NoCRouterArch/components/switch_allocator/sa_iport.v
#     /mnt/f/git/NoCRouterArch/components/switch_allocator/sa_main.v
#     /mnt/f/git/NoCRouterArch/components/transpose/transpose_5.v
#     /mnt/f/git/NoCRouterArch/components/transpose/transpose_20.v
#     /mnt/f/git/NoCRouterArch/components/utils/vc_replacement.v
#     /mnt/f/git/NoCRouterArch/components/vc_allocator/va_ivc_low_cost.v
#     /mnt/f/git/NoCRouterArch/components/vc_allocator/va_main.v
#     ../../rtl/input_port_stage.v
#     ../../rtl/output_port_stage.v
#     ../../rtl/router.v
# }

# for multiplier
# analyze -f verilog {../FA.v ../CSA.v ../adder_16bit.v ../multiplier.v}

# for rra
analyze -f verilog {../rra.v ../full_reduction_unit.v ../half_reduction_unit.v}

#构建层次关系
elaborate rra > ../rpt/elaborate.log

current_design rra

#检查综合工程中是否缺少子模块
# link

# if {[link] == 0} {
#     #echo "Link Error"
#     exit
# }

#例化模块的名字修改
uniquify

#网表中可能存在assign语句，这会对布局布线产生影响,可能原因有：1.多个输出port连接在一个内部net上; 2.从输入port不经过任何逻辑直接到输出port上; 3.三态门引起的assign
#为了解决1和2，可以在综合前使用如下语句
set_fix_multiple_port_nets -all -buffer_constants

check_design > ../rpt/check_design.log

#GTECH网表
write -f verilog -hier -output ../out/${TOP_LEVEL}_pre.v
write -f ddc -hier -output ../out/${TOP_LEVEL}_pre.ddc
