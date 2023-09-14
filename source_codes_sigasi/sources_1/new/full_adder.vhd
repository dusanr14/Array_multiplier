----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/31/2023 04:27:43 PM
-- Design Name: 
-- Module Name: full_adder - Behavioral
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

entity full_adder is
    Port(a_i : in  STD_LOGIC;
         b_i : in  STD_LOGIC;
         c_i : in  STD_LOGIC;
         c_o : out STD_LOGIC;
         s_o : out STD_LOGIC);
end full_adder;

architecture Behavioral of full_adder is

begin
    s_o <= a_i xor b_i xor c_i;
    c_o <= ((a_i and b_i) or (c_i and (a_i xor b_i)));
end Behavioral;
