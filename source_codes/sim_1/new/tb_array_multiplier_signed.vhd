library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_array_multiplier_signed is
end tb_array_multiplier_signed;

architecture testbench of tb_array_multiplier_signed is
    -- Constants
    constant CLOCK_PERIOD: time := 10 ns;
    
    -- Signals
    signal clk_tb: STD_LOGIC := '0';
    signal rstN_tb: STD_LOGIC := '0';
    signal m_i_tb: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal q_i_tb: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal product_o_tb: STD_LOGIC_VECTOR(31 downto 0);

    -- Instantiate the array_multiplier_signed
    component array_multiplier_signed
        Generic(
            WIDTHM: natural := 32;
            WIDTHQ: natural := 32;
            WIDTHP: natural := 32
        );
        Port (
            clk : in STD_LOGIC;
            rstN : in STD_LOGIC;
            m_i : in STD_LOGIC_VECTOR(WIDTHM-1 downto 0);
            q_i : in STD_LOGIC_VECTOR(WIDTHQ-1 downto 0);
            product_o : out STD_LOGIC_VECTOR(WIDTHP-1 downto 0)
        );
    end component;

begin
    -- Instantiate the DUT
    uut: array_multiplier_signed
        Generic map(
            WIDTHM => 32,
            WIDTHQ => 32,
            WIDTHP => 32
        )
        Port map (
            clk => clk_tb,
            rstN => rstN_tb,
            m_i => m_i_tb,
            q_i => q_i_tb,
            product_o => product_o_tb
        );

    -- Clock generation
    clk_process: process
    begin
        while now < 2000 ns loop  -- Simulate for 2000 ns
            clk_tb <= '0';
            wait for CLOCK_PERIOD / 2;
            clk_tb <= '1';
            wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Test stimulus process
    stim_proc: process
    begin
        -- Reset
        rstN_tb <= '0';
        wait for 10 ns;
        rstN_tb <= '1';

        -- Test cases
        m_i_tb <= X"FFFFFFFF"; -- -1
        q_i_tb <= X"FFFFFFFF"; -- -1
        wait for 20 ns;
        
        m_i_tb <= X"00000001"; -- 1
        q_i_tb <= X"00000002"; -- 2
        wait for 20 ns;
        
        m_i_tb <= X"FFFFFFFE"; -- -2
        q_i_tb <= X"00000003"; -- 3
        wait for 20 ns;
        
        m_i_tb <= X"00000004"; -- 4
        q_i_tb <= X"FFFFFFF5"; -- -11
        wait for 20 ns;
        
        -- Add more test cases here
         -- Test case 1: Positive * Positive
        m_i_tb <= X"00000007"; -- 7
        q_i_tb <= X"00000003"; -- 3
        wait for 20 ns;

        -- Test case 2: Negative * Negative
        m_i_tb <= X"FFFFFFFC"; -- -4
        q_i_tb <= X"FFFFFFFE"; -- -2
        wait for 20 ns;

        -- Test case 3: Positive * Negative
        m_i_tb <= X"00000005"; -- 5
        q_i_tb <= X"FFFFFFFA"; -- -6
        wait for 20 ns;

        -- Test case 4: Large Positive * Small Positive
        m_i_tb <= X"7FFFFFFF"; -- 2147483647
        q_i_tb <= X"00000003"; -- 3
        wait for 20 ns;

        -- Test case 5: Small Negative * Large Negative
        m_i_tb <= X"00000002"; -- 2
        q_i_tb <= X"80000000"; -- -2147483648
        wait for 20 ns;
        wait;
    end process;

end testbench;
