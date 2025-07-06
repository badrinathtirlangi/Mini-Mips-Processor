#!/bin/bash

# Compile all Verilog files
iverilog -o sim memory.v registers.v instruction_fetch.v instruction_decode.v instruction_formats.v fpalu.v alu.v iitk_mini_mips.v iitk_mini_mips_tb.v

# Run the simulation
vvp sim

# Clean up
rm sim 