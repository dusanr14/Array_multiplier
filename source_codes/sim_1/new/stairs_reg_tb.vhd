library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_stairs_registers is
end tb_stairs_registers;

architecture behavior of tb_stairs_registers is

    -- Component Declaration
    component stairs_registers
        Generic( WIDTH: natural := 15);
        Port ( clk : in STD_LOGIC;
               rstN : in STD_LOGIC;
               d_i : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
               q_o : out STD_LOGIC_VECTOR (WIDTH-1 downto 0));
    end component;

    -- Testbench Signals
    signal tb_clk : STD_LOGIC := '0';
    signal tb_rstN : STD_LOGIC := '1';
    signal tb_d_in : STD_LOGIC_VECTOR(14 downto 0) := (others => '0');
    signal tb_d_out : STD_LOGIC_VECTOR(14 downto 0);

begin

    -- Instantiate the IP
    uut: stairs_registers
        Generic Map (WIDTH => 15)
        Port Map (clk => tb_clk,
                  rstN => tb_rstN,
                  d_i => tb_d_in,
                  q_o => tb_d_out);

    -- Clock Generation Process
    clk_process: process
    begin
        tb_clk <= '0';
        wait for 10 ns;
        tb_clk <= '1';
        wait for 10 ns;
    end process clk_process;

    -- Reset Process
    reset_process: process
    begin
        tb_rstN <= '0';
        wait for 20 ns;
        tb_rstN <= '1';
        wait;
    end process reset_process;

    -- Stimulus Process
    stimulus_process: process
    begin
        tb_d_in <= "101010101010101"; -- Example input data
        wait for 300 ns;
        tb_d_in <= "111111111111111"; -- Another example input data
        wait for 300 ns;
        tb_d_in <= "000000000000000";
        wait;
    end process stimulus_process;

end behavior;
