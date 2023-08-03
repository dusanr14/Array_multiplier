----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/01/2023 05:09:01 PM
-- Design Name: 
-- Module Name: array_multiplier_top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity array_multiplier_top is
   Generic(
           WIDTHM: natural := 32;
           WIDTHQ: natural := 3;
           WIDTHP: natural := 32
    );
    Port ( clk : in STD_LOGIC;
           rstN : in STD_LOGIC;
           -- multiplicand
           m_i : in STD_LOGIC_VECTOR  (WIDTHM-1 downto 0);
           -- multiplier
           q_i : in STD_LOGIC_VECTOR  (WIDTHQ-1 downto 0);
           -- product
           product_o : out STD_LOGIC_VECTOR (WIDTHP-1 downto 0));
end array_multiplier_top;

architecture Behavioral of array_multiplier_top is
signal m_reg: STD_LOGIC_VECTOR  (WIDTHM-1 downto 0);
signal q_reg: STD_LOGIC_VECTOR  (WIDTHQ-1 downto 0);
signal product_reg, product_nxt: STD_LOGIC_VECTOR (WIDTHP-1 downto 0);
begin

process(clk)
begin
    if(rising_edge(clk)) then
        if(rstN = '0') then
            m_reg <= (others => '0');
            q_reg <= (others => '0');
            product_reg <= (others => '0');
        else
            m_reg <= m_i;
            q_reg <= q_i;
            product_reg <= product_nxt;
        end if;
    end if;
end process;
product_o <= product_reg;
array_multiplier: 
    entity work.array_multiplier
    generic map(
        WIDTHM => WIDTHM,
        WIDTHQ => WIDTHQ,
        WIDTHP => WIDTHP
    )
    port map(
        clk => clk,
        rstN => rstN,
        m_i => m_reg,
        q_i => q_reg,
        product_o => product_nxt
    );


end Behavioral;
