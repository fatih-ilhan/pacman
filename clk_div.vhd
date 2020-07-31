library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clkdiv is
Port ( mclk : in std_logic;
	   clk25 : out std_logic;
	   clk50 : out std_logic );
end clkdiv;

architecture Behavioral of clkdiv is
signal temp : std_logic_vector(2 downto 0) := "000";
begin
counter : process(mclk)
begin
	if rising_edge(mclk) then
		temp <= temp + 1;
	end if;
end process;
clk25 <= temp(1);
clk50 <= temp(0);
end Behavioral;