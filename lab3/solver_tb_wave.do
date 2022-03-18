onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /solver_tb/reset
add wave -noupdate /solver_tb/clk_50
add wave -noupdate -radix unsigned /solver_tb/out_iter
add wave -noupdate /solver_tb/in_max_iter
add wave -noupdate -radix unsigned /solver_tb/_solver/state_reg
add wave -noupdate /solver_tb/done_reg
add wave -noupdate -radix decimal /solver_tb/cr
add wave -noupdate -radix decimal /solver_tb/ci
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {58908 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 116
configure wave -valuecolwidth 116
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
WaveRestoreZoom {0 ps} {285088 ps}
