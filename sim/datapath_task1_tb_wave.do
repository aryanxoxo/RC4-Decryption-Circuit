onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /datapath_task1_testbench/address
add wave -noupdate /datapath_task1_testbench/clk
add wave -noupdate /datapath_task1_testbench/commenco
add wave -noupdate /datapath_task1_testbench/data
add wave -noupdate /datapath_task1_testbench/finito
add wave -noupdate /datapath_task1_testbench/q
add wave -noupdate /datapath_task1_testbench/wen
add wave -noupdate /datapath_task1_testbench/inst_task1/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {701 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 244
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {898 ps}
