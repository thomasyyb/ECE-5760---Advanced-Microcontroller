onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /phasor_tb/clk
add wave -noupdate /phasor_tb/reset
add wave -noupdate -radix unsigned /phasor_tb/freq
add wave -noupdate /phasor_tb/mag
add wave -noupdate -format Analog-Step -height 74 -max -16071.0 -min -16141.0 /phasor_tb/DUT/sine_out
add wave -noupdate -format Analog-Step -height 74 -max 212979.00000000003 -min -409587.0 /phasor_tb/out
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
WaveRestoreZoom {0 ps} {315368 ps}
