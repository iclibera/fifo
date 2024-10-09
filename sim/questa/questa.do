# Sets up the directory
vlog -work work -sv sim/tb_fifo.sv hdl/fifo.sv
echo "Compilation Complete"

# Loads the simulation
vopt work.tb_fifo -o optimized_tb +acc
echo "Simulation loaded"

# Sets simulation library
vlib work

# Runs the simulation
vsim -vopt optimized_tb

# Applies simulation runtime options
add wave -position end -radix binary /tb_fifo/aclk_wr
add wave -position end -radix binary /tb_fifo/aclk_rd
add wave -position end -radix unsigned /tb_fifo/data_wr
add wave -position end -radix unsigned /tb_fifo/data_rd
# Leaf toggle
config wave -signalnamewidth 1

run -all
echo "Simulation run complete"

# stop
# quit