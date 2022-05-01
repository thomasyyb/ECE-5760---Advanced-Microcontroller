# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
#vlog "./pseudo_top_analysis.sv"
#vlog "./fp_arithmetic.v"

vlog "./signed_mult.v"
vlog "./sync_rom.sv"
vlog "./partialDFT.sv"




# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
#vsim -voptargs="+acc" -t 1ps -lib work M10K_initializer_tb
#vsim -voptargs="+acc" -t 1ps -lib work pseudo_top_analysis_tb
#vsim -voptargs="+acc" -t 1ps -lib work drum_tb
vsim -voptargs="+acc" -t 1ps -lib work partialDFT_tb

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
#do M10K_initialize_tb_wave_v3.do
#do pseudo_top_analysis_wave.do
#do drum_tb_wave.do
do partialDFT_tb_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
