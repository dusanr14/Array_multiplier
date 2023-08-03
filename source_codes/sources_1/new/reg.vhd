----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/03/2023 12:01:08 PM
-- Design Name: 
-- Module Name: reg - Behavioral
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

entity reg is
    Generic (WIDTH : natural :=32);
    Port ( clk : in STD_LOGIC;
           rstN : in STD_LOGIC;
           d_i : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
           q_o : out STD_LOGIC_VECTOR (WIDTH-1 downto 0));
end reg;

architecture Behavioral of reg is

begin
process(clk)
begin
    if(rising_edge(clk))then
        if(rstN = '0') then
            q_o <= (others => '0');
        else
            q_o <= d_i;
        end if;
    end if;
end process;

end Behavioral;
