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
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.math_real.all;
entity simple_tb is
end simple_tb;

architecture Behavioral of simple_tb is
    -- Constants
    constant CLK_PERIOD : time := 10 ns;

    -- Signals
    signal clk      : std_logic := '0';
    signal rstN     : std_logic := '1';
    signal m_i      : std_logic_vector(7 downto 0) := (others => '0');
    signal q_i      : std_logic_vector(7 downto 0) := (others => '0');
    signal product_o : std_logic_vector(15 downto 0);

    -- Instantiate the DUT (Design Under Test)
    component array_multiplier
        Generic(
               WIDTHM : natural := 8;
               WIDTHQ : natural := 8;
               WIDTHP : natural := 16
        );
        Port(
            clk      : in std_logic;
            rstN     : in std_logic;
            m_i      : in std_logic_vector(WIDTHM-1 downto 0);
            q_i      : in std_logic_vector(WIDTHQ-1 downto 0);
            product_o : out std_logic_vector(WIDTHP-1 downto 0)
        );
    end component;
    
    signal temp: std_logic_vector(9 downto 0) := (others => '0');
    signal expected_o: std_logic_vector(9 downto 0) := (others => '0');
begin
    
    -- Instantiate the DUT
    dut : array_multiplier
        generic map (
            WIDTHM => 8,
            WIDTHQ => 8,
            WIDTHP => 16
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
        rstN <= '1';
        wait for 3*CLK_PERIOD;
        rstN <= '0';
        wait for 2*CLK_PERIOD;
        rstN <= '1';
        wait for CLK_PERIOD;
        wait for 4*CLK_PERIOD;
         m_i <= "01010101";
         q_i <= "10101010";
         wait for CLK_PERIOD;
         m_i <= "11110101";
         q_i <= "00000010";
         wait for CLK_PERIOD;
         m_i <= "11110101";
         q_i <= "01000010";
        wait;
    end process;
end Behavioral;
