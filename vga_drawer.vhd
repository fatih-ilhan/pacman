library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity vga_drawer is
Port ( clk : in std_logic;
	   pause_sw : in std_logic;
	   ps2_code_new : in std_logic;
	   ps2_code : in std_logic_vector(7 downto 0);
	   data_on : in std_logic;
	   hc, vc : in std_logic_vector(9 downto 0);
	   reset : in std_logic;
	   red, green, blue : out std_logic_vector(3 downto 0);
	   led : out std_logic_vector(2 downto 0));
end vga_drawer;

architecture Behavioral of vga_drawer is
type array15x15 is array (0 to 14, 0 to 14) of std_logic;
signal map_array : array15x15 := ("111111111111111",
								  "100001000100001",
								  "101101010101101",
								  "101101010101101",
								  "100000000000001",
								  "111011101110111",
								  "100010000010001",
								  "101011101110101",
								  "100000000000001",
								  "111011111110111",
								  "100000000000001",
								  "101101010101101",
								  "101101010101101",
								  "100001000100001",
								  "111111111111111");

signal check_array : array15x15 := ("000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000",
									"000000000000000");

signal check_array_i : array15x15;

signal food_array : array15x15 := ("000000000000000",
								   "011110111011110",
								   "010010101010010",
								   "010010101010010",
								   "011111111111110",
								   "000100000001000",
								   "011100000001110",
								   "010100000001010",
								   "011111111111110",
								   "000100000001000",
								   "011111111111110",
								   "010010101010010",
								   "010010101010010",
								   "001110111011110",
								   "000000000000000");

signal tempfood_array : array15x15 := ("000000000000000",
									   "011110111011110",
									   "010010101010010",
									   "010010101010010",
									   "011111111111110",
									   "000100000001000",
									   "011100000001110",
									   "010100000001010",
									   "011111111111110",
									   "000100000001000",
									   "011111111111110",
									   "010010101010010",
									   "010010101010010",
									   "001110111011110",
									   "000000000000000");

signal tempfood_array_i : array15x15;

signal rightmove_array : array15x15 := ("000000000000000",
										"011100110011100",
										"000000000000000",
										"000000000000000",
										"011111111111100",
										"000000000000000",
										"011001111001100",
										"000000000000000",
										"011111111111100",
										"000000000000000",
										"011111111111100",
										"000000000000000",
										"000000000000000",
										"011100110011100",
										"000000000000000");

signal leftmove_array : array15x15 := ("000000000000000",
									   "001110011001110",
									   "000000000000000",
									   "000000000000000",
									   "001111111111110",
									   "000000000000000",
									   "001100111100110",
									   "000000000000000",
									   "001111111111110",
									   "000000000000000",
									   "001111111111110",
									   "000000000000000",
									   "000000000000000",
									   "001110011001110",
									   "000000000000000");

signal upmove_array : array15x15 := ("000000000000000",
									"000000000000000",
									"010010101010010",
									"010010101010010",
									"010010101010010",
									"000100010001000",
									"000100010001000",
									"010100010001010",
									"010100010001010",
									"000100000001000",
									"000100000001000",
									"010010101010010",
									"010010101010010",
									"010010101010010",
									"000000000000000");

signal downmove_array : array15x15 := ("000000000000000",
									   "010010101010010",
									   "010010101010010",
									   "010010101010010",
									   "000100010001000",
									   "000100010001000",
									   "010100010001010",
									   "010100010001010",
									   "000100000001000",
									   "000100000001000",
									   "010010101010010",
									   "010010101010010",
									   "010010101010010",
									   "000000000000000",
									   "000000000000000");

type array16x16 is array (0 to 15, 0 to 15) of std_logic;

signal ghost_array : array16x16 := ( "0000000000000000",
									 "0000111111110000",
									 "0111111111111110",
									 "1111111111111111",
									 "1111111111111111",
									 "1111000111100011",
									 "1111000111100011",
									 "1111111111111111",
									 "1111111111111111",
									 "1111111111111111",
									 "1111111111111111",
									 "1111111111111111",
									 "1111111111111111",
									 "1111111111111111",
									 "1101111001111011",
									 "1000110000110001");

signal pacman_array_r : array16x16 := ("0000000000000000",
									   "0000011111100000",
									   "0001111111111000",
									   "0011111111111100",
									   "0111111111111110",
									   "1111111111111110",
									   "1111111111100000",
									   "1111111000000000",
									   "1111111000000000",
									   "1111111111100000",
									   "1111111111111110",
									   "0111111111111110",
									   "0011111111111100",
									   "0001111111111000",
									   "0000011111100000",
									   "0000000000000000");

signal pacman_array_l : array16x16 := ("0000000000000000",
									   "0000011111100000",
									   "0001111111111000",
									   "0011111111111100",
									   "0111111111111110",
									   "0111111111111111",
									   "0000011111111111",
									   "0000000001111111",
									   "0000000001111111",
									   "0000011111111111",
									   "0111111111111111",
									   "0111111111111110",
									   "0011111111111100",
									   "0001111111111000",
									   "0000011111100000",
									   "0000000000000000");

signal pacman_array_u : array16x16 := ("0000000000000000",
									   "0000110000110000",
									   "0001110000111000",
									   "0011110000111100",
									   "0011110000111100",
									   "0111111001111110",
									   "0111111001111110",
									   "0111111001111110",
									   "0111111001111110",
									   "0111111111111110",
									   "0111111111111110",
									   "0011111111111100",
									   "0011111111111100",
									   "0001111111111000",
									   "0000111111110000",
									   "0000011111100000");

signal pacman_array_d : array16x16 := ("0000011111100000",
									   "0000111111110000",
									   "0001111111111000",
									   "0011111111111100",
									   "0011111111111100",
									   "0111111111111110",
									   "0111111111111110",
									   "0111111001111110",
									   "0111111001111110",
									   "0111111001111110",
									   "0111111001111110",
									   "0011110000111100",
									   "0011110000111100",
									   "0001110000111000",
									   "0000110000110000",
									   "0000000000000000");

type array5x3 is array (0 to 4, 0 to 2) of std_logic;

signal digit_array_0 : array5x3 := ("111", "101", "101", "101", "111");
signal digit_array_1 : array5x3 := ("001", "001", "001", "001", "001");
signal digit_array_2 : array5x3 := ("111", "001", "111", "100", "111");
signal digit_array_3 : array5x3 := ("111", "001", "111", "001", "111");
signal digit_array_4 : array5x3 := ("101", "101", "111", "001", "001");
signal digit_array_5 : array5x3 := ("111", "100", "111", "001", "111");
signal digit_array_6 : array5x3 := ("111", "100", "111", "101", "111");
signal digit_array_7 : array5x3 := ("111", "001", "001", "001", "001");
signal digit_array_8 : array5x3 := ("111", "101", "111", "101", "111");
signal digit_array_9 : array5x3 := ("111", "101", "111", "001", "111");
signal digit_array_P : array5x3 := ("111", "101", "101", "100", "100");
signal digit_array_L : array5x3 := ("100", "100", "100", "100", "111");
signal digit_array_W : array5x3 := ("101", "101", "000", "101", "111");
signal digit_array_NULL : array5x3 := ("000", "000", "000", "000", "000");

type array20x27 is array (0 to , 0 to 26) of std_logic;

signal heart_array : array20x27 := ("000000000000000000000000000",
									"000000111000000000111000000",
									"000001111110000011111100000",
									"000011111110000011111110000",
									"000011111111000111111110000",
									"000111111111101111111111000",
									"000111111111111111111111000",
									"000111111111111111111111000",
									"000111111111111111111111000",
									"000011111111111111111110000",
									"000001111111111111111100000",
									"000000111111111111111000000",
									"000000011111111111110000000",
									"000000001111111111100000000",
									"000000000111111111000000000",
									"000000000011111110000000000",
									"000000000001111100000000000",
									"000000000000111000000000000",
									"000000000000010000000000000",
									"000000000000000000000000000");

signal pacman_array : array16x16 := pacman_array_r;
signal pacman_array_i : array16x16;
signal digit10_array : array5x3 := digit_array_0;

signal digit1_array : array5x3 := digit_array_0;
signal ind_array : array5x3 := digit_array_0;

--ghost 1
signal hg1_su : integer := 7;
signal vg1_su : integer := 6;
signal hg1_sup : integer; -- initial positions
signal vg1_sup : integer;
signal hg1_su_i : integer;
signal vg1_su_i : integer;

--ghost 2
signal hg2_su : integer := 7;
signal vg2_su : integer := 6;
signal hg2_sup : integer; -- initial positions
signal vg2_sup : integer;
signal hg2_su_i : integer;
signal vg2_su_i : integer;

--pacman
signal hp_su : integer := 1;
signal vp_su : integer := 13;
signal hp_sup : integer; -- initial positions
signal vp_sup : integer;
signal hp_su_i : integer;
signal vp_su_i : integer;

signal h : integer := conv_integer(unsigned(hc));
signal v : integer := conv_integer(unsigned(vc));
signal count1, count2, count3 : integer := 0;
signal count4 : integer := 3;
signal temp1, temp4, flag: std_logic := '0';
signal temp2, temp3 : std_logic_vector(2 downto 0) := "000";
signal random : std_logic_vector(9 downto 0);
signal food_count : integer := 98;
signal lifepoints : integer := 3;
signal lifepoints_i : integer;
signal score : integer := 0;
signal score_i : integer;
signal score_digit10 : integer := 0;
signal score_digit1 : integer := 0;

type game_state is (play, won, lost);
signal current_state : game_state := play;
signal next_state : game_state := play;

signal prev_reset: std_logic;

type move_state is (up, down, left, right, stop);
signal current_dir : move_state;

begin

counter : process (clk)
begin
	if rising_edge(clk) then
		if count1 < 3333333 then -- 1/6 s
			count1 <= count1 +1;
		else
			count1 <= 0;
			temp1 <= not temp1;
		end if;

		if count2 < 25000000 then -- 1s (0-7s)
			count2 <= count2 + 1;
		else
			count2 <= 0;
			temp2 <= temp2 + 1;
			temp3 <= temp3 + 1;
			if count3 < 3 then
				count3 <= count3 + 1;
			else
				count3 <= 0;
				temp4 <= not temp4;
			end if;
		end if;
	end if;
end process;

direction : process(clk)

begin
	if rising_edge(clk) then
		if ps2_code_new = '0' then
			current_dir <= stop;
		else
			case ps2_code is
				when X"1D" => current_dir <= up;
				when X"1C" => current_dir <= left;
				when X"1B" => current_dir <= down;
				when X"23" => current_dir <= right;
				when others => current_dir <= stop;
			end case;
		end if;
	end if;
end process;

random_gen : process(clk)
variable r : std_logic_vector(9 downto 0) := "1100000001"; -- random
variable r_temp : std_logic := '0';

begin
	if rising_edge(temp1) then
		r_temp := r(9) xor r(8);
		r(9 downto 1) := r(8 downto 0);
		r(0) := r_temp;
	end if;
	random <= r;
end process;

state_assignment : process (clk)

begin
	if rising_edge(clk) then
		prev_reset <= reset;
	end if;
	if reset = '0' then -- reset state
		hg1_su_i <= 7;
		vg1_su_i <= 6;
		hg2_su_i <= 7;
		vg2_su_i <= 6;
		hp_su_i <= 1;
		vp_su_i <= 13;
		tempfood_array_i <= food_array;
		check_array_i <= (others => (others => '0'));
		pacman_array_i <= pacman_array_r;
		score_i <= 0;
		lifepoints_i <= 3;
		current_state <= play;
	else
		if prev_reset = '1' then
			current_state <= next_state;
			hg1_su_i <= hg1_su;
			vg1_su_i <= vg1_su;
			hg2_su_i <= hg2_su;
			vg2_su_i <= vg2_su;
			hp_su_i <= hp_su;
			vp_su_i <= vp_su;
			tempfood_array_i <= tempfood_array;
			check_array_i <= check_array;
			pacman_array_i <= pacman_array;
			score_i <= score;
			lifepoints_i <= lifepoints;
		end if;
	flag <= not flag;
	end if;
end process;

control : process (flag)
begin
	hg1_su <= hg1_su_i;
	vg1_su <= vg1_su_i;
	hg2_su <= hg2_su_i;
	vg2_su <= vg2_su_i;
	hp_su <= hp_su_i;
	vp_su <= vp_su_i;
	tempfood_array <= tempfood_array_i;
	check_array <= check_array_i;
	pacman_array <= pacman_array_i;
	score <= score_i;
	lifepoints <= lifepoints_i;
	if current_state = play then
		ind_array <= digit_array_NULL;
		if rising_edge(temp1) and pause_sw = '0' and reset = '1' then
			case current_dir is
				when right => if rightmove_array(vp_su_i, hp_su_i) = '1' then
					hp_su <= hp_su_i + 1;
					end if;
					tempfood_array(vp_su_i, hp_su_i) <= '0';
					if (check_array_i(vp_su_i, hp_su_i) = '0') and (food_array(vp_su_i, hp_su_i) = '1') then
						score <= score_i + 1;
					end if;
					check_array(vp_su_i, hp_su_i) <= '1';
					pacman_array <= pacman_array_r;
				when left => if leftmove_array(vp_su_i, hp_su_i) = '1' then
					hp_su <= hp_su_i - 1;
					end if;
					tempfood_array(vp_su_i, hp_su_i) <= '0';
					if (check_array_i(vp_su_i, hp_su_i) = '0') and (food_array(vp_su_i, hp_su_i) = '1') then
						score <= score_i + 1;
					end if;
					check_array(vp_su_i, hp_su_i) <= '1';
					pacman_array <= pacman_array_l;
				when up => if upmove_array(vp_su_i, hp_su_i) = '1' then
					vp_su <= vp_su_i - 1;
					end if;
					tempfood_array(vp_su_i, hp_su_i) <= '0';
					if (check_array_i(vp_su_i, hp_su_i) = '0') and (food_array(vp_su_i, hp_su_i) = '1') then
						score <= score_i + 1;
					end if;
					check_array(vp_su_i, hp_su_i) <= '1';
					pacman_array <= pacman_array_u;
				when down => if downmove_array(vp_su_i, hp_su_i) = '1' then
					vp_su <= vp_su_i + 1;
					end if;
					tempfood_array(vp_su_i, hp_su_i) <= '0';
					if (check_array_i(vp_su_i, hp_su_i) = '0') and (food_array(vp_su_i, hp_su_i) = '1') then
						score <= score_i + 1;
					end if;
					check_array(vp_su_i, hp_su_i) <= '1';
					pacman_array <= pacman_array_d;
				when stop => hp_su <= hp_su_i;
					vp_su <= vp_su_i;
			end case;

			if (hg1_su_i = hp_su_i) nand (vg1_su_i = vp_su_i) then
				if temp2 < 2 then
					case random(1 downto 0) is
						when "00" => if rightmove_array(vg1_su_i, hg1_su_i) = '1' then
							hg1_su <= hg1_su_i + 1;
							else
								if upmove_array(vg1_su_i, hg1_su_i) = '1' then
									vg1_su <= vg1_su_i - 1;
								else
									if leftmove_array(vg1_su_i, hg1_su_i) = '1' then
										hg1_su <= hg1_su_i - 1;
									else
										if downmove_array(vg1_su_i, hg1_su_i) = '1' then
											vg1_su <= vg1_su_i + 1;
										end if;
									end if;
								end if;
							end if;
						when "01" => if upmove_array(vg1_su_i, hg1_su_i) = '1' then
							vg1_su <= vg1_su_i - 1;
							else
								if leftmove_array(vg1_su_i, hg1_su_i) = '1' then
									hg1_su <= hg1_su_i - 1;
								else
									if downmove_array(vg1_su_i, hg1_su_i) = '1' then
										vg1_su <= vg1_su_i + 1;
									else
										if rightmove_array(vg1_su_i, hg1_su_i) = '1' then
											hg1_su <= hg1_su_i + 1;
										end if;
									end if;
								end if;
							end if;
						when "10" => if leftmove_array(vg1_su_i, hg1_su_i) = '1' then
							hg1_su <= hg1_su_i - 1;
							else
								if upmove_array(vg1_su_i, hg1_su_i) = '1' then
									vg1_su <= vg1_su_i - 1;
								else
									if rightmove_array(vg1_su_i, hg1_su_i) = '1' then
										hg1_su <= hg1_su_i + 1;
									else
										if downmove_array(vg1_su_i, hg1_su_i) = '1' then
											vg1_su <= vg1_su_i + 1;
										end if;
									end if;
								end if;
							end if;
						when "11" => if downmove_array(vg1_su_i, hg1_su_i) = '1' then
							vg1_su <= vg1_su_i + 1;
							else
								if upmove_array(vg1_su_i, hg1_su_i) = '1' then
									vg1_su <= vg1_su_i - 1;
								else
									if rightmove_array(vg1_su_i, hg1_su_i) = '1' then
										hg1_su <= hg1_su_i + 1;
									else
										if leftmove_array(vg1_su_i, hg1_su_i) = '1' then
											hg1_su <= hg1_su_i - 1;
										end if;
									end if;
								end if;
							end if;
					end case;
				else
					if hg1_su_i < hp_su_i then
						if vg1_su_i < vp_su_i then
							if (hp_su_i - hg1_su_i) > (vp_su_i - vg1_su_i) then
								if rightmove_array(vg1_su_i, hg1_su_i) = '1' then
									hg1_su <= hg1_su_i + 1;
								else
									if downmove_array(vg1_su_i, hg1_su_i) = '1' then
										vg1_su <= vg1_su_i + 1;
									else
										if upmove_array(vg1_su_i, hg1_su_i) = '1' then
											vg1_su <= vg1_su_i - 1;
										else
											if leftmove_array(vg1_su_i, hg1_su_i) = '1' then
												hg1_su <= hg1_su_i - 1;
											end if;
										end if;
									end if;
								end if;
							else
								if downmove_array(vg1_su_i, hg1_su_i) = '1' then
									vg1_su <= vg1_su_i + 1;
								else
									if rightmove_array(vg1_su_i, hg1_su_i) = '1' then
										hg1_su <= hg1_su_i + 1;
									else
										if upmove_array(vg1_su_i, hg1_su_i) = '1' then
											vg1_su <= vg1_su_i - 1;
										else
											if leftmove_array(vg1_su_i, hg1_su_i) = '1' then
												hg1_su <= hg1_su_i - 1;
											end if;
										end if;
									end if;
								end if;
							end if;
						elsif vg1_su_i > vp_su_i then
							if (hp_su_i - hg1_su_i) > (vp_su_i - vg1_su_i) then
								if rightmove_array(vg1_su_i, hg1_su_i) = '1' then
									hg1_su <= hg1_su_i + 1;
								else
									if upmove_array(vg1_su_i, hg1_su_i) = '1' then
										vg1_su <= vg1_su_i - 1;
									else
										if downmove_array(vg1_su_i, hg1_su_i) = '1' then
											vg1_su <= vg1_su_i + 1;
										else
											if leftmove_array(vg1_su_i, hg1_su_i) = '1' then
												hg1_su <= hg1_su_i - 1;
											end if;
										end if;
									end if;
								end if;
							else
								if upmove_array(vg1_su_i, hg1_su_i) = '1' then
									vg1_su <= vg1_su_i - 1;
								else
									if rightmove_array(vg1_su_i, hg1_su_i) = '1' then
										hg1_su <= hg1_su_i + 1;
									else
										if downmove_array(vg1_su_i, hg1_su_i) = '1' then
											vg1_su <= vg1_su_i + 1;
										else
											if leftmove_array(vg1_su_i, hg1_su_i) = '1' then
												hg1_su <= hg1_su_i - 1;

											end if;
										end if;
									end if;
								end if;
							end if;
						else
							if rightmove_array(vg1_su_i, hg1_su_i) = '1' then
								hg1_su <= hg1_su_i + 1;
							else
								if downmove_array(vg1_su_i, hg1_su_i) = '1' then
									vg1_su <= vg1_su_i + 1;
								else
									if upmove_array(vg1_su_i, hg1_su_i) = '1' then
										vg1_su <= vg1_su_i - 1;
									else
										if leftmove_array(vg1_su_i, hg1_su_i) = '1' then
											hg1_su <= hg1_su_i - 1;
										end if;
									end if;
								end if;
							end if;
						end if;
					elsif hg1_su_i > hp_su_i then
						if vg1_su_i < vp_su_i then
							if (hp_su_i - hg1_su_i) > (vp_su_i - vg1_su_i) then
								if leftmove_array(vg1_su_i, hg1_su_i) = '1' then
									hg1_su <= hg1_su_i - 1;
								else
									if downmove_array(vg1_su_i, hg1_su_i) = '1' then
										vg1_su <= vg1_su_i + 1;
									else
										if upmove_array(vg1_su_i, hg1_su_i) = '1' then
											vg1_su <= vg1_su_i - 1;
										else
											if rightmove_array(vg1_su_i, hg1_su_i) = '1' then
												hg1_su <= hg1_su_i + 1;
											end if;
										end if;
									end if;
								end if;
							else
								if downmove_array(vg1_su_i, hg1_su_i) = '1' then
									vg1_su <= vg1_su_i + 1;
								else
									if leftmove_array(vg1_su_i, hg1_su_i) = '1' then
										hg1_su <= hg1_su_i - 1;
									else
										if upmove_array(vg1_su_i, hg1_su_i) = '1' then
											vg1_su <= vg1_su_i - 1;
										else
											if rightmove_array(vg1_su_i, hg1_su_i) = '1' then
												hg1_su <= hg1_su_i + 1;
											end if;
										end if;
									end if;
								end if;
							end if;
						elsif vg1_su_i > vp_su_i then
							if (hp_su_i - hg1_su_i) > (vp_su_i - vg1_su_i) then
								if leftmove_array(vg1_su_i, hg1_su_i) = '1' then
									hg1_su <= hg1_su_i - 1;
								else
									if upmove_array(vg1_su_i, hg1_su_i) = '1' then
										vg1_su <= vg1_su_i - 1;
									else
										if downmove_array(vg1_su_i, hg1_su_i) = '1' then
											vg1_su <= vg1_su_i + 1;
										else
											if rightmove_array(vg1_su_i, hg1_su_i) = '1' then
												hg1_su <= hg1_su_i + 1;
											end if;
										end if;
									end if;
								end if;
							else
								if upmove_array(vg1_su_i, hg1_su_i) = '1' then
									vg1_su <= vg1_su_i - 1;
								else
									if leftmove_array(vg1_su_i, hg1_su_i) = '1' then
										hg1_su <= hg1_su_i - 1;
									else
										if downmove_array(vg1_su_i, hg1_su_i) = '1' then
											vg1_su <= vg1_su_i + 1;
										else
											if rightmove_array(vg1_su_i, hg1_su_i) = '1' then
												hg1_su <= hg1_su_i + 1;
											end if;
										end if;
									end if;
								end if;
							end if;
						else
							if leftmove_array(vg1_su_i, hg1_su_i) = '1' then
								hg1_su <= hg1_su_i - 1;
							else
								if upmove_array(vg1_su_i, hg1_su_i) = '1' then
									vg1_su <= vg1_su_i - 1;
								else
									if downmove_array(vg1_su_i, hg1_su_i) = '1' then
										vg1_su <= vg1_su_i + 1;
									else
										if rightmove_array(vg1_su_i, hg1_su_i) = '1' then
											hg1_su <= hg1_su_i + 1;
										end if;
									end if;
								end if;
							end if;
						end if;
					else
						if vg1_su_i < vp_su_i then
							if downmove_array(vg1_su_i, hg1_su_i) = '1' then
								vg1_su <= vg1_su_i + 1;
							else
								if leftmove_array(vg1_su_i, hg1_su_i) = '1' then
									hg1_su <= hg1_su_i - 1;
								else
									if upmove_array(vg1_su_i, hg1_su_i) = '1' then
										vg1_su <= vg1_su_i - 1;
									else
										if rightmove_array(vg1_su_i, hg1_su_i) = '1' then											
											hg1_su <= hg1_su_i + 1;
										end if;
									end if;
								end if;
							end if;
						elsif vg1_su_i > vp_su_i then
							if upmove_array(vg1_su_i, hg1_su_i) = '1' then
								vg1_su <= vg1_su_i - 1;
							else
								if leftmove_array(vg1_su_i, hg1_su_i) = '1' then
									hg1_su <= hg1_su_i - 1;
								else
									if downmove_array(vg1_su_i, hg1_su_i) = '1' then
										vg1_su <= vg1_su_i + 1;
									else
										if rightmove_array(vg1_su_i, hg1_su_i) = '1' then
											hg1_su <= hg1_su_i + 1;
										end if;
									end if;
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
			if (hg2_su = hp_su) nand (vg2_su = vp_su) then
				if temp3 < 4 then
					case random(3 downto 2) is
						when "00" => if rightmove_array(vg2_su, hg2_su) = '1' then
							hg2_su <= hg2_su + 1;
							else
								if upmove_array(vg2_su, hg2_su) = '1' then
									vg2_su <= vg2_su - 1;
								else
									if leftmove_array(vg2_su, hg2_su) = '1' then
										hg2_su <= hg2_su - 1;
									else
										if downmove_array(vg2_su, hg2_su) = '1' then
											vg2_su <= vg2_su + 1;
										end if;
									end if;
								end if;
							end if;
						when "01" => if upmove_array(vg2_su, hg2_su) = '1' then
							vg2_su <= vg2_su - 1;
							else
								if leftmove_array(vg2_su, hg2_su) = '1' then
									hg2_su <= hg2_su - 1;
								else
									if downmove_array(vg2_su, hg2_su) = '1' then
										vg2_su <= vg2_su + 1;
									else
										if rightmove_array(vg2_su, hg2_su) = '1' then
											hg2_su <= hg2_su + 1;
										end if;
									end if;
								end if;
							end if;
						when "10" => if leftmove_array(vg2_su, hg2_su) = '1' then
							hg2_su <= hg2_su - 1;
							else
								if upmove_array(vg2_su, hg2_su) = '1' then
									vg2_su <= vg2_su - 1;
								else
									if rightmove_array(vg2_su, hg2_su) = '1' then
										hg2_su <= hg2_su + 1;
									else
										if downmove_array(vg2_su, hg2_su) = '1' then
											vg2_su <= vg2_su + 1;										
										end if;
									end if;
								end if;
							end if;
						when "11" => if downmove_array(vg2_su, hg2_su) = '1' then
							vg2_su <= vg2_su + 1;
							else
								if upmove_array(vg2_su, hg2_su) = '1' then
									vg2_su <= vg2_su - 1;
								else
									if rightmove_array(vg2_su, hg2_su) = '1' then
										hg2_su <= hg2_su + 1;
									else
										if leftmove_array(vg2_su, hg2_su) = '1' then
											hg2_su <= hg2_su - 1;
										end if;
									end if;
								end if;
							end if;
					end case;
				else
					if hg2_su < hp_su then
						if vg2_su < vp_su then
							if (hp_su - hg2_su) > (vp_su - vg2_su) then
								if downmove_array(vg2_su, hg2_su) = '1' then
									vg2_su <= vg2_su + 1;
								else
									if rightmove_array(vg2_su, hg2_su) = '1' then
										hg2_su <= hg2_su + 1;
									else
										if leftmove_array(vg2_su, hg2_su) = '1' then
											hg2_su <= hg2_su - 1;
										else
											if upmove_array(vg2_su, hg2_su) = '1' then
												vg2_su <= vg2_su - 1;
											end if;
										end if;
									end if;
								end if;
							else
								if rightmove_array(vg2_su, hg2_su) = '1' then
									hg2_su <= hg2_su + 1;
								else
									if downmove_array(vg2_su, hg2_su) = '1' then
										vg2_su <= vg2_su + 1;
									else
										if leftmove_array(vg2_su, hg2_su) = '1' then
											hg2_su <= hg2_su - 1;
										else
											if upmove_array(vg2_su, hg2_su) = '1' then
												vg2_su <= vg2_su - 1;
											end if;
										end if;	
									end if;
								end if;
							end if;
						elsif vg2_su > vp_su then
							if (hp_su - hg2_su) > (vp_su - vg2_su) then
								if upmove_array(vg2_su, hg2_su) = '1' then
									vg2_su <= vg2_su - 1;
								else
									if rightmove_array(vg2_su, hg2_su) = '1' then
										hg2_su <= hg2_su + 1;
									else
										if leftmove_array(vg2_su, hg2_su) = '1' then
											hg2_su <= hg2_su - 1;
										else
											if downmove_array(vg2_su, hg2_su) = '1' then
												vg2_su <= vg2_su + 1;
											end if;
										end if;
									end if;
								end if;
							else
								if rightmove_array(vg2_su, hg2_su) = '1' then
									hg2_su <= hg2_su + 1;
								else									
									if upmove_array(vg2_su, hg2_su) = '1' then
										vg2_su <= vg2_su - 1;
									else
										if leftmove_array(vg2_su, hg2_su) = '1' then
											hg2_su <= hg2_su - 1;
										else
											if downmove_array(vg2_su, hg2_su) = '1' then
												vg2_su <= vg2_su + 1;
											end if;
										end if;
									end if;
								end if;
							end if;
						else
							if downmove_array(vg2_su, hg2_su) = '1' then
								vg2_su <= vg2_su + 1;
							else
								if rightmove_array(vg2_su, hg2_su) = '1' then
									hg2_su <= hg2_su + 1;
								else
									if leftmove_array(vg2_su, hg2_su) = '1' then
										hg2_su <= hg2_su - 1;
									else
										if upmove_array(vg2_su, hg2_su) = '1' then
											vg2_su <= vg2_su - 1;
										end if;
									end if;
								end if;
							end if;
						end if;
					elsif hg2_su > hp_su then
						if vg2_su < vp_su then
							if (hp_su - hg2_su) > (vp_su - vg2_su) then
								if downmove_array(vg2_su, hg2_su) = '1' then
									vg2_su <= vg2_su + 1;
								else
									if leftmove_array(vg2_su, hg2_su) = '1' then
										hg2_su <= hg2_su - 1;
									else
										if rightmove_array(vg2_su, hg2_su) = '1' then											
											hg2_su <= hg2_su + 1;
										else
											if upmove_array(vg2_su, hg2_su) = '1' then
												vg2_su <= vg2_su - 1;
											end if;
										end if;
									end if;
								end if;
							else
								if leftmove_array(vg2_su, hg2_su) = '1' then
									hg2_su <= hg2_su - 1;
								else
									if downmove_array(vg2_su, hg2_su) = '1' then
										vg2_su <= vg2_su + 1;
									else
										if rightmove_array(vg2_su, hg2_su) = '1' then
											hg2_su <= hg2_su + 1;
										else
											if upmove_array(vg2_su, hg2_su) = '1' then
												vg2_su <= vg2_su - 1;
											end if;
										end if;
									end if;
								end if;
							end if;
						elsif vg2_su > vp_su then
							if (hp_su - hg2_su) > (vp_su - vg2_su) then
								if upmove_array(vg2_su, hg2_su) = '1' then
									vg2_su <= vg2_su - 1;
								else
									if leftmove_array(vg2_su, hg2_su) = '1' then
										hg2_su <= hg2_su - 1;
									else
										if rightmove_array(vg2_su, hg2_su) = '1' then
											hg2_su <= hg2_su + 1;
										else
											if downmove_array(vg2_su, hg2_su) = '1' then
												vg2_su <= vg2_su + 1;
											end if;
										end if;
									end if;										
								end if;
							else
								if leftmove_array(vg2_su, hg2_su) = '1' then
									hg2_su <= hg2_su - 1;
								else
									if upmove_array(vg2_su, hg2_su) = '1' then
										vg2_su <= vg2_su + 1;
									else
										if rightmove_array(vg2_su, hg2_su) = '1' then
											hg2_su <= hg2_su + 1;
										else
											if downmove_array(vg2_su, hg2_su) = '1' then
												vg2_su <= vg2_su + 1;
											end if;
										end if;
									end if;
								end if;
							end if;
						else
							if upmove_array(vg2_su, hg2_su) = '1' then
								vg2_su <= vg2_su - 1;	
							else
								if leftmove_array(vg2_su, hg2_su) = '1' then
									hg2_su <= hg2_su - 1;
								else
									if rightmove_array(vg2_su, hg2_su) = '1' then
										hg2_su <= hg2_su + 1;
									else
										if downmove_array(vg2_su, hg2_su) = '1' then
											vg2_su <= vg2_su + 1;
										end if;
									end if;
								end if;
							end if;
						end if;
					else
						if vg2_su < vp_su then
							if leftmove_array(vg2_su, hg2_su) = '1' then
								hg2_su <= hg2_su - 1;
							else
								if downmove_array(vg2_su, hg2_su) = '1' then								
									vg2_su <= vg2_su + 1;
								else
									if rightmove_array(vg2_su, hg2_su) = '1' then
										hg2_su <= hg2_su + 1;
									else
										if upmove_array(vg2_su, hg2_su) = '1' then
											vg2_su <= vg2_su - 1;
										end if;
									end if;
								end if;
							end if;
						elsif vg2_su > vp_su then
							if leftmove_array(vg2_su, hg2_su) = '1' then
								hg2_su <= hg2_su - 1;
							else
								if upmove_array(vg2_su, hg2_su) = '1' then
									vg2_su <= vg2_su - 1;
								else
									if rightmove_array(vg2_su, hg2_su) = '1' then
										hg2_su <= hg2_su + 1;
									else
										if downmove_array(vg2_su, hg2_su) = '1' then
											vg2_su <= vg2_su + 1;
										end if;
									end if;
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
			if ((hg1_su_i = hp_su_i) and (vg1_su_i = vp_su_i)) or ((hg2_su = hp_su) and (vg2_su = vp_su)) then
				hg1_su <= 7;
				vg1_su <= 6;
				hg2_su <= 7;
				vg2_su <= 6;
				hp_su <= 1;
				vp_su <= 13;
				pacman_array <= pacman_array_r;
				lifepoints <= lifepoints_i - 1;
			end if;

			if lifepoints_i = 0 then
				next_state <= lost;
			else
				next_state <= play;
			end if;
			
			if score_i > 97 then
				next_state <= won;
			end if;
		end if;
	elsif current_state = won then	
		ind_array <= digit_array_W;
		next_state <= won;
	elsif current_state = lost then
		ind_array <= digit_array_L;
		next_state <= lost;
	end if;
end process;

drawing : process(data_on, hc, vc)
begin

red <= "0000";
green <= "0000";
blue <= "0000";

	hp_sup <= 152 + hp_su_i * 32;
	vp_sup <= 40 + vp_su_i * 32;
	hg1_sup <= 152 + hg1_su_i * 32;
	vg1_sup <= 40 + vg1_su_i * 32;
	hg2_sup <= 152 + hg2_su_i * 32;
	vg2_sup <= 40 + vg2_su_i * 32;

	if data_on = '1' then
		if lifepoints_i > 0 then
			if hc >= 640 and hc < 667 and vc >= 48 and vc < 68 then
				red <= heart_array((v-48), (h-640)) &
				heart_array((v-48), (h-640)) &
				heart_array((v-48), (h-640)) &
				heart_array((v-48), (h-640));
				blue <= heart_array((v-48), (h-640)) &
				heart_array((v-48), (h-640)) & '0' & '0';
			end if;
			if lifepoints_i > 1 then
				if hc >= 668 and hc < 695 and vc >= 48 and vc < 68 then
					red <= heart_array((v-48), (h-668)) &
					heart_array((v-48), (h-668)) &
					heart_array((v-48), (h-668)) &
					heart_array((v-48), (h-668));					
					blue <= heart_array((v-48), (h-668)) &
					heart_array((v-48), (h-668)) & '0' & '0';
				end if;
				if lifepoints_i > 2 then
					if hc >= 696 and hc < 723 and vc >= 48 and vc < 68 then
						red <= heart_array((v-48), (h-696)) &
						heart_array((v-48), (h-696)) &
						heart_array((v-48), (h-696)) &
						heart_array((v-48), (h-696));
						blue <= heart_array((v-48), (h-696)) &
						heart_array((v-48), (h-696)) & '0' & '0';
					end if;
				end if;
			end if;
		end if;

		if hc >= hp_sup and hc < hp_sup + 16 and vc >= vp_sup and vc < vp_sup + 16 then
			red <= pacman_array_i((v-vp_sup), (h-hp_sup)) &
			pacman_array_i((v-vp_sup), (h-hp_sup)) &
			pacman_array_i((v-vp_sup), (h-hp_sup)) &
			pacman_array_i((v-vp_sup), (h-hp_sup));
			green <= pacman_array_i((v-vp_sup), (h-hp_sup)) &
			pacman_array_i((v-vp_sup), (h-hp_sup)) &
			pacman_array_i((v-vp_sup), (h-hp_sup)) &
			pacman_array_i((v-vp_sup), (h-hp_sup));
		end if;

		if hc >= hg1_sup and hc < hg1_sup + 16 and vc >= vg1_sup and vc < vg1_sup + 16 then
			blue <= ghost_array((v-vg1_sup), (h-hg1_sup)) &
			ghost_array((v-vg1_sup), (h-hg1_sup)) &
			ghost_array((v-vg1_sup), (h-hg1_sup)) &
			ghost_array((v-vg1_sup), (h-hg1_sup));
			red <= '0' & ghost_array((v-vg1_sup), (h-hg1_sup)) & '0' & '0';
		end if;

		if hc >= hg2_sup and hc < hg2_sup + 16 and vc >= vg2_sup and vc < vg2_sup + 16 then
			red <= ghost_array((v-vg2_sup), (h-hg2_sup)) &
			ghost_array((v-vg2_sup), (h-hg2_sup)) &
			ghost_array((v-vg2_sup), (h-hg2_sup)) &
			ghost_array((v-vg2_sup), (h-hg2_sup));
			blue <= ghost_array((v-vg2_sup), (h-hg2_sup)) &
			ghost_array((v-vg2_sup), (h-hg2_sup)) &
			ghost_array((v-vg2_sup), (h-hg2_sup)) &
			ghost_array((v-vg2_sup), (h-hg2_sup));
			green <= "0000";
		end if;

		for i in 0 to 14 loop
			for j in 0 to 14 loop
				if(map_array(i,j) = '1') then
					if hc > 144 + 32*j and hc < 176 + 32*j and vc > 32 + 32*i and vc < 64 + 32*i then
						blue <= "1111";
					end if;
				end if;
				if(tempfood_array_i(i,j) = '1') then
					if hc > 156 + 32*j and hc < 164 + 32*j and vc > 44 + 32*i and vc < 52 + 32*i then
						green <= "1111";
					end if;
				end if;
			end loop;
		end loop;

		score_digit10 <= score_i / 10;
		score_digit1 <= score_i mod 10;
	end if;

	case score_digit10 is
		when 0 => digit10_array <= digit_array_0;
		when 1 => digit10_array <= digit_array_1;
		when 2 => digit10_array <= digit_array_2;
		when 3 => digit10_array <= digit_array_3;
		when 4 => digit10_array <= digit_array_4;
		when 5 => digit10_array <= digit_array_5;
		when 6 => digit10_array <= digit_array_6;
		when 7 => digit10_array <= digit_array_7;
		when 8 => digit10_array <= digit_array_8;
		when 9 => digit10_array <= digit_array_9;
		when others => digit10_array <= digit_array_0;
	end case;

	case score_digit1 is
		when 0 => digit1_array <= digit_array_0;
		when 1 => digit1_array <= digit_array_1;
		when 2 => digit1_array <= digit_array_2;
		when 3 => digit1_array <= digit_array_3;
		when 4 => digit1_array <= digit_array_4;
		when 5 => digit1_array <= digit_array_5;
		when 6 => digit1_array <= digit_array_6;
		when 7 => digit1_array <= digit_array_7;
		when 8 => digit1_array <= digit_array_8;
		when 9 => digit1_array <= digit_array_9;
		when others => digit1_array <= digit_array_0;
	end case;

	for i in 0 to 4 loop
		for j in 0 to 2 loop
			if(digit10_array(i,j) = '1') then
				if hc > 640 + 16*j and hc < 656 + 16*j and vc > 384 + 16*i and vc < 400 + 16*i then
					green <= "1111";
				end if;
			end if;
			if(digit1_array(i,j) = '1') then
				if hc > 704 + 16*j and hc < 720 + 16*j and vc > 384 + 16*i and vc < 400 + 16*i then
					green <= "1111";
				end if;
			end if;
			if(ind_array(i,j) = '1') then
				if hc > 640 + 16*j and hc < 656 + 16*j and vc > 160 + 16*i and vc < 176 + 16*i then
					red <= "1111";
				end if;
			end if;
		end loop;
	end loop;
end process;

light : process
begin
case current_dir is
	when up => led <= "000";
	when right => led <= "001";
	when left => led <= "010";
	when down => led <= "011";
	when stop => led <= "100";
end case;
end process;
end Behavioral;