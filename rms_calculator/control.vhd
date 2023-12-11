library ieee;
use ieee.std_logic_1164.all;

entity control is 
port (
  i_CLK : in std_logic;
  i_RST : in std_logic; 
  i_GO : in std_logic;
  i_SQUARE_SUM_DONE : in std_logic;
  i_RMS_DONE : in std_logic;
  o_START_SQUARE_SUM : out std_logic;
  o_START_RMS : out std_logic);
end control;

architecture control_arch of control is
type t_STATE is (s_IDLE, s_SQUARE_SUM, s_RMS);
signal w_STATE, w_NEXT : t_STATE;

begin 

  process(i_RST, i_CLK, i_GO)
  begin
    if (i_RST = '1') then
	   w_STATE <= s_IDLE;
	 elsif rising_edge(i_CLK) then
	   w_STATE <= w_NEXT;
	 end if;
  end process;
  
  process(w_STATE, i_SQUARE_SUM_DONE, i_RMS_DONE)
  begin
    case w_STATE is
	   when s_IDLE => if (i_GO = '1') then
		  w_NEXT <= s_SQUARE_SUM;
		else
		  w_NEXT <= s_IDLE;
		end if;
		when s_SQUARE_SUM => if (i_SQUARE_SUM_DONE = '1') then
		  w_NEXT <= s_RMS;
		else
		  w_NEXT <= s_SQUARE_SUM;
		end if;
		when s_RMS =>  if (i_RMS_DONE = '1') THEN
		  w_NEXT <= s_IDLE;
		else
		  w_NEXT <= s_RMS;
		end if;  
		when others => w_NEXT <= s_IDLE;
	 end case;
  end process;
  
  o_START_SQUARE_SUM <= '1' when w_STATE = s_SQUARE_SUM else '0';
  o_START_RMS 		   <= '1' when w_STATE = s_RMS 	     else '0';
end architecture;