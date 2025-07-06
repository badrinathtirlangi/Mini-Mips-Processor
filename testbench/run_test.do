# Create a new library
vlib work

# Compile all Verilog files
vlog memory.v
vlog registers.v
vlog instruction_fetch.v
vlog instruction_decode.v
vlog instruction_formats.v
vlog fpalu.v
vlog alu.v
vlog iitk_mini_mips.v
vlog iitk_mini_mips_tb.v

# Start simulation with the testbench
vsim -novopt work.iitk_mini_mips_tb

# Add all signals to the wave window
add wave -position insertpoint sim:/iitk_mini_mips_tb/*

# Run the simulation for 1000 ns
run 1000ns

# Zoom to fit
wave zoomfull 