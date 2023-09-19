source ../scripts/setup.tcl

echo "*** Reading Design ***"
source -echo -v ../scripts/read_rtl.tcl > ../rpt/read_rtl.log

echo "*** Constrainting Design ***"
source -echo -v ../scripts/constrains.tcl > ../rpt/constrains.log

check_design
check_timing

compile

source ../scripts/report.tcl