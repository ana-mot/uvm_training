.main clear
transcript file ""
transcript file transcript

vlog -sv -f filelist.f
vsim -voptargs=\"+acc\" +UVM_VERBOSITY=UVM_MEDIUM work.top



onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/in_if/clk
add wave -noupdate /top/in_if/rst_n
add wave -noupdate /top/in_if/sw_enable_in
add wave -noupdate /top/in_if/data_in
add wave -noupdate /top/in_if/read_out
add wave -noupdate {/top/out_if[0]/port_read}
add wave -noupdate {/top/out_if[0]/port_out}
add wave -noupdate {/top/out_if[0]/port_ready}
add wave -noupdate {/top/out_if[1]/port_read}
add wave -noupdate {/top/out_if[1]/port_out}
add wave -noupdate {/top/out_if[1]/port_ready}
add wave -noupdate {/top/out_if[2]/port_read}
add wave -noupdate {/top/out_if[2]/port_out}
add wave -noupdate {/top/out_if[2]/port_ready}
add wave -noupdate {/top/out_if[3]/port_read}
add wave -noupdate {/top/out_if[3]/port_out}
add wave -noupdate {/top/out_if[3]/port_ready}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {225 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1 ns}

run -all