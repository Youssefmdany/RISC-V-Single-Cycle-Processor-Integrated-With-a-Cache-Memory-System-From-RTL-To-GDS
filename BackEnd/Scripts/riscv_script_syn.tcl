 # -------------------------- Setup_file -------------------------- # 

# ----------- Search_path
set search_path "/home/ICer/Library_cells"


set_app_var link_library "* saed32hvt_ff0p95v125c.db    saed32hvt_ff1p16vn40c.db" 

set_app_var target_library "saed32hvt_ff0p95v125c.db    saed32hvt_ff1p16vn40c.db"


# ---------- Work_dir
sh rm -rf work
sh mkdir -p work
define_design_lib work -path ./work

# ---------- Assign Top module in Variable design 
set design RISCV_Top



# -------------------- Read_file -----------------#
# analyze -library work -format verilog /${design}.v
# elaborate $design -lib work



read_verilog ../RTL/ALU.v
read_verilog ../RTL/Cache_Contrl.v
read_verilog ../RTL/Cache_Memory.v
read_verilog ../RTL/Control_Unit.v
read_verilog ../RTL/Data_mem.v
read_verilog ../RTL/Data_Memory_System.v
read_verilog ../RTL/imm_gen.v
read_verilog ../RTL/instr_mem.v
read_verilog ../RTL/PC.v
read_verilog ../RTL/reg_file.v
read_verilog ../RTL/RISCV.v
read_verilog ../RTL/RISCV_Top.v


set TOP_LEVEL_DESIGN "RISCV_Top"


# --------------- Define_Current_Top_Design --------------- #  
current_design  $TOP_LEVEL_DESIGN

# --------------- linking  --------------- # 
link

# --------------- Checking  --------------- # 
check_design

# ------- Constarints_file ---------- #
source ./riscv_constraint.tcl  


# -------------- Compiling ----------------- #   
compile -map_effort high ; #Mappig and oPtimization 
# --------------- Outputs ----------------- #
# -------- Launch_GUI 
start_gui
# ---------- Gate Level Netlist {.v , .ddc } (direct design compiler) 
write -hierarchy -format verilog -output ../output/${design}.v 
write -f ddc -hierarchy -output ../output/${design}.ddc   

# ---------- SDC(Synopsys Design Constraints) File
write_sdc  ../output/${design}.sdc 
 
# ---------- SDF(Standard Delay Format) File
write_sdf ../output/${design}.sdf

# ----------- Reports ----------- #  
report_area > ../output/report/synth_area.rpt
report_cell > ../output/report/synth_cells.rpt
report_qor  > ../output/report/synth_qor.rpt
report_resources > ../output/report/synth_resources.rpt
report_timing -max_paths 10 > ../output/report/synth_timing.rpt 


