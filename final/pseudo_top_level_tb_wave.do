onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pseudo_top_level_tb/clk
add wave -noupdate -format Analog-Step -height 74 -max 16383.0 -min -16383.0 /pseudo_top_level_tb/DUT/out1
add wave -noupdate -format Analog-Step -height 74 -max 114681.0 -min -114681.0 /pseudo_top_level_tb/DUT/out2
add wave -noupdate -format Analog-Step -height 74 -max 126406.0 -min -126406.0 /pseudo_top_level_tb/DUT/sum
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {27150 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {105158 ps}
