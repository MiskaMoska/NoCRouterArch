# logic_library
#               --> link_library(工艺库) 
#                                        --> target_library(标准单元库) --> base (base cell)      --> HVT/RVT/LVT/SLVT --> NLDMs/CCS
#                                                                      --> PMK  (low power cell) --> HVT/RVT/LVT/SLVT --> NLDMs/CCS
#                                                                      --> ECO                   --> HVT/RVT/LVT/SLVT --> NLDMs/CCS
#                                        --> others : memory/IO/PHY/hardcore
#               --> generic_library    
#                                        --> symbol_library
#                                        --> synthetic_library : standard.sldb(HDL运算符) dw_foundation.sldb(DW库)

echo "*** Set Technology library ***"

set DB_LIB             "/eda/lib/SCC011UMS_UHD_RVT_V1p0/liberty/1.2v"
set MEM_DB_LIB         "/eda/mmcomp"
set SYMBOL_LIB         "/eda/lib/SCC011UMS_UHD_RVT_V1p0/symbol"
set DW_LIB             "/eda/dc/libraries/syn"

set search_path        "$search_path $DB_LIB $SYMBOL_LIB $DW_LIB $MEM_DB_LIB"

# sc:standard cell; 011u:.11um; hd:high density; rvt:regular voltage threshold; ss:worst corner; v1p08:voltage1.08V; 125C:temperature 125; basic:basic library
set target_library     "scc011ums_uhd_rvt_ss_v1p08_125c_basic.db"
set link_library       "* scc011ums_uhd_rvt_ss_v1p08_125c_basic.db standard.sldb dw_foundation.sldb gtech.db"
set symbol_library     "scc011ums_uhd_rvt.sdb"
set synthetic_library  "standard.sldb dw_foundation.sldb"

set verilogout_show_unconnected_pins
set enable_recovery_removal_arcs true

suppress_message [list VER-130 VER-129 VER-318 VER-936 ELAB-311] 

# 开辟内存空间，用来存储中间的文件
define_design_lib WORK -path "../temp_lib"

