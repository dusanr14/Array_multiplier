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
    Generic(SIGNED_UNSIGNED : string  := "SIGNED";
            WIDTHM          : natural := 32;
            WIDTHQ          : natural := 32;
            WIDTHP          : natural := 32
           );
    Port(clk             : in  STD_LOGIC;
         rstN            : in  STD_LOGIC;
         -- multiplicand
         m_i             : in  STD_LOGIC_VECTOR(WIDTHM - 1 downto 0);
         m_valid_i       : in  STD_LOGIC;
         -- multiplier
         q_i             : in  STD_LOGIC_VECTOR(WIDTHQ - 1 downto 0);
         q_valid_i       : in  STD_LOGIC;
         -- product
         product_o       : out STD_LOGIC_VECTOR(WIDTHP - 1 downto 0);
         product_valid_o : out STD_LOGIC);
end array_multiplier_top;

architecture Behavioral of array_multiplier_top is
    signal product_valid_s   : STD_LOGIC;
    signal product_valid_reg : STD_LOGIC_VECTOR(WIDTHQ - 1 downto 0);
begin

    gen_if_even : if (WIDTHQ mod 2 = 0) generate
        product_valid_reg(0) <= m_valid_i and q_valid_i;
    end generate;

    gen_if_odd : if (WIDTHQ mod 2 = 1) generate
        process(clk)
        begin
            if (rising_edge(clk)) then
                if (rstN = '0') then
                    product_valid_reg(0) <= '0';
                else
                    product_valid_reg(0) <= m_valid_i and q_valid_i;
                end if;
            end if;
        end process;
    end generate;

    generate_unsigned_multiplier : if (SIGNED_UNSIGNED = "UNSIGNED") generate
        array_multiplier : entity work.array_multiplier
            generic map(
                WIDTHM => WIDTHM,
                WIDTHQ => WIDTHQ,
                WIDTHP => WIDTHP
            )
            port map(
                clk       => clk,
                rstN      => rstN,
                m_i       => m_i,
                q_i       => q_i,
                product_o => product_o
            );
        generate_valid : for i in 1 to WIDTHQ / 2 generate
            process(clk)
            begin
                if (rising_edge(clk)) then
                    if (rstN = '0') then
                        product_valid_reg(i) <= '0';
                    else
                        product_valid_reg(i) <= product_valid_reg(i - 1);
                    end if;
                end if;
            end process;
        end generate generate_valid;
        product_valid_s <= product_valid_reg(WIDTHQ / 2);
    end generate generate_unsigned_multiplier;

    generate_signed_multiplier : if (SIGNED_UNSIGNED = "SIGNED") generate
        array_multiplier : entity work.array_multiplier_signed
            generic map(
                WIDTHM => WIDTHM,
                WIDTHQ => WIDTHQ,
                WIDTHP => WIDTHP
            )
            port map(
                clk       => clk,
                rstN      => rstN,
                m_i       => m_i,
                q_i       => q_i,
                product_o => product_o
            );
        generate_valid : for i in 1 to WIDTHQ / 2 + 2 generate
            process(clk)
            begin
                if (rising_edge(clk)) then
                    if (rstN = '0') then
                        product_valid_reg(i) <= '0';
                    else
                        product_valid_reg(i) <= product_valid_reg(i - 1);
                    end if;
                end if;
            end process;
        end generate generate_valid;
        product_valid_s <= product_valid_reg(WIDTHQ / 2 + 2);
    end generate generate_signed_multiplier;

    product_valid_o <= product_valid_s;
end Behavioral;
