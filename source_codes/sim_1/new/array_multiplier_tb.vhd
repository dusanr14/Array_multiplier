----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/01/2023 04:59:43 PM
-- Design Name: 
-- Module Name: array_multiplier_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity array_multiplier_tb is
end array_multiplier_tb;

architecture Behavioral of array_multiplier_tb is
    -- Constants
    constant CLK_PERIOD : time := 10 ns;

    -- Signals
    signal clk      : std_logic := '0';
    signal rstN     : std_logic := '1';
    signal m_i      : std_logic_vector(3 downto 0) := "1101";
    signal q_i      : std_logic_vector(2 downto 0) := "101";
    signal product_o : std_logic_vector(6 downto 0);

    -- Instantiate the DUT (Design Under Test)
    component array_multiplier
        Generic(
               WIDTHM : natural := 4;
               WIDTHQ : natural := 3;
               WIDTHP : natural := 7
        );
        Port(
            clk      : in std_logic;
            rstN     : in std_logic;
            m_i      : in std_logic_vector(WIDTHM-1 downto 0);
            q_i      : in std_logic_vector(WIDTHQ-1 downto 0);
            product_o : out std_logic_vector(WIDTHP-1 downto 0)
        );
    end component;

begin
    -- Instantiate the DUT
    dut : array_multiplier
        generic map (
            WIDTHM => 4,
            WIDTHQ => 3,
            WIDTHP => 7
        )
        port map (
            clk      => clk,
            rstN     => rstN,
            m_i      => m_i,
            q_i      => q_i,
            product_o => product_o
        );

    -- Clock process
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Stimulus process
    stimulus_process: process
    begin
        -- Reset the module
        rstN <= '0';
        wait for CLK_PERIOD;
        rstN <= '1';
        wait for CLK_PERIOD;

        -- Test Case 1
        m_i <= "1101";
        q_i <= "101";
        wait for CLK_PERIOD * 10;
        -- The expected result for Test Case 1 should be "1001101"
        -- You can add an assert statement here to check if product_o is equal to "1001101"

        -- Test Case 2
--        m_i <= "0010";
--        q_i <= "011";
--        wait for CLK_PERIOD * 10;
--        -- Test Case 3
--        m_i <= "1111";
--        q_i <= "111";
--        wait for CLK_PERIOD * 10;
        
        -- The expected result for Test Case 2 should be "000110"
        -- You can add an assert statement here to check if product_o is equal to "000110"

        -- Add more test cases as needed

        -- End the simulation
        wait;
    end process;

end Behavioral;
