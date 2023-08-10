----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/09/2023 05:44:52 PM
-- Design Name: 
-- Module Name: array_multiplier_signed - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity array_multiplier_signed is
    Generic(
           -- first factor width
           WIDTHM: natural := 32;
           -- second factor width
           WIDTHQ: natural := 32;
           -- product width
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
end array_multiplier_signed;

architecture Behavioral of array_multiplier_signed is
signal m_i_s: STD_LOGIC_VECTOR(WIDTHM-1 downto 0);
signal q_i_s: STD_LOGIC_VECTOR(WIDTHQ-1 downto 0);
signal product_o_s: STD_LOGIC_VECTOR(WIDTHP-1 downto 0);
signal product_s: STD_LOGIC_VECTOR(WIDTHP-1 downto 0);
signal sign: std_logic;
signal sign_reg: STD_LOGIC_VECTOR(WIDTHQ/2 downto 0);
begin

-- first pipeline satage- determant sign of operands
process(clk)
begin
    if(rising_edge(clk))then
        if(rstN = '0') then
            m_i_s <= (others => '0');
            q_i_s <= (others => '0');
            sign <= '0';
        else
            if(m_i = 0) then
                m_i_s <= (others => '0');
            elsif(m_i(WIDTHM-1) = '1') then
                m_i_s <= not(std_logic_vector(unsigned(m_i) - 1));
            else
                m_i_s <= m_i;
            end if;
            if(q_i = 0) then
                q_i_s <= (others => '0');
            elsif(q_i(WIDTHQ-1) = '1') then
                q_i_s <= not(std_logic_vector(unsigned(q_i) - 1));
            else
                q_i_s <= q_i;
            end if;
            sign <= m_i(WIDTHM-1) xor q_i(WIDTHQ-1);
        end if;
    end if;
end process;

gen_if_even:
if(WIDTHQ mod 2 = 0) generate
    sign_reg(0) <= sign;
end generate;

gen_if_odd:
if(WIDTHQ mod 2 = 1) generate
   process(clk)
    begin
        if(rising_edge(clk))then
            if(rstN = '0') then
                sign_reg(0) <= '0';
            else
                sign_reg(0) <= sign;
            end if;
        end if;
    end process;
end generate;

generate_sign_pipeline:
for i in 1 to WIDTHQ/2 generate
    process(clk)
    begin
        if(rising_edge(clk))then
            if(rstN = '0') then
                sign_reg(i) <= '0';
            else
                sign_reg(i) <= sign_reg(i-1);
            end if;
        end if;
    end process;
end generate;

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
        m_i => m_i_s,
        q_i => q_i_s,
        product_o => product_o_s
    );

--last pipeline stage
process(clk)
begin
    if(rising_edge(clk)) then
        if(rstN = '0') then
            product_s <= (others => '0');
        else
            if(sign_reg(WIDTHQ/2) = '0') then
                product_s <= product_o_s;
            else
                product_s <= std_logic_vector(unsigned(not product_o_s) + 1);
            end if;
        end if;
    end if;
end process;

product_o <= product_s;
end Behavioral;
