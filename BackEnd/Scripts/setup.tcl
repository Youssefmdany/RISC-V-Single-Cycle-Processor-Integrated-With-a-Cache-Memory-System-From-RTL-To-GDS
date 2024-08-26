# put the search path directory of the technology 
set_app_var search_path /home/ICer/Library_cells
set TECH_FILE $search_path/saed32nm_1p9m_mw.v10.tf
# put the directory of your ndm created from the library manager #saed.ndm folder not file
set reference_library { /home/ICer/ASIC/RISCV/pnr/ndm/saed32hvt_ff_c.ndm}
#create design library from technology file & ndm
create_lib -technology $TECH_FILE -ref_libs $reference_library RISCV_Top.dlib
#read gate level netlist output from synthesis
read_verilog  /home/ICer/ASIC/RISCV/output/RISCV_Top.v
link_block
#.map as same as .tf 
#.tluplus 
read_parasitic_tech -layermap saed32nm_tf_itf_tluplus.map -tlup saed32nm_1p9m_Cmax.tluplus  -name maxTLU
read_parasitic_tech -layermap saed32nm_tf_itf_tluplus.map -tlup saed32nm_1p9m_Cmin.tluplus -name minTLU
#put the sdc file output from synthesis
read_sdc /home/ICer/ASIC/RISCV/output/RISCV_Top.sdc
get_site_defs

set_attribute [get_site_defs unit] symmetry y
set_attribute [get_layers {M1 M3 M5 M7 M9} ] routing_direction horizontal
set_attribute [get_layers {M2 M4 M6 M8 } ] routing_direction vertical
get_attribute [get_layers M7] routing_direction
report_ignored_layers
set_ignored_layers -max_routing_layer M8
report_ignored_layers
save_block -as RISCV_Top RISCV_Top.dlib:RISCV_Top.design
start_gui
