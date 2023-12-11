library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tb_square_sum is
end tb_square_sum;

architecture testbench of tb_square_sum is
  constant CLK_PERIOD : time := 10 ns;  -- Período do clock
  signal tb_CLK : std_logic := '0';     -- Sinal de clock de teste
  signal tb_RST : std_logic := '0';     -- Sinal de reset de teste
  signal tb_START_SQUARE_SUM : std_logic := '0';  -- Sinal de início de soma dos quadrados de teste
  signal tb_ACCELERATION : std_logic_vector(7 downto 0);  -- Vetor de aceleração de teste
  signal tb_SQUARE_SUM_DONE : std_logic;  -- Sinal de conclusão da soma dos quadrados de teste
  signal tb_SQUARE_SUM : std_logic_vector(63 downto 0);  -- Saída da soma dos quadrados de teste
  
type acc_buffer is array (0 to 255) of std_logic_vector(7 downto 0);
  constant acc : acc_buffer := ("00001010", "00001000", "00000110", "00000100", "00000010", "00000000", "11111111", "11111110", "11111011", "11111001", "11111000", "11110101", "11110100", "11110010", "11110000", "11101110", "11101100", "11101011", "11101001", "11100111", "11100110", "11100100", "11100010", "11100001", "11011111", "11011101", "11011100", "11011011", "11011011", "11011001", "11011001", "11010111", "11010110", "11010110", "11010100", "11010100", "11010100", "11010011", "11010001", "11010001", "11010001", "11010001", "11010000", "11010001", "11010000", "11010000", "11010000", "11010000", "11010000", "11010000", "11010001", "11010000", "11010010", "11010001", "11010010", "11010010", "11010011", "11010100", "11010011", "11010101", "11010110", "11010110", "11010111", "11011001", "11011010", "11011011", "11011101", "11011110", "11100000", "11011111", "11100010", "11100100", "11100100", "11100110", "11101000", "11101001", "11101100", "11101110", "11101111", "11110010", "11110010", "11110101", "11110110", "11111000", "11111010", "11111011", "11111111", "00000000", "00000010", "00000100", "00000101", "00000111", "00001001", "00001010", "00001101", "00001111", "00010010", "00010100", "00010101", "00010110", "00011000", "00011001", "00011010", "00011110", "00011110", "00100001", "00100011", "00100010", "00100101", "00100111", "00101000", "00101001", "00101000", "00101010", "00101100", "00101101", "00101101", "00101110", "00110000", "00110001", "00110000", "00110001", "00110010", "00110010", "00110011", "00110010", "00110011", "00110011", "00110011", "00110100", "00110011", "00110010", "00110011", "00110010", "00110011", "00110010", "00110001", "00110001", "00110001", "00101111", "00101110", "00101110", "00101101", "00101101", "00101011", "00101010", "00101010", "00100111", "00100111", "00100110", "00100100", "00100100", "00100010", "00100001", "00011111", "00011101", "00011100", "00011010", "00011000", "00010110", "00010100", "00010011", "00010010", "00001101", "00001111", "00001101", "00001001", "00001000", "00000101", "00000100", "00000010", "00000000", "11111111", "11111101", "11111011", "11111010", "11110111", "11110111", "11110011", "11110001", "11110000", "11101101", "11101100", "11101011", "11101000", "11100111", "11100110", "11100010", "11100010", "11100000", "11011110", "11011101", "11011011", "11011011", "11011001", "11011000", "11011001", "11010101", "11010111", "11010101", "11010100", "11010101", "11010011", "11010010", "11010010", "11010001", "11010001", "11010001", "11010000", "11001110", "11001111", "11010000", "11010000", "11010001", "11010000", "11010001", "11010001", "11010001", "11010001", "11010001", "11010010", "11010010", "11010011", "11010100", "11010100", "11010101", "11010110", "11010111", "11011000", "11011001", "11011010", "11011100", "11011100", "11011110", "11011111", "11100000", "11100011", "11100011", "11100100", "11100111", "11101000", "11101010", "11101100", "11101111", "11110000", "11110000", "11110100", "11110101", "11110111", "11111010", "11111011", "11111101", "11111111", "00000000", "00000011", "00000100");

  -- Instância do componente
  COMPONENT square_sum
    generic ( N : integer := 8;
              SAMPLES : integer := 256 );
    port (
      i_CLK : in std_logic;
      i_RST : in std_logic;
      i_START_SQUARE_SUM : in std_logic;
      i_ACCELERATION : in std_logic_vector(N-1 downto 0);
      o_SQUARE_SUM_DONE : out std_logic;
      o_SQUARE_SUM : out std_logic_vector((N*8)-1 downto 0)
    );
  end component;

begin

  -- Instância do componente
  UUT : square_sum
    generic map (N => 8, SAMPLES => 256)
    port map (
      i_CLK => tb_CLK,
      i_RST => tb_RST,
      i_START_SQUARE_SUM => tb_START_SQUARE_SUM,
      i_ACCELERATION => tb_ACCELERATION,
      o_SQUARE_SUM_DONE => tb_SQUARE_SUM_DONE,
      o_SQUARE_SUM => tb_SQUARE_SUM
    );

  -- Processo de clock
  process
  begin
    while now < 5000 ns loop
      tb_CLK <= not tb_CLK after CLK_PERIOD / 2;
      wait for CLK_PERIOD / 2;
    end loop;
    wait;
  end process;
  
  -- Processo de estimulação
  process
  begin
    wait for 2 * CLK_PERIOD;  -- Aguarde alguns ciclos de clock antes de começar
    tb_RST <= '1';  -- Ative o reset
    wait for 2 * CLK_PERIOD;
    tb_RST <= '0';  -- Desative o reset
    wait for 2 * CLK_PERIOD;
    tb_START_SQUARE_SUM <= '1';  -- Inicie a soma dos quadrados
	 
		wait for CLK_PERIOD;
    -- Alimente o componente com o ACC_BUFFER estático
	
	teste: for i in 0 to 255 loop
	  tb_ACCELERATION <= acc(i);
	  wait for CLK_PERIOD;  -- Aguarde um ciclo de clock
	end loop;

    tb_START_SQUARE_SUM <= '0';  -- Pare a soma dos quadrados
    wait;
  end process;

  -- Processo de exibição
  process
  begin
    wait for 10 * CLK_PERIOD;
    report "SQUARE_SUM_DONE = ";
    report "SQUARE_SUM = " ;
    wait;
  end process;

end testbench;