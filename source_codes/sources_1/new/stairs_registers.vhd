----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/04/2023 02:45:00 PM
-- Design Name: 
-- Module Name: stairs_registers - Behavioral
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

entity stairs_registers is
    Generic( WIDTH: natural := 32);
    Port ( clk : in STD_LOGIC;
           rstN : in STD_LOGIC;
           d_i : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
           q_o : out STD_LOGIC_VECTOR (WIDTH-1 downto 0));
end stairs_registers;

architecture Behavioral of stairs_registers is
type std_2d_square is array (WIDTH-1 downto 0) of
    std_logic_vector(WIDTH-1 downto 0);
signal d_reg: std_2d_square;
begin


d_reg(0) <= d_i;

gen_stairs:
for j in 1 to WIDTH-1 generate
    gen_serial_registers:
    for i in 1 to j generate
        generate_reg:
        if(j mod 2 = 0) generate
            process(clk)
            begin
                if(rising_edge(clk))then
                    if(rstN = '0')then
                        d_reg(i)(j) <= '0';
                    else
                        d_reg(i)(j) <= d_reg(i-1)(j);
                    end if;
                end if;
             end process;
        end generate generate_reg;
    end generate gen_serial_registers;
end generate gen_stairs;

gen_stairs_wire:
for j in 1 to WIDTH-1 generate
    gen_serial_registers:
    for i in 1 to j generate
        generate_wires:
        if(j mod 2 /= 0) generate
            d_reg(i)(j) <= d_reg(i-1)(j);
        end generate ;
    end generate gen_serial_registers;
end generate gen_stairs_wire;

gen_output:
for i in 0 to WIDTH-1 generate
    q_o(i) <= d_reg(i)(i);
end generate;
end Behavioral;
