library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity square_sum is
generic ( N : integer := 8; SAMPLES : integer := 256);

port (
  i_CLK : in std_logic;
  i_RST : in std_logic;
  i_START_SQUARE_SUM : in std_logic;
  i_ACCELERATION : in std_logic_vector(N-1 downto 0);
  o_SQUARE_SUM_DONE : out  std_logic;
  o_SQUARE_SUM : out std_logic_vector((N*8)-1 downto 0));
end square_sum;

architecture square_sum_arch of square_sum is
signal w_SQUARE_SUM  : signed((N*8)-1 downto 0) := (others => '0');
signal w_SQUARE_SUM_DONE : std_logic := '0';
signal w_COUNTER : integer range 0 to SAMPLES := 0;

begin
  
  process(i_CLK, i_RST, i_START_SQUARE_SUM, i_ACCELERATION, w_SQUARE_SUM, w_SQUARE_SUM_DONE, w_COUNTER )
  begin
   if (i_RST = '1') then
	  w_SQUARE_SUM_DONE <= '0';
	  w_SQUARE_SUM <= (others => '0');
	  w_COUNTER <= 0;
	elsif rising_edge(i_CLK) then
	  if i_START_SQUARE_SUM = '1' then
	    if w_COUNTER < SAMPLES then
		   w_SQUARE_SUM <= w_SQUARE_SUM + (signed(i_ACCELERATION) * signed(i_ACCELERATION));
		   w_COUNTER <= w_COUNTER + 1;
		 else 
			w_SQUARE_SUM_DONE <= '1';
			end if;		 
		end if;
	 end if;
  end process;
  
  o_SQUARE_SUM <= std_logic_vector(w_SQUARE_SUM);
  o_SQUARE_SUM_DONE <= w_SQUARE_SUM_DONE;
end square_sum_arch;