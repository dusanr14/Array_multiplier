----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/01/2023 12:09:19 PM
-- Design Name: 
-- Module Name: mul_array_cell - Behavioral
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

entity mul_array_cell is
    Port ( m_i : in STD_LOGIC;
           q_i : in STD_LOGIC;
           s_i : in STD_LOGIC;
           c_i : in STD_LOGIC;
           m_o : out STD_LOGIC;
           q_o : out STD_LOGIC;
           s_o : out STD_LOGIC;
           c_o : out STD_LOGIC);
end mul_array_cell;

architecture Behavioral of mul_array_cell is
signal m_s, q_s, b_s: STD_LOGIC;
begin
    m_s <= m_i;
    q_s <= q_i;
    b_s <= m_i and q_i;
    
    full_adder_1:
    entity work.full_adder
    port map(
        a_i => s_i,
        b_i => b_s,
        c_i => c_i,
        c_o => c_o,
        s_o => s_o
    );
    
    m_o <= m_s;
    q_o <= q_s;
end Behavioral;
