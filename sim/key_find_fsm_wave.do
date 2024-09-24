onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /key_find_fsm_tb/light
add wave -noupdate /key_find_fsm_tb/UUT/q_d
add wave -noupdate /key_find_fsm_tb/UUT/state
add wave -noupdate /key_find_fsm_tb/UUT/clk
add wave -noupdate /key_find_fsm_tb/task_wait
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {1 ps} 0}
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
WaveRestoreZoom {0 ps} {25 ps}
