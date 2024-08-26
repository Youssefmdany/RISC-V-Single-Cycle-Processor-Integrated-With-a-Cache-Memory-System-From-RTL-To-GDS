# 1- open block and copy
open_block /home/ICer/ASIC/RISCV/pnr/setup/RISCV_Top.dlib:RISCV_Top.design
copy_block -from_block RISCV_Top.dlib:RISCV_Top.design -to_block FloorPlanning
current_block FloorPlanning.design
# 2- set_parasitic_parameters
set_parasitic_parameters -late_spec maxTLU   -early_spec minTLU
# 3- initialize_floorplan
initialize_floorplan -core_utilization 0.6 -side_ratio {1 1}
# 4- set_app_options 
set_app_options -name place.coarse.fix_hard_macros -value false
# 5- set_app_options
set_app_options -name plan.place.auto_create_blockages -value auto
# 6-  create_placement
create_placement -floorplan
# 7- pins_constraint
create_block_pin_constraint -allowed_layers {M3 M4 M5 M6}
set_app_options -name plan.pins.incremental -value false -block [current_block]
place_pins -self
check_pg_drc
# 8- save block
save_block -as FloorPlanning RISCV_Top.dlib:FloorPlanning.design
write_verilog   /home/ICer/ASIC/RISCV/pnr/FloorPlanning/FloorPlanning_Netlist.v
# 9- close block
#close_blocks -force -purge power_plan
