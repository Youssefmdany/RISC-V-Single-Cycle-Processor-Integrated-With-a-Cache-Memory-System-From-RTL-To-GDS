					# ndm script using icc2_lm_shell

# 1- create_workspace

create_workspace -flow exploration -technology /home/ICer/Library_cells/saed32nm_1p9m_mw.v10.tf  ndmtest
# 2- set_app_options

set_app_options -list {lib.workspace.keep_all_physical_cells {true}}
set_app_options -list {design.enable_lib_cell_editing {mutable}}
set_app_options -list {lib.workspace.save_design_views {true}}
set_app_options -list {lib.workspace.save_layout_views {true}}


# 3- read_db 

read_db { /home/ICer/Library_cells/saed32hvt_ff0p95v125c.db  /home/ICer/Library_cells/saed32hvt_ff1p16vn40c.db }

# 4- read_lef

read_lef /home/ICer/Library_cells/saed32nm_hvt_1p9m.lef

# 5- see layout view

#change_selection [get_designs -filter {view_name == design} {AND4X1}]
#current_block saed90nmEditted:AND4X1.design


# 6- create group


#saed90nm_max_lth.ndm

#reflib.ndm  >>>> re

group_libs



# 7- finaL Step will create the ndm

process_workspaces  -directory /home/ICer/ASIC/RISCV/pnr/ndm
