#Clock signal
create_clock -add -name sys_clk_pin -period 8.70 -waveform {0 4.35} [get_ports {clk}];