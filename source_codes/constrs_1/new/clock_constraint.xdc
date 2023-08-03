#Clock signal
create_clock -add -name sys_clk_pin -period 8.30 -waveform {0 4.15} [get_ports {clk}];