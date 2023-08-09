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
    Generic(EVEN_ODD: string := "EVEN";
            WIDTH: natural := 32);
    Port ( clk : in STD_LOGIC;
           rstN : in STD_LOGIC;
           d_i : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
           q_o : out STD_LOGIC_VECTOR (WIDTH-1 downto 0));
end stairs_registers;

architecture Behavioral of stairs_registers is
type std_2d_square is array (WIDTH-1 downto 0) of
    std_logic_vector(WIDTH-1 downto 0);
signal d_nxt, d_reg: std_2d_square;
begin


--not inportant
d_nxt(0) <= d_i;
d_reg(0) <= d_nxt(0);
gen_stairs_reg:
for i in 1 to WIDTH-1 generate
    --generate register every even step
    generate_even:
    if(EVEN_ODD = "EVEN") generate
        generate_reg_even:
        if(i mod 2 = 0) generate
        process(clk) begin
            if(rising_edge(clk))then
                if(rstN = '0')then
                    d_reg(i) <= (others => '0');
                else
                    d_reg(i) <= d_nxt(i);
                end if;
            end if;
        end process;
        end generate generate_reg_even;
        generate_wires_odd:
        if(i mod 2 = 1) generate
            d_reg(i) <= d_nxt(i);
        end generate;
    end generate generate_even;
    generate_odd:
    if(EVEN_ODD = "ODD") generate
        generate_reg_even:
        if(i mod 2 = 1) generate
        process(clk) begin
            if(rising_edge(clk))then
                if(rstN = '0')then
                    d_reg(i) <= (others => '0');
                else
                    d_reg(i) <= d_nxt(i);
                end if;
            end if;
        end process;
        end generate generate_reg_even;
        generate_wires_odd:
        if(i mod 2 = 0) generate
            d_reg(i) <= d_nxt(i);
        end generate;
    end generate generate_odd;
end generate gen_stairs_reg;

gen_wires:
for i in 1 to WIDTH-1 generate
    d_nxt(i) <= d_reg(i-1);
end generate;

-- LSB output
q_o(0) <= d_i(0);
gen_output:
for i in 1 to WIDTH-1 generate
    q_o(i) <= d_reg(i)(i);
end generate;
end Behavioral;