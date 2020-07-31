library ieee;
use ieee.std_logic_1164.all;

entity ps2_keyboard is
	generic(
			clk_freq : integer := 50_000_000;
			debounce_counter_size : integer := 8);
	port(
		clk : in std_logic;
		ps2_clk : in std_logic;
		ps2_data : in std_logic;
		ps2_code_new : out std_logic;
		ps2_code : out std_logic_vector(7 downto 0));
	end ps2_keyboard;

	architecture logic of ps2_keyboard is
	signal sync_ffs : std_logic_vector(1 downto 0);
	signal ps2_clk_int : std_logic;
	signal ps2_data_int : std_logic;
	signal ps2_word : std_logic_vector(10 downto 0);
	signal error : std_logic;
	signal count_idle : integer range 0 to clk_freq/18_000;

	component debounce is
		generic(
				counter_size : integer);
		port(
			clk : in std_logic;
			button : in std_logic;
			result : out std_logic);
	end component;

begin

	process(clk)
	begin
		if(clk'event and clk = '1') then
			sync_ffs(0) <= ps2_clk;
		sync_ffs(1) <= ps2_data;
		end if;
	end process;

	debounce_ps2_clk: debounce
		generic map(counter_size => debounce_counter_size)
		port map(clk => clk, button => sync_ffs(0), result => ps2_clk_int);
	debounce_ps2_data: debounce
		generic map(counter_size => debounce_counter_size)
		port map(clk => clk, button => sync_ffs(1), result => ps2_data_int);
	process(ps2_clk_int)

	begin
		if(ps2_clk_int'event and ps2_clk_int = '0') then
			ps2_word <= ps2_data_int & ps2_word(10 downto 1);
		end if;
	end process;
	
	error <= not (not ps2_word(0) and ps2_word(10) and (ps2_word(9) xor ps2_word(8) xor
	ps2_word(7) xor ps2_word(6) xor ps2_word(5) xor ps2_word(4) xor ps2_word(3) xor
	ps2_word(2) xor ps2_word(1)));

	process(clk)
	begin
		if(clk'event and clk = '1') then
			if(ps2_clk_int = '0') then
				count_idle <= 0;
			elsif(count_idle /= clk_freq/18_000) then
				count_idle <= count_idle + 1;
			end if;
			if(count_idle = clk_freq/18_000 and error = '0') then
				ps2_code_new <= '1';
				ps2_code <= ps2_word(8 downto 1);
			else
				ps2_code_new <= '0';
			end if;
		end if;
	end process;
end logic;