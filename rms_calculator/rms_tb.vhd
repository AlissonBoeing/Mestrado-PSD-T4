library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rms_tb is
end rms_tb;

architecture tb_arch of rms_tb is
  constant CLK_PERIOD : time := 10 ns; -- Ajuste conforme necessário
  signal w_clk : std_logic := '0';
  signal w_rst : std_logic := '0';
  signal w_start_rms : std_logic := '0';
  signal w_samples : std_logic_vector(15 downto 0) := "0000000100000000"; --256
  signal w_square_root : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000001001010101010111110"; --305854
  signal w_value : std_logic_vector(63 downto 0);
  signal w_rms_done : std_logic;

  constant SIM_TIME : time := 300 ns; -- Ajuste conforme necessário
begin
  -- Instância da unidade RMS
  uut: entity work.rms
    generic map (N => 64)
    port map (
      i_CLK => w_clk,
      i_RST => w_rst,
      i_START_RMS => w_start_rms,
      i_SAMPLES => w_samples,
      i_SQUARE_ROOT => w_square_root,
      o_VALUE => w_value,
      o_RMS_DONE => w_rms_done
    );

  -- Processo de clock
  process
  begin
    w_CLK <= '0';
    wait for CLK_PERIOD / 2;
    w_CLK <= '1';
    wait for CLK_PERIOD / 2;
  end process;

  -- Processo de simulação
  process
  begin
    w_rst <= '1'; -- Ativar reset inicialmente
    wait for 20 ns;
    w_rst <= '0'; -- Desativar reset
    wait for 20 ns;
    w_start_rms <= '1'; -- Iniciar RMS
    wait for SIM_TIME; -- Esperar por um tempo arbitrário
--    start_rms <= ;0'; -- Parar RMS
    wait for 20 ns;
    assert w_rms_done = '1' report "Erro: o sinal o_RMS_DONE não está correto" severity error;
    report "Simulação concluída com sucesso!";
    wait;
  end process;
end tb_arch;