library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity rms is
generic ( N : integer := 64);
port (
  i_CLK : in std_logic;
  i_RST : in std_logic;
  i_START_RMS : in std_logic;
  i_SAMPLES : in std_logic_vector(15 downto 0);
  i_SQUARE_ROOT   : in std_logic_vector(N-1 downto 0);
  o_VALUE : out std_logic_vector(N-1 downto 0);
  o_RMS_DONE : out std_logic);
end rms;
 
architecture rms_arch of rms is
signal w_VALUE : signed(N-1 downto 0) := (others => '0');
signal w_RMS_DONE : std_logic := '0';

begin
  
  process(i_CLK, i_RST, i_SQUARE_ROOT, i_START_RMS)
  begin
  if i_RST = '1' then
    w_RMS_DONE <= '0';
	 w_VALUE <= signed(i_SQUARE_ROOT);
  elsif rising_edge(i_CLK) then
    if (i_START_RMS = '1') then 
	   w_VALUE <= signed(w_VALUE) / signed(i_SAMPLES);
	   w_RMS_DONE <= '1';
    end if;
  end if;
  end process;
  
  o_VALUE <= std_logic_vector(w_VALUE);
  o_RMS_DONE <= w_RMS_DONE;
  
end architecture;