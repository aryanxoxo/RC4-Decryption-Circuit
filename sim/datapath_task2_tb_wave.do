onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /datapath_task2_testbench/address
add wave -noupdate /datapath_task2_testbench/clk
add wave -noupdate /datapath_task2_testbench/commenco
add wave -noupdate /datapath_task2_testbench/data
add wave -noupdate /datapath_task2_testbench/finito
add wave -noupdate /datapath_task2_testbench/q
add wave -noupdate /datapath_task2_testbench/secret_key
add wave -noupdate /datapath_task2_testbench/wen
add wave -noupdate /datapath_task2_testbench/inst_task2a/finito
add wave -noupdate /datapath_task2_testbench/inst_task2a/state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 288
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
WaveRestoreZoom {0 ps} {850 ps}
