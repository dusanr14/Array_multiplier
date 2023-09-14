----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/01/2023 02:54:29 PM
-- Design Name: 
-- Module Name: array_mult_row - Behavioral
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

entity array_mult_row is
    Generic(
        WIDTHM : natural := 4
    );
    Port(m_i : in  STD_LOGIC_VECTOR(WIDTHM - 1 downto 0);
         q_i : in  STD_LOGIC;
         s_i : in  STD_LOGIC_VECTOR(WIDTHM - 1 downto 0);
         c_i : in  STD_LOGIC;
         m_o : out STD_LOGIC_VECTOR(WIDTHM - 1 downto 0);
         q_o : out STD_LOGIC;
         s_o : out STD_LOGIC_VECTOR(WIDTHM - 1 downto 0);
         c_o : out STD_LOGIC);
end array_mult_row;

architecture Behavioral of array_mult_row is
    signal q_s, c_s : STD_LOGIC_VECTOR(WIDTHM downto 0);
begin
    --assign inputs
    q_s(0) <= q_i;
    c_s(0) <= c_i;
    --assign outputs
    q_o    <= q_s(WIDTHM);
    c_o    <= c_s(WIDTHM);
    array_row : for i in 0 to WIDTHM - 1 generate
        first_row_cells : entity work.mul_array_cell(Behavioral)
            port map(m_i => m_i(i),
                     q_i => q_s(i),
                     s_i => s_i(i),
                     c_i => c_s(i),
                     m_o => m_o(i),
                     q_o => q_s(i + 1),
                     s_o => s_o(i),
                     c_o => c_s(i + 1));
    end generate;

end Behavioral;
