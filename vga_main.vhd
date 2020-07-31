library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga_main is
Port ( mclk, pause_sw : in std_logic;
	   reset : in std_logic;
	   PS2Clk : in std_logic;
	   PS2Data : in std_logic;
	   hsync, vsync : out std_logic;
	   red, green, blue : out std_logic_vector(3 downto 0));
end vga_main;

architecture Behavioral of vga_main is
signal clk25, clk50, data_on, ps2_code_new : std_logic;
signal ps2_code : std_logic_vector(7 downto 0);
signal hc, vc : std_logic_vector(9 downto 0);

component clkdiv
Port ( mclk : in std_logic;
	   clk25 : out std_logic;
	   clk50 : out std_logic );
end component;

component vga_drive
Port ( clk : in std_logic;
	   hsync, vsync : out std_logic;
	   hc, vc : out std_logic_vector(9 downto 0);
	   data_on : out std_logic
);
end component;

component ps2_keyboard
Port ( clk : IN STD_LOGIC;
	   ps2_clk : IN STD_LOGIC;
	   ps2_data : IN STD_LOGIC;
	   ps2_code_new : OUT STD_LOGIC;
	   ps2_code : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;
component vga_drawer

Port ( clk : in std_logic;
	   pause_sw : in std_logic;
	   ps2_code_new : in std_logic;
	   ps2_code : in std_logic_vector(7 downto 0);
	   data_on : in std_logic;
	   hc, vc : in std_logic_vector(9 downto 0);
	   reset : in std_logic;
	   red, green, blue : out std_logic_vector(3 downto 0));
end component;

begin
u1 : clkdiv port map ( mclk => mclk, clk25 => clk25, clk50 => clk50);
u2 : vga_drive port map ( clk => clk25, hsync => hsync, vsync => vsync, hc => hc,
vc => vc, data_on => data_on );
u3 : ps2_keyboard port map ( clk => clk50, ps2_clk => PS2Clk, ps2_data => PS2Data, ps2_code_new => ps2_code_new, ps2_code => ps2_code);
u4 : vga_drawer port map ( clk => clk25, pause_sw => pause_sw, ps2_code_new => ps2_code_new, ps2_code => ps2_code, data_on => data_on, hc => hc, vc => vc, reset => reset,
red => red, green => green, blue => blue);
end Behavioral;