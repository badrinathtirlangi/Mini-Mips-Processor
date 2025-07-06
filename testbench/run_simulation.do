# Create work library
vlib work
vmap work work

# Compile all Verilog files
vlog instruction_formats.v
vlog instruction_decode.v
vlog alu.v
vlog fpalu.v
vlog registers.v
vlog iitk_mini_mips.v
vlog iitk_mini_mips_tb.v

# Start simulation
vsim -novopt work.iitk_mini_mips_tb

# Add waves
add wave -position insertpoint sim:/iitk_mini_mips_tb/*

# Run simulation
run -all

# Exit simulation
quit -f 