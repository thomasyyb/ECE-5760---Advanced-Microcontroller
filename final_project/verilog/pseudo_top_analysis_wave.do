onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pseudo_top_analysis_tb/clk
add wave -noupdate /pseudo_top_analysis_tb/reset
add wave -noupdate /pseudo_top_analysis_tb/DUT/pixel_x
add wave -noupdate /pseudo_top_analysis_tb/DUT/pixel_y
add wave -noupdate /pseudo_top_analysis_tb/DUT/count
add wave -noupdate /pseudo_top_analysis_tb/DUT/K
add wave -noupdate /pseudo_top_analysis_tb/DUT/fp_x
add wave -noupdate /pseudo_top_analysis_tb/DUT/fp_y
add wave -noupdate /pseudo_top_analysis_tb/DUT/done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1 ns}
