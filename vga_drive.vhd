library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga_drive is
Port ( clk : in std_logic;
	   hsync, vsync : out std_logic;
	   hc, vc : out std_logic_vector(9 downto 0);
	   data_on : out std_logic
);
end vga_drive;

architecture Behavioral of vga_drive is
constant hpixels: std_logic_vector(9 downto 0) := "1100100000"; --800
constant vlines: std_logic_vector(9 downto 0) := "1000001001"; --521
constant hbp : std_logic_vector(9 downto 0) := "0010010000"; --144
constant hfp : std_logic_vector(9 downto 0) := "1100010000"; --784
constant vbp : std_logic_vector(9 downto 0) := "0000011111"; --31
constant vfp : std_logic_vector(9 downto 0) := "0111111111"; --511
signal hcs, vcs: std_logic_vector(9 downto 0);
signal enable: std_logic;

begin
process(clk, enable)
begin
	if(clk'event and clk = '1') then
		if hcs = hpixels - 1 then
			hcs <= "0000000000";
			enable <= '1';
		else
			hcs <= hcs + 1;
			enable <= '0';
		end if;
	end if;
end process;
hsync <= '0' when hcs <128 else '1';

process(clk,enable)
begin
	if(clk'event and clk = '1' and enable = '1') then
		if vcs = vlines - 1 then
			vcs <= "0000000000";
		else
			vcs <= vcs + 1;
		end if;
	end if;
end process;
vsync <= '0' when vcs < 2 else '1';

data_on <= '1' when (((hcs < hfp) and (hcs >= hbp)) and ((vcs < vfp) and (vcs >= vbp))) else '0';
hc <= hcs;
vc <= vcs;
end Behavioral;