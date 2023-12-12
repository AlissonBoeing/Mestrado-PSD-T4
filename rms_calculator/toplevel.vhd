library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity toplevel is
generic ( N : integer := 8);
port (
  i_CLK : in std_logic;
  i_RST : in std_logic;
  i_GO  : in std_logic;
  i_SAMPLES: in std_logic_vector((N*2) - 1 downto 0);
  i_ACCELERATION : in std_logic_vector(N-1 downto 0);
  o_VALUE_DONE: out std_logic;
  o_VALUE : out std_logic_vector((N*8) - 1 downto 0));
end toplevel;

architecture toplevel_arch of toplevel is

component datapath is
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
end component;

component control is
port (
  i_CLK : in std_logic;
  i_RST : in std_logic; 
  i_GO : in std_logic;
  i_SQUARE_SUM_DONE : in std_logic;
  i_RMS_DONE : in std_logic;
  o_START_SQUARE_SUM : out std_logic;
  o_START_RMS : out std_logic);
end component;

signal w_SQUARE_SUM_DONE, w_RMS_DONE, w_VALUE_DONE, w_START_SQUARE_SUM, w_START_RMS : std_logic := '0';
signal w_VALUE, w_VALUE_CLK : std_logic_vector(63 downto 0) := (others => '0') ;

begin

 u_datapath : datapath port map( 
	 i_CLK => i_CLK, 
	 i_RST => i_RST,
	 i_START_SQUARE_SUM => w_START_SQUARE_SUM,
	 
	 i_START_RMS => w_START_RMS,
	 i_SAMPLES => i_SAMPLES,
	 i_ACCELERATION => i_ACCELERATION,
	 o_SQUARE_SUM_DONE => w_SQUARE_SUM_DONE,
	 o_RMS_DONE => w_RMS_DONE,
	 o_VALUE => w_VALUE
	 );
   
  u_control : control port map(
    i_CLK => i_CLK, 
	 i_RST => i_RST,
	 i_GO => i_GO, 
	 i_RMS_DONE => w_RMS_DONE, 
	 i_SQUARE_SUM_DONE => w_SQUARE_SUM_DONE, 
	 o_START_SQUARE_SUM => w_START_SQUARE_SUM,
	 o_START_RMS => w_START_RMS
    );
  
	process(i_CLK)
	 begin
	   if rising_edge(i_CLK) then
		  w_VALUE_CLK <= w_VALUE;
		  w_VALUE_DONE <= w_RMS_DONE;
		end if;
   end process;
	
	o_VALUE <= w_VALUE_CLK;
	o_VALUE_DONE <= w_VALUE_DONE;

end architecture; 