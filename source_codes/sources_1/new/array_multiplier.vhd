----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/31/2023 03:57:33 PM
-- Design Name: 
-- Module Name: array_multiplier - Behavioral
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

entity array_multiplier is
    Generic(
           WIDTHM: natural := 32;
           WIDTHQ: natural := 32;
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
end array_multiplier;

architecture Behavioral of array_multiplier is
type std_2d_long is array (WIDTHQ downto 0) of
    std_logic_vector(WIDTHM-1 downto 0);
type std_2d is array (WIDTHQ downto 0) of
    std_logic_vector(WIDTHM-1 downto 0);
signal m_s: std_2d_long;
signal s_i_s, s_o_s: std_2d;
signal q_s,q_s_o: STD_LOGIC_VECTOR(WIDTHQ-1 downto 0);
signal c_o_s: STD_LOGIC_VECTOR(WIDTHQ-1 downto 0);
signal product_s : STD_LOGIC_VECTOR(WIDTHM + WIDTHQ - 1 downto 0);
begin

 --assign input
 s_i_s(0) <= (others => '0');
 m_s(0) <= m_i;
 q_s <= q_i;
 mul_array:
 for i in 0 to WIDTHQ-1 generate
    cells:
    entity work.array_mult_row(behavioral)
        generic map (WIDTHM => WIDTHM)
        port map( m_i => m_s(i), --32
                  q_i => q_s(i),
                  s_i => s_i_s(i), --32
                  c_i => '0', 
                  m_o => m_s(i+1), --32
                  q_o => q_s_o(i),
                  s_o => s_o_s(i), --32
                  c_o => c_o_s(i));
    end generate;
    
    sum_signals:
    for i in 1 to WIDTHQ-1 generate
            s_i_s(i)(WIDTHM-2 downto 0) <= s_o_s(i-1)(WIDTHM-1 downto 1);
            s_i_s(i)(WIDTHM-1) <= c_o_s(i-1);
    end generate;
    
    assign_output_lower:
    for i in 0 to WIDTHQ-2 generate --WIDTHQ = 3, WIDTHM = 4
            product_s(i) <= s_o_s(i)(0);
    end generate;
    
    product_s((WIDTHM + WIDTHQ - 2) downto WIDTHQ-1) <= s_o_s(WIDTHQ-1);
    product_s(WIDTHM+WIDTHQ-1) <= c_o_s (WIDTHQ-1);
    
    product_o <= product_s(WIDTHP-1 downto 0);

end Behavioral;
