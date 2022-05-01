onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /partialDFT_tb/clk
add wave -noupdate /partialDFT_tb/reset
add wave -noupdate -expand -group signed_mult_1 /partialDFT_tb/pit2
add wave -noupdate -expand -group signed_mult_1 /partialDFT_tb/r_2pi
add wave -noupdate -expand -group signed_mult_1 /partialDFT_tb/k
add wave -noupdate -expand -group signed_mult_1 /partialDFT_tb/kth
add wave -noupdate /partialDFT_tb/x
add wave -noupdate -expand -group nOverN /partialDFT_tb/n
add wave -noupdate -expand -group nOverN /partialDFT_tb/nOverN
add wave -noupdate -expand -group nOverN /partialDFT_tb/r_nOverN
add wave -noupdate -expand -group lookup /partialDFT_tb/theta
add wave -noupdate -expand -group lookup -radix unsigned /partialDFT_tb/address
add wave -noupdate -expand -group lookup /partialDFT_tb/DUT/cosine
add wave -noupdate -expand -group lookup /partialDFT_tb/DUT/sine
add wave -noupdate -expand -group output /partialDFT_tb/DUT/cos_ext
add wave -noupdate -expand -group output /partialDFT_tb/DUT/sin_ext
add wave -noupdate -expand -group output /partialDFT_tb/img_out
add wave -noupdate -expand -group output /partialDFT_tb/real_out
add wave -noupdate -expand -group output /partialDFT_tb/ri_o
add wave -noupdate -expand -group output /partialDFT_tb/rr_o
add wave -noupdate /partialDFT_tb/mem
add wave -noupdate -expand -group r /partialDFT_tb/DUT/r/out
add wave -noupdate -expand -group r /partialDFT_tb/DUT/r/mult_out
add wave -noupdate -expand -group r /partialDFT_tb/DUT/r/b
add wave -noupdate -expand -group r /partialDFT_tb/DUT/r/a
add wave -noupdate -expand -group i /partialDFT_tb/DUT/i/out
add wave -noupdate -expand -group i /partialDFT_tb/DUT/i/mult_out
add wave -noupdate -expand -group i /partialDFT_tb/DUT/i/b
add wave -noupdate -expand -group i /partialDFT_tb/DUT/i/a
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {308 ps} 0}
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
WaveRestoreZoom {0 ps} {1 ns}
