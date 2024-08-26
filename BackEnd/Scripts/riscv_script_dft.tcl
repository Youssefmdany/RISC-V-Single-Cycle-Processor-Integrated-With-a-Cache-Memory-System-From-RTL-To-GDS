#-----------------------------------------------------------------------------
#------------------------------------DFT-------------------------------------- 
#-----------------------------------------------------------------------------


set search_path "/home/ICer/Library_cells"


set_app_var link_library "* saed32hvt_ff0p95v125c.db    saed32hvt_ff1p16vn40c.db" 

set_app_var target_library "saed32hvt_ff0p95v125c.db    saed32hvt_ff1p16vn40c.db"



# Change mode for testing   
set test_default_scan_style
set design RISCV_Top

# Read_Design
# Netlist 
read_ddc  /home/ICer/ASIC/RISCV/output/${design}.ddc
# Constraits 
read_sdc /home/ICer/ASIC/RISCV/output/${design}.sdc  

# Test_prtocol
# depend on number of scan chains 
# Create_Ports_for_Testability
for {set i 0} {$i < 12 } { incr i } {
 create_port -direction in Scan_In[$i]
 set_dft_signal -type ScanDataIn -view spec -port Scan_In[$i] 
 create_port -direction out Scan_Out[$i]
 set_dft_signal -type ScanDataOut -view spec -port Scan_Out[$i]
}
create_port -direction in { Scan_En  } 


# ----- Test_prtocol 
#For signal already connected in design (view exist)
set_dft_signal -view exist -type ScanMasterClock -timing {45 55} -port clk
set_dft_signal -view exist -type Reset -active 1 -port reset


set_dft_signal -view exist -type ScanDataIn -port risc_v/inst_data
set_dft_signal -view exist -type ScanDataIn -port ALUControl
set_dft_signal -view exist -type ScanDataIn -port MemtoReg
set_dft_signal -view exist -type ScanDataIn -port MemWrite
set_dft_signal -view exist -type ScanDataIn -port immsrc
set_dft_signal -view exist -type ScanDataIn -port ALUResult
set_dft_signal -view exist -type ScanDataIn -port immgen
set_dft_signal -view exist -type ScanDataIn -port RegWrite




#For signal not connected in design (view spec)
set_dft_signal -view spec -type ScanEnable -active 1 -port Scan_En
#Determined number of scan chin 
set_scan_configuration -chain_count 12

# ------- Report All Signals 
report_dft_signal -view exist
report_dft_signal -view spec
# -------Create_Test_protocol 
create_test_protocol
# ------------------- Drc_checking ------------------- #
dft_drc
#read_test_protocol ../results/UART_dft.spf
# To prevent uniquification of your design, enter the command:
set_dft_insertion_configuration -preserve_design_name true


# ------------------- Replaced Flip-Flops ------------------- #
# ---- Preview  
preview_dft
# ------ Scan_stitching 
insert_dft
# --- Report_scan_chains 
report_scan_path 
# -------Coverage_estimate
dft_drc -coverage_estimate 

# ------------------- Outputs ------------------- #
# --------SPF_File (STIL Protcol File) 
write_test_protocol -out /home/ICer/ASIC/RISCV/output/${design}_dft.spf
# ------- Coverage Estimation 
dft_drc -coverage_estimate > /home/ICer/ASIC/RISCV/output/report/dft_coverage.drc_coverage
# -------- Reports 
report_area > /home/ICer/ASIC/RISCV/output/report/dft_area.report
report_timing > /home/ICer/ASIC/RISCV/output/report/dft_timing.report
report_qor > /home/ICer/ASIC/RISCV/output/report/dft_qor.report
report_scan_path > /home/ICer/ASIC/RISCV/output/report/dft_scan_path.report
# --------- Netlist output (.v and .ddc )
write -format ddc -h  -o /home/ICer/ASIC/RISCV/output/${design}_dft.ddc
write -format verilog -h  -o /home/ICer/ASIC/RISCV/output/${design}_dft.v
write_sdf  /home/ICer/ASIC/RISCV/output/${design}_dft.sdf
exit
