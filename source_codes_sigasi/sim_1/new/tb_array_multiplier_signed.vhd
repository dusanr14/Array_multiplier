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
entity tb_array_multiplier_signed is
end tb_array_multiplier_signed;

architecture Behavioral of tb_array_multiplier_signed is
    -- Constants
    constant CLK_PERIOD : time := 10 ns;

    -- Signals
    signal clk      : std_logic := '0';
    signal rstN     : std_logic := '1';
    signal m_i      : std_logic_vector(8 downto 0) := (others => '0');
    signal q_i      : std_logic_vector(8 downto 0) := (others => '0');
    signal product_o : std_logic_vector(17 downto 0);

    -- Instantiate the DUT (Design Under Test)
    component array_multiplier_signed
        Generic(
               WIDTHM : natural := 9;
               WIDTHQ : natural := 9;
               WIDTHP : natural := 18
        );
        Port(
            clk      : in std_logic;
            rstN     : in std_logic;
            m_i      : in std_logic_vector(WIDTHM-1 downto 0);
            q_i      : in std_logic_vector(WIDTHQ-1 downto 0);
            product_o : out std_logic_vector(WIDTHP-1 downto 0)
        );
    end component;
    
    signal temp: std_logic_vector(17 downto 0) := (others => '0');
    signal expected_o: std_logic_vector(17 downto 0) := (others => '0');
    signal reg1, reg2, reg3, reg4, reg5,reg6,reg7: std_logic_vector(17 downto 0);
    signal good_flag: std_logic := '1';
begin
    
    process(clk)begin
        if(rising_edge(clk))then
            if(rstN = '0')then
                reg1 <= (others => '0');
                reg2 <= (others => '0');
                reg3 <= (others => '0');
                reg4 <= (others => '0');
                reg5 <= (others => '0');
                reg6 <= (others => '0');
                reg7 <= (others => '0');
            else
                reg1 <= std_logic_vector(signed(m_i) * signed(q_i));
                reg2 <= reg1;
                reg3 <= reg2;
                reg4 <= reg3;
                reg5 <= reg4;
                reg6 <= reg5;
                reg7 <= reg6;
            end if;
        end if;
    end process;
    -- Instantiate the DUT
    dut : array_multiplier_signed
        generic map (
            WIDTHM => 9,
            WIDTHQ => 9,
            WIDTHP => 18
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
        --wait for CLK_PERIOD/2;
        for_loop:
        for i in 0 to 262113 loop
            m_i <= temp(17 downto 9);
            q_i <= temp (8 downto 0);
            temp <= STD_LOGIC_VECTOR(unsigned(temp) + 1);
            wait for CLK_PERIOD;
       end loop for_loop;
        report "End";
        if(good_flag = '1') then
            report "Verified sucesfully!";
        else
            report "Bug occured!!!";
        end if;
        wait;
    end process;
    
    
    process(clk)
    begin
        if(rising_edge(clk) and (rstN='1'))then
            expected_o <= std_logic_vector(signed(m_i)* signed(q_i));
            if (reg7 /= product_o) then 
                report "BUG! expected = "& INTEGER'IMAGE(to_integer(signed(expected_o))) & 
                        ",real_value= " & INTEGER'IMAGE(to_integer(signed(product_o))) severity note;
                good_flag <= '0';   
            end if;
        end if;
    end process;
end Behavioral;
