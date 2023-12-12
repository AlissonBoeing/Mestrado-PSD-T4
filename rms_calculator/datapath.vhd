library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity datapath is
generic ( N : integer := 8);
port (
  i_CLK : in std_logic;
  i_RST : in std_logic;
  i_START_SQUARE_SUM : in std_logic;
  i_START_RMS : in std_logic;
  i_SAMPLES: in std_logic_vector(15 downto 0);
  i_ACCELERATION : in std_logic_vector(N-1 downto 0);
  o_SQUARE_SUM_DONE : out std_logic;
  o_RMS_DONE: out std_logic;
  o_VALUE : out std_logic_vector((N*8) - 1 downto 0));
end datapath;

architecture datapath_arch of datapath is

component square_sum is
generic ( N : integer := 8);
port (
  i_CLK : in std_logic;
  i_RST : in std_logic;
  i_START_SQUARE_SUM : in std_logic;
  i_ACCELERATION : in std_logic_vector(N-1 downto 0);
  o_SQUARE_SUM_DONE : out  std_logic;
  o_SQUARE_SUM : out std_logic_vector((N*8)-1 downto 0));
end component;

component rms is
generic ( N : integer := 64);
port (
  i_CLK : in std_logic;
  i_RST : in std_logic;
  i_START_RMS : in std_logic;
  i_SAMPLES : in std_logic_vector(15 downto 0);
  i_SQUARE_ROOT   : in std_logic_vector(N-1 downto 0);
  o_VALUE : out std_logic_vector(N-1 downto 0);
  o_RMS_DONE : out std_logic);
end component;

signal w_SQUARE_SUM_DONE, w_RMS_DONE : std_logic := '0';
signal w_VALUE : std_logic_vector(63 downto 0) := (others => '0') ;
signal w_rms_value : std_logic_vector (63 downto 0) := (others => '0');

begin
   
  u_square : square_sum port map(
    i_CLK => i_CLK, 
	 i_RST => i_RST,
	 i_ACCELERATION => i_ACCELERATION,
	 i_START_SQUARE_SUM => i_START_SQUARE_SUM,
	 o_SQUARE_SUM_DONE => w_SQUARE_SUM_DONE,
	 o_SQUARE_SUM => w_VALUE);
  
  u_rms : rms port map( 
    i_CLK => i_CLK, 
	 i_RST => i_RST,
	 i_START_RMS => i_START_RMS, 
	 i_SQUARE_ROOT => w_VALUE, 
	 o_VALUE => w_rms_value, 
	 o_RMS_DONE => w_RMS_DONE,
	 i_SAMPLES => i_SAMPLES );
  
  o_RMS_DONE <= w_RMS_DONE; 
  o_SQUARE_SUM_DONE <= w_SQUARE_SUM_DONE;
  o_VALUE <= w_rms_value;

end architecture; 