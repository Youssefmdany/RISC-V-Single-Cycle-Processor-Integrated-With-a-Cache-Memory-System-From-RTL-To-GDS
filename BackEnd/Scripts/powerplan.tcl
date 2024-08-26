						PowerPlanning
					--------------------------------

start_gui

open_block /home/ICer/ASIC/RISCV/pnr/setup/RISCV_Top.dlib:FloorPlanning.design

# copy block to a new block to work on it

copy_block -from_block RISCV_Top.dlib:FloorPlanning.design -to_block PowerPlanning.design
current_block PowerPlanning.design

# --------------------------- PowerPlanning --------------------------- #


# --------------------------- Copy_design_optional --------------------------- #
#current_block PowerPlanning.design
current_design

# --------------------------- Remove_Layers --------------------------- #
#remove_ignored_layers -all -max_routing_layer -min_routing_layer
#report_ignored_layers

set_app_option -name plan.pgroute.auto_connect_pg_net -value true

# ------------------------- Create_Vdd_GND ------------------------- #
create_net -power vdd
create_net -ground vss

hierarchical [include top module + sub modules]

connect_pg_net -net vdd [get_pins -hierarchical "*/VDD"]
connect_pg_net -net vss [get_pins -hierarchical "*/VSS"]

#P G   R I N G   C R E A T I O N

create_pg_ring_pattern ring_pattern -horizontal_layer M9    -horizontal_width {3} -horizontal_spacing {1}     -vertical_layer M8 -vertical_width {3}     -vertical_spacing {1} 


set_pg_strategy core_ring -core -pattern \
   {{pattern: ring_pattern}{nets: {vdd vss}}{offset: {0.5 0.5}}} \
    -extension {{stop: innermost_ring}}

compile_pg -strategies core_ring 

# ------------------------- PG MESH CREATION (Straps) ------------------------- #
create_pg_mesh_pattern pg_mesh1 -parameters {w1 p1 w2 p2 f t} -layers {{{vertical_layer: M8} {width: @w1} {spacing: interleaving}         {pitch: @p1} {offset: @f} {trim: @t}} {{horizontal_layer: M9 } {width: @w2} {spacing: interleaving} {pitch: @p2} {offset: @f} {trim: @t}}}


set_pg_strategy s_mesh1 \
   -pattern {{pattern: pg_mesh1} {nets: {vdd vss vss vdd}} \
{offset_start: 5 5} {parameters: 3 30 3 30 5 false}} \
   -core -extension {{stop: outermost_ring}}


compile_pg -strategies s_mesh1

# S T A N D A R D    C E L L    R A I L    I N S E R T I O N

create_pg_std_cell_conn_pattern std_cell_rail -layers {M1} -rail_width 0.06

set_pg_strategy rail_strat -core \
    -pattern {{name: std_cell_rail} {nets: vdd vss} }
    
compile_pg -strategies rail_strat   


# ------------------------- Check_Drc ------------------------- #
check_pg_drc 

# --------------------------- outputs --------------------------- #

save_block -as PowerPlanning RISCV_Top.dlib:PowerPlanning.design

write_verilog   /home/ICer/ASIC/RISCV/pnr/PowerPlanning/Power_Planning_netlist.v


# --------------------------- Report --------------------------- #

report_cell >   /home/ICer/ASIC/RISCV/pnr/PowerPlanning/PP_cells.rpt

report_qor  >   /home/ICer/ASIC/RISCV/pnr/PowerPlanning/PP_qor.rpt

report_timing -max_paths 10 >   /home/ICer/ASIC/RISCV/pnr/PowerPlanning/PP_timing.rpt

report_timing -delay min -max_paths 10 >   /home/ICer/ASIC/RISCV/pnr/PowerPlanning/PP_timing_hold.rpt

check_legality -verbose >  /home/ICer/ASIC/RISCV/pnr/PowerPlanning/Power_Planning_legalization.rpt

report_utilization >   /home/ICer/ASIC/RISCV/pnr/PowerPlanning/Power_Planning_legalization.rpt

