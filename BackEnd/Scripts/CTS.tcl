copy_block -from_block RISCV_Top.dlib:Placement.design -to_block CTS

current_block CTS.design

check_design -checks pre_clock_tree_stage

report_clock_qor -type structure

derive_clock_cell_references -output cts_leg_set.tcl > /dev/null


set CTS_CELLS [get_lib_cells "*/NBUFF*"]


#NDR

set CTS_NDR_MIN_ROUTING_LAYER	"M4"
set CTS_NDR_MAX_ROUTING_LAYER	"M5"
set CTS_LEAF_NDR_MIN_ROUTING_LAYER	"M1"
set CTS_LEAF_NDR_MAX_ROUTING_LAYER	"M5"
set CTS_NDR_RULE_NAME 		"cts_w2_s2_vlg"
#set CTS_LEAF_NDR_RULE_NAME	"cts_w1_s2"

create_routing_rule $CTS_NDR_RULE_NAME\
		-default_reference_rule \
		-taper_distance 0.4 \
		-driver_taper_distance 0.4 \
  	 	-widths   {M3 0.16 M4 0.32 M5 0.32} \
  	 	-spacings {M3 0.16 M4 0.32 M5 0.32}
                

set_clock_routing_rules -rules $CTS_NDR_RULE_NAME \
		-min_routing_layer $CTS_NDR_MIN_ROUTING_LAYER \
		-max_routing_layer $CTS_NDR_MAX_ROUTING_LAYER
		
report_routing_rules -verbose

report_clock_routing_rules

#Sink pins will not follows NDRs
set_clock_routing_rules -net_type sink -default_rule -min_routing_layer M1 -max_routing_layer M2

#DRC 
report_ports -verbose [get_ports *clk*]
set_driving_cell -scenarios [all_scenarios] -lib_cell NBUFFX4_HVT [get_ports *clk*]


set_app_options -name time.remove_clock_reconvergence_pessimism -value true
report_clock_settings

#
set_clock_tree_options -target_skew 0.5 -clock [get_clocks *]
set_clock_tree_options -target_latency 0.1  -clock [get_clocks *]


#clock_opt


clock_opt -from build_clock -to build_clock

check_pg_drc 


clock_opt -from build_clock -to route_clock 

check_pg_drc 

clock_opt -from route_clock -to final_opto

check_pg_drc 



# Save Netlist


write_verilog   /home/ICer/ASIC/RISCV/pnr/CTS/CTS_netlist.v


#save block


#save_block -as RISCV_Top RISCV_Top.dlib:RISCV_Top.design


# Export Reports

report_cell > /home/ICer/ASIC/RISCV/pnr/CTS/CTS_cells.rpt

report_qor  > /home/ICer/ASIC/RISCV/pnr/CTS/CTS_qor.rpt

report_timing -max_paths 10 > /home/ICer/ASIC/RISCV/pnr/CTS/CTS_timing.rpt

report_timing -delay min -max_paths 10 > /home/ICer/ASIC/RISCV/pnr/CTS/CTS_timing_hold.rpt

check_legality -verbose > /home/ICer/ASIC/RISCV/pnr/CTS/CTS_legalization.rpt

report_utilization > /home/ICer/ASIC/RISCV/pnr/CTS/CTS_legalization.rpt

report_routing_rules -verbose > /home/ICer/ASIC/RISCV/pnr/CTS/CTS_routing_rules.rpt

report_clock_routing_rules > /home/ICer/ASIC/RISCV/pnr/CTS/CTS_Clock_routing_rules.rpt

report_ports -verbose [get_ports *clk*] > /home/ICer/ASIC/RISCV/pnr/CTS/CTS_ports.rpt

report_clock_settings > /home/ICer/ASIC/RISCV/pnr/CTS/CTS_clk_setting.rpt

